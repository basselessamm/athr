import '../domain/memory_contracts.dart';

/// A read-only projection of the current UserFavorite row used by the Phase 0
/// migration contract. The mapper deliberately ignores contentText and title:
/// legacy text is kept in the legacy table as a fallback, never copied into a
/// user memory source record.
class LegacyFavoriteRecord {
  final int id;
  final String contentType;
  final String primaryReference;
  final String? secondaryReference;
  final String title;
  final String contentText;
  final String source;
  final DateTime createdAt;

  const LegacyFavoriteRecord({
    required this.id,
    required this.contentType,
    required this.primaryReference,
    required this.secondaryReference,
    required this.title,
    required this.contentText,
    required this.source,
    required this.createdAt,
  });
}

class LegacyBookmarkRecord {
  final int surah;
  final double scrollOffset;

  const LegacyBookmarkRecord({required this.surah, required this.scrollOffset});
}

class MigrationCandidate {
  final String legacyKey;
  final MemoryThread thread;

  const MigrationCandidate({required this.legacyKey, required this.thread});
}

class MigrationSkip {
  final String legacyKey;
  final String reason;

  const MigrationSkip({required this.legacyKey, required this.reason});
}

class LegacyMigrationResult {
  final List<MigrationCandidate> acceptedFavorites;
  final List<MigrationSkip> skippedFavorites;
  final ReadingAnchor? bookmarkAnchor;

  const LegacyMigrationResult({
    required this.acceptedFavorites,
    required this.skippedFavorites,
    required this.bookmarkAnchor,
  });
}

/// Phase 0 mapping only. Persistence and Drift migrations belong to Phase 1;
/// this pure mapper makes the data contract testable before touching the app
/// database or UI.
class LegacyMemoryMigration {
  const LegacyMemoryMigration();

  LegacyMigrationResult map({
    required List<LegacyFavoriteRecord> favorites,
    LegacyBookmarkRecord? bookmark,
    DateTime? migrationTime,
  }) {
    final now = migrationTime ?? DateTime.utc(2026, 1, 1);
    final accepted = <MigrationCandidate>[];
    final skipped = <MigrationSkip>[];
    final seen = <String>{};

    for (final favorite in favorites) {
      final legacyKey = 'favorite:${favorite.id}';
      try {
        final source = _sourceReferenceFor(favorite);
        if (!seen.add(source.canonicalId)) {
          skipped.add(
            MigrationSkip(
              legacyKey: legacyKey,
              reason: 'duplicate_canonical_source',
            ),
          );
          continue;
        }

        accepted.add(
          MigrationCandidate(
            legacyKey: legacyKey,
            thread: MemoryThread(
              id: 'legacy-favorite-${favorite.id}',
              source: source,
              createdAt: favorite.createdAt,
              updatedAt: now,
            ),
          ),
        );
      } on FormatException catch (error) {
        skipped.add(MigrationSkip(legacyKey: legacyKey, reason: error.message));
      } on ArgumentError catch (error) {
        skipped.add(
          MigrationSkip(legacyKey: legacyKey, reason: error.toString()),
        );
      }
    }

    return LegacyMigrationResult(
      acceptedFavorites: List.unmodifiable(accepted),
      skippedFavorites: List.unmodifiable(skipped),
      bookmarkAnchor: bookmark == null ? null : _bookmarkAnchor(bookmark, now),
    );
  }

  SourceReference _sourceReferenceFor(LegacyFavoriteRecord favorite) {
    switch (favorite.contentType) {
      case 'verse':
        final parts = favorite.primaryReference.split(':');
        if (parts.length != 2) {
          throw FormatException('invalid_quran_verse_reference');
        }
        final surah = int.tryParse(parts[0]);
        final ayah = int.tryParse(parts[1]);
        if (surah == null || ayah == null) {
          throw FormatException('invalid_quran_verse_reference');
        }
        return SourceReference.quranVerse(
          surahNumber: surah,
          ayahNumber: ayah,
          sourceLabel: favorite.source,
        );
      case 'hadith':
        final book = favorite.secondaryReference;
        if (book == null || book.trim().isEmpty) {
          throw FormatException('missing_hadith_book_reference');
        }
        final bookId = _canonicalHadithBookId(book);
        return SourceReference.hadith(
          bookId: bookId,
          hadithId: favorite.primaryReference,
          sourceLabel: favorite.source,
          sourceBook: book,
        );
      case 'dua':
        final category = favorite.secondaryReference;
        if (category == null || category.trim().isEmpty) {
          throw FormatException('missing_dua_category_reference');
        }
        return SourceReference.dua(
          duaId: favorite.primaryReference,
          category: category,
          sourceLabel: favorite.source,
        );
      case 'azkar':
        final category = favorite.secondaryReference;
        if (category == null || category.trim().isEmpty) {
          throw FormatException('missing_azkar_category_reference');
        }
        return SourceReference.azkar(
          itemId: favorite.primaryReference,
          category: category,
          sourceLabel: favorite.source,
        );
      default:
        throw FormatException('unsupported_legacy_content_type');
    }
  }

  String _canonicalHadithBookId(String bookName) {
    switch (bookName.trim()) {
      case 'bukhari':
      case 'صحيح البخاري':
      case 'Sahih al-Bukhari':
        return 'bukhari';
      case 'muslim':
      case 'صحيح مسلم':
      case 'Sahih Muslim':
        return 'muslim';
      default:
        throw FormatException('unknown_hadith_book_reference');
    }
  }

  ReadingAnchor _bookmarkAnchor(
    LegacyBookmarkRecord bookmark,
    DateTime migrationTime,
  ) {
    if (bookmark.surah <= 0) {
      throw ArgumentError.value(bookmark.surah, 'bookmark.surah');
    }
    if (bookmark.scrollOffset < 0) {
      throw ArgumentError.value(bookmark.scrollOffset, 'bookmark.scrollOffset');
    }
    return ReadingAnchor(
      sourceCanonicalId: 'quran:surah:${bookmark.surah}',
      surahNumber: bookmark.surah,
      scrollOffset: bookmark.scrollOffset,
      updatedAt: migrationTime,
    );
  }
}

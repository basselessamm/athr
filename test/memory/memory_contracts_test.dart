import 'package:flutter_test/flutter_test.dart';

import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/memory/migration/legacy_memory_migration.dart';

void main() {
  group('SourceReference canonical contracts', () {
    test('creates an exact Quran verse identity', () {
      final source = SourceReference.quranVerse(
        surahNumber: 2,
        ayahNumber: 255,
        sourceLabel: 'القرآن الكريم',
        sourceVersion: 'bundled-v1',
      );

      expect(source.kind, SourceKind.quranVerse);
      expect(source.canonicalId, 'quran:verse:2:255');
      expect(source.sourceBook, 'القرآن الكريم');
      expect(source.sourceCitation, '2:255');
      expect(source.sourceVersion, 'bundled-v1');
    });

    test('creates distinct canonical identities for all supported content', () {
      final sources = <SourceReference>[
        SourceReference.quranVerse(
          surahNumber: 1,
          ayahNumber: 1,
          sourceLabel: 'Quran',
        ),
        SourceReference.hadith(
          bookId: 'bukhari',
          hadithId: '1',
          sourceLabel: 'Hadith source',
          sourceBook: 'صحيح البخاري',
        ),
        SourceReference.dua(
          duaId: 'dua-1',
          category: 'morning',
          sourceLabel: 'Dua source',
        ),
        SourceReference.azkar(
          itemId: 'azkar-1',
          category: 'evening',
          sourceLabel: 'Azkar source',
        ),
        SourceReference.quranReading(surahNumber: 36, sourceLabel: 'Quran'),
        SourceReference.situation(
          situationId: 'sad',
          sourceLabel: 'Situations editorial source',
        ),
      ];

      expect(sources.map((source) => source.canonicalId).toSet(), hasLength(6));
      expect(sources.map((source) => source.kind), hasLength(6));
    });

    test('does not allow invalid source coordinates', () {
      expect(
        () => SourceReference.quranVerse(
          surahNumber: 0,
          ayahNumber: 1,
          sourceLabel: 'Quran',
        ),
        throwsArgumentError,
      );
      expect(
        () => SourceReference.hadith(
          bookId: '',
          hadithId: '1',
          sourceLabel: 'Hadith',
        ),
        throwsArgumentError,
      );
    });
  });

  group('Source and user boundary', () {
    test(
      'a thread references source and stores no source text or user note in it',
      () {
        final source = SourceReference.quranVerse(
          surahNumber: 18,
          ayahNumber: 10,
          sourceLabel: 'القرآن الكريم',
        );
        final thread = MemoryThread(
          id: 'thread-1',
          source: source,
          context: const UserContext(kind: UserContextKind.returnTo),
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        );
        final reflection = ReflectionEntry(
          id: 'reflection-1',
          threadId: thread.id,
          body: 'ملاحظتي الخاصة',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        );

        expect(thread.source, same(source));
        expect(thread.context?.displayLabel, 'return_to');
        expect(reflection.threadId, thread.id);
        expect(reflection.body, isNot(source.sourceLabel));
        expect(thread.userLabel, isNull);
      },
    );

    test(
      'custom user context is explicit and separate from source provenance',
      () {
        const context = UserContext(
          kind: UserContextKind.custom,
          customLabel: 'أعود إليه عندما أحتاج سكينة',
        );

        expect(context.displayLabel, 'أعود إليه عندما أحتاج سكينة');
        expect(context.kind, UserContextKind.custom);
      },
    );
  });

  group('Legacy migration fixtures', () {
    final migration = const LegacyMemoryMigration();
    final createdAt = DateTime.utc(2025, 12, 31);

    test('maps supported legacy favorites without copying legacy text', () {
      final result = migration.map(
        migrationTime: DateTime.utc(2026, 1, 1),
        favorites: [
          LegacyFavoriteRecord(
            id: 1,
            contentType: 'verse',
            primaryReference: '2:255',
            secondaryReference: null,
            title: 'آية',
            contentText: 'نص الآية القديم',
            source: 'القرآن الكريم',
            createdAt: createdAt,
          ),
          LegacyFavoriteRecord(
            id: 2,
            contentType: 'hadith',
            primaryReference: '1',
            secondaryReference: 'صحيح البخاري',
            title: 'حديث',
            contentText: 'نص الحديث القديم',
            source: 'صحيح البخاري، حديث 1',
            createdAt: createdAt,
          ),
          LegacyFavoriteRecord(
            id: 3,
            contentType: 'dua',
            primaryReference: 'dua-7',
            secondaryReference: 'morning',
            title: 'دعاء',
            contentText: 'نص الدعاء القديم',
            source: 'حصن المسلم',
            createdAt: createdAt,
          ),
          LegacyFavoriteRecord(
            id: 4,
            contentType: 'azkar',
            primaryReference: 'azkar-8',
            secondaryReference: 'evening',
            title: 'ذكر',
            contentText: 'نص الذكر القديم',
            source: 'حصن المسلم',
            createdAt: createdAt,
          ),
        ],
      );

      expect(result.acceptedFavorites, hasLength(4));
      expect(result.skippedFavorites, isEmpty);
      expect(
        result.acceptedFavorites.map(
          (candidate) => candidate.thread.source.canonicalId,
        ),
        containsAll(<String>[
          'quran:verse:2:255',
          'hadith:bukhari:1',
          'dua:dua-7',
          'azkar:azkar-8',
        ]),
      );
      expect(
        result.acceptedFavorites.every(
          (candidate) => candidate.thread.userLabel == null,
        ),
        isTrue,
      );
    });

    test(
      'skips duplicate and malformed legacy records without deleting fallback rows',
      () {
        final result = migration.map(
          favorites: [
            LegacyFavoriteRecord(
              id: 10,
              contentType: 'verse',
              primaryReference: '2:255',
              secondaryReference: null,
              title: 'First',
              contentText: 'legacy text 1',
              source: 'Quran',
              createdAt: createdAt,
            ),
            LegacyFavoriteRecord(
              id: 11,
              contentType: 'verse',
              primaryReference: '2:255',
              secondaryReference: null,
              title: 'Duplicate',
              contentText: 'legacy text 2',
              source: 'Quran',
              createdAt: createdAt,
            ),
            LegacyFavoriteRecord(
              id: 12,
              contentType: 'verse',
              primaryReference: 'not-a-reference',
              secondaryReference: null,
              title: 'Malformed',
              contentText: 'keep in fallback',
              source: 'Quran',
              createdAt: createdAt,
            ),
            LegacyFavoriteRecord(
              id: 13,
              contentType: 'unknown',
              primaryReference: '1',
              secondaryReference: null,
              title: 'Unsupported',
              contentText: 'keep in fallback',
              source: 'Unknown',
              createdAt: createdAt,
            ),
            LegacyFavoriteRecord(
              id: 14,
              contentType: 'hadith',
              primaryReference: '2',
              secondaryReference: 'unknown-book',
              title: 'Unknown book',
              contentText: 'keep in fallback',
              source: 'Unknown book',
              createdAt: createdAt,
            ),
          ],
        );

        expect(result.acceptedFavorites, hasLength(1));
        expect(result.skippedFavorites, hasLength(4));
        expect(
          result.skippedFavorites.map((skip) => skip.reason),
          containsAll(<String>[
            'duplicate_canonical_source',
            'invalid_quran_verse_reference',
            'unsupported_legacy_content_type',
            'unknown_hadith_book_reference',
          ]),
        );
      },
    );

    test('migrates the single legacy Quran bookmark to a reading anchor', () {
      final result = migration.map(
        favorites: const [],
        bookmark: const LegacyBookmarkRecord(surah: 18, scrollOffset: 240.5),
        migrationTime: DateTime.utc(2026, 1, 1),
      );

      expect(result.bookmarkAnchor, isNotNull);
      expect(result.bookmarkAnchor!.sourceCanonicalId, 'quran:surah:18');
      expect(result.bookmarkAnchor!.surahNumber, 18);
      expect(result.bookmarkAnchor!.scrollOffset, 240.5);
    });

    test('rejects invalid legacy bookmark values', () {
      expect(
        () => migration.map(
          favorites: const [],
          bookmark: const LegacyBookmarkRecord(surah: 0, scrollOffset: 0),
        ),
        throwsArgumentError,
      );
      expect(
        () => migration.map(
          favorites: const [],
          bookmark: const LegacyBookmarkRecord(surah: 1, scrollOffset: -1),
        ),
        throwsArgumentError,
      );
    });
  });
}

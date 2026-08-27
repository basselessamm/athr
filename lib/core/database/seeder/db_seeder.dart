import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/utils/arabic_normalization.dart';
import 'package:midrar/features/azkar/application/zikr_repetition.dart';

/// Content revision per bundled dataset. Bump when the underlying asset
/// changes so existing installs re-import it on next launch of the feature.
const int kTafseerContentVersion = 3;
const int kHadithContentVersion = 2;
const int kDuasContentVersion = 3;

/// Expected individual zikr rows across all categories (schema v8 model).
const int kExpectedZikrCount = 298;

/// Ayah count per surah (Hafs 'an 'Asim) — the canonical 6236 total. Used to
/// compute the tafseer dataset's primary keys arithmetically instead of
/// shipping a 4 MB duplicate Quran text just for its id column.
const List<int> kHafsAyahCounts = <int>[
  7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99, 128,
  111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34, 30, 73,
  54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29, 18, 45, 60,
  49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12, 12, 30, 52, 52,
  44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19, 36, 25, 22, 17, 19,
  26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11, 11, 8, 3, 9, 5, 4, 7, 3,
  6, 3, 5, 4, 5, 6,
];

/// Maps tafseer-dataset primary keys (1..6236, in mushaf reading order) to
/// (surah, ayah). Verified against the original dataset: pk 1 = 1:1,
/// pk 8 = 2:1, pk 6236 = 114:6, strictly sequential.
Map<int, ({int surah, int ayah})> computeAyahPkMap() {
  final map = <int, ({int surah, int ayah})>{};
  var pk = 1;
  for (var surah = 1; surah <= kHafsAyahCounts.length; surah++) {
    for (var ayah = 1; ayah <= kHafsAyahCounts[surah - 1]; ayah++) {
      map[pk++] = (surah: surah, ayah: ayah);
    }
  }
  return map;
}

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seedAllIfNeeded() async {
    await seedTafseerIfNeeded();
    await seedDuasIfNeeded();
    await seedHadithIfNeeded();
  }

  /// Tafsir (Al-Muyassar): exactly one row per ayah of the Quran.
  Future<void> seedTafseerIfNeeded() async {
    const key = 'tafseer_muyassar';
    const expected = 6236;
    final marker = await _marker(key);
    if (_markerValid(marker, expected) &&
        await _countTable('quran_tafseer_table') >= expected) {
      return;
    }
    final tafseerString =
        await rootBundle.loadString('assets/json/tafseer.json');
    // JSON decoding is CPU-heavy on first install; keep it off the UI
    // isolate so Home stays responsive.
    final rows = await compute(_parseTafseerCompanions, tafseerString);
    await db.transaction(() async {
      await db.customStatement('DELETE FROM quran_tafseer_table');
      await db.batch((batch) => batch.insertAll(db.quranTafseerTable, rows));
      await _markComplete(key, expected, rows.length);
    });
  }

  Future<void> seedDuasIfNeeded() async {
    const key = 'duas';
    const expected = 134;
    final marker = await _marker(key);
    final zikrCount = await _countTable('zikr_table');
    if (_markerValid(marker, expected) &&
        await _countTable('dua_table') >= expected &&
        zikrCount >= kExpectedZikrCount) {
      return;
    }
    final duasString = await rootBundle.loadString('assets/json/duas.json');
    final inserts = await compute(_parseDuasCompanions, duasString);
    final zikrInserts = await compute(_parseZikrCompanions, duasString);
    await db.transaction(() async {
      await db.customStatement('DELETE FROM dua_table');
      await db.customStatement('DELETE FROM zikr_table');
      await db.batch((batch) => batch.insertAll(db.duaTable, inserts));
      await db.batch((batch) => batch.insertAll(db.zikrTable, zikrInserts));
      await _markComplete(key, expected, inserts.length);
    });
  }

  /// Each book is guarded independently so an interrupted import can never
  /// leave one sahih book permanently missing. User bookmarks survive
  /// content-version re-imports by reference matching.
  Future<void> seedHadithIfNeeded() async {
    await _seedBookIfNeeded(
      datasetKey: 'hadith_bukhari',
      asset: 'bukhari.json',
      bookTitle: 'صحيح البخاري',
      expectedCount: 7277,
    );
    await _seedBookIfNeeded(
      datasetKey: 'hadith_muslim',
      asset: 'muslim.json',
      bookTitle: 'صحيح مسلم',
      expectedCount: 7459,
    );
  }

  Future<void> _seedBookIfNeeded({
    required String datasetKey,
    required String asset,
    required String bookTitle,
    required int expectedCount,
  }) async {
    final marker = await _marker(datasetKey);
    if (_markerValid(marker, expectedCount) &&
        await _countBook(bookTitle) >= expectedCount) {
      return;
    }
    try {
      final hadithString = await rootBundle.loadString('assets/json/$asset');
      final inserts =
          await compute(_parseHadithCompanions, (hadithString, bookTitle));
      await db.transaction(() async {
        // Preserve user bookmarks across re-imports.
        final savedRefs = await (db.select(db.hadithTable)
              ..where(
                (t) =>
                    t.bookName.equals(bookTitle) & t.isBookmarked.equals(true),
              ))
            .get()
            .then(
              (rows) => rows
                  .map((r) => r.reference)
                  .whereType<String>()
                  .toSet(),
            );
        await db.customStatement(
          'DELETE FROM hadith_table WHERE book_name = ?',
          [bookTitle],
        );
        await db.batch((batch) => batch.insertAll(db.hadithTable, inserts));
        if (savedRefs.isNotEmpty) {
          for (final ref in savedRefs) {
            await db.customUpdate(
              'UPDATE hadith_table SET is_bookmarked = 1 '
              'WHERE book_name = ? AND reference = ?',
              variables: [Variable(bookTitle), Variable(ref)],
            );
          }
        }
        await _markComplete(datasetKey, expectedCount, inserts.length);
      });
    } catch (e) {
      throw Exception('تعذر تهيئة كتاب الحديث $bookTitle: $e');
    }
  }

  Future<SeedState?> _marker(String key) {
    return (db.select(db.seedStateTable)
          ..where((t) => t.datasetKey.equals(key)))
        .getSingleOrNull();
  }

  bool _markerValid(SeedState? marker, int expectedCount) {
    if (marker == null) return false;
    return marker.contentVersion >= kCurrentContentVersions[marker.datasetKey]! &&
        marker.actualCount >= expectedCount;
  }

  Future<int> _countTable(String table) async {
    final row = await db
        .customSelect('SELECT COUNT(*) AS c FROM $table')
        .getSingle();
    return row.read<int>('c');
  }

  Future<int> _countBook(String bookTitle) async {
    final row = await db
        .customSelect(
          'SELECT COUNT(*) AS c FROM hadith_table WHERE book_name = ?',
          variables: [Variable(bookTitle)],
        )
        .getSingle();
    return row.read<int>('c');
  }

  Future<void> _markComplete(String key, int expected, int actual) async {
    await db.into(db.seedStateTable).insertOnConflictUpdate(
          SeedStateTableCompanion.insert(
            datasetKey: key,
            contentVersion: kCurrentContentVersions[key]!,
            expectedCount: expected,
            actualCount: actual,
            seededAt: DateTime.now().toUtc().toIso8601String(),
          ),
        );
  }
}

const Map<String, int> kCurrentContentVersions = {
  'tafseer_muyassar': kTafseerContentVersion,
  'duas': kDuasContentVersion,
  'hadith_bukhari': kHadithContentVersion,
  'hadith_muslim': kHadithContentVersion,
};

/// Parses the individual zikr entries out of the category-keyed duas.json.
/// Each entry becomes its own row with a conservatively-parsed repetition
/// count and time marker (see zikr_repetition.dart for the guarantees).
List<ZikrTableCompanion> _parseZikrCompanions(String duasString) {
  final duasJson = jsonDecode(duasString) as Map<String, dynamic>;
  final inserts = <ZikrTableCompanion>[];
  duasJson.forEach((category, mapData) {
    final map = mapData as Map<String, dynamic>;
    final texts = (map['text'] as List<dynamic>)
        .map((t) => t?.toString() ?? '')
        .where((t) => t.trim().isNotEmpty)
        .toList(growable: false);
    for (var i = 0; i < texts.length; i++) {
      final text = texts[i];
      final repetition = parseZikrRepetition(text);
      inserts.add(
        ZikrTableCompanion.insert(
          category: category,
          zikrIndex: i + 1,
          zikrText: text,
          textNorm: Value(normalizeArabic('$category ${texts[i]}')),
          repetitionCount: Value(repetition.isExplicitInText ? repetition.target : null),
          repetitionLabel: Value(repetition.label),
          timeMarker: Value(
            repetition.marker == null
                ? null
                : (repetition.marker == ZikrTimeMarker.morning
                      ? 'morning'
                      : 'evening'),
          ),
        ),
      );
    }
  });
  return inserts;
}

// ---------------------------------------------------------------------------
// Parsing helpers (pure functions executed off the UI isolate via compute).
// ---------------------------------------------------------------------------

List<QuranTafseerTableCompanion> _parseTafseerCompanions(
  String tafseerString,
) {
  final ayahMapping = computeAyahPkMap();

  final tafseerJson = jsonDecode(tafseerString) as List<dynamic>;
  final seenPks = <int>{};
  final rows = <QuranTafseerTableCompanion>[];
  for (final item in tafseerJson) {
    final map = item as Map<String, dynamic>;
    if (map['model'] != 'quran_tafseer.tafseertext') continue;
    final fields = map['fields'] as Map<String, dynamic>;
    if (fields['tafseer'] != 1) continue;
    final pk = fields['ayah'] as int?;
    final mapping = pk == null ? null : ayahMapping[pk];
    if (mapping == null) continue;
    if (!seenPks.add(pk!)) continue; // guard against duplicate source rows
    rows.add(
      QuranTafseerTableCompanion.insert(
        surahNumber: mapping.surah,
        ayahNumber: mapping.ayah,
        tafseerText: fields['text'] as String,
      ),
    );
  }
  return rows;
}

List<DuaTableCompanion> _parseDuasCompanions(String duasString) {
  final duasJson = jsonDecode(duasString) as Map<String, dynamic>;
  final inserts = <DuaTableCompanion>[];
  duasJson.forEach((category, mapData) {
    final map = mapData as Map<String, dynamic>;
    final texts = (map['text'] as List<dynamic>)
        .map((t) => t?.toString() ?? '')
        .where((t) => t.trim().isNotEmpty)
        .toList(growable: false);
    final footnoteList = map['footnote'] as List<dynamic>?;
    final footnotes = footnoteList == null
        ? const <String>[]
        : footnoteList
            .map((t) => t?.toString() ?? '')
            .where((t) => t.trim().isNotEmpty)
            .toList(growable: false);

    final body = texts.join('\n');
    final reference = footnotes.isEmpty ? null : footnotes.join('\n');
    final fullText = reference == null ? body : '$body\n\n$reference';
    inserts.add(
      DuaTableCompanion.insert(
        category: category,
        duaText: fullText,
        duaTextNorm: Value(normalizeArabic('$category ${texts.join(' ')}')),
        reference: Value(reference),
      ),
    );
  });
  return inserts;
}

List<HadithTableCompanion> _parseHadithCompanions(
  (String hadith, String bookName) payload,
) {
  final hadithJson = jsonDecode(payload.$1) as Map<String, dynamic>;
  final fallbackBookName = payload.$2;
  final chapterMap = <int, String>{};
  for (final item in (hadithJson['chapters'] as List<dynamic>? ?? [])) {
    final chapter = item as Map<String, dynamic>;
    final id = chapter['id'];
    if (id != null) {
      chapterMap[id as int] = chapter['arabic']?.toString() ?? '';
    }
  }

  final metadata = hadithJson['metadata'] as Map<String, dynamic>?;
  final metadataArabic = metadata?['arabic'] as Map<String, dynamic>?;
  final sourceBookArabic =
      metadataArabic?['title']?.toString() ?? fallbackBookName;
  final rows = <HadithTableCompanion>[];
  for (final item in hadithJson['hadiths'] as List<dynamic>) {
    final hadith = item as Map<String, dynamic>;
    final english = hadith['english'];
    String? englishText;
    if (english is Map<String, dynamic>) {
      englishText =
          '${english['narrator']?.toString() ?? ''}\n${english['text']?.toString() ?? ''}'
              .trim();
    }
    final idInBook = hadith['idInBook']?.toString();
    final chapterName = hadith['chapterId'] is int
        ? chapterMap[hadith['chapterId'] as int]
        : null;
    final arabic = hadith['arabic']?.toString() ?? '';
    final reference = idInBook == null || idInBook.isEmpty
        ? sourceBookArabic
        : '$sourceBookArabic - حديث $idInBook';
    rows.add(
      HadithTableCompanion.insert(
        bookName: fallbackBookName,
        chapterName: Value(chapterName),
        reference: Value(reference),
        hadithTextAr: arabic,
        hadithTextArNorm: Value(
          normalizeArabic('$sourceBookArabic ${chapterName ?? ''} $arabic'),
        ),
        hadithTextEn: Value(englishText),
      ),
    );
  }
  return rows;
}

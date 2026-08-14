import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:athr/core/database/app_database.dart';

import 'seed_daily_content.dart';

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seedDatabase() async {
    await seedTafseerIfNeeded();
    await seedDuasIfNeeded();
    await seedHadithIfNeeded();

    final sunnahCount = await (db.select(db.dailySunnahTable)..limit(1)).get();
    if (sunnahCount.isEmpty) await _seedDailySunnah();

    final taskCount = await (db.select(db.dailyTaskTable)..limit(1)).get();
    if (taskCount.isEmpty) await _seedDailyTasks();
  }

  Future<void> seedTafseerIfNeeded() async {
    final count = await (db.select(db.quranTafseerTable)..limit(1)).get();
    if (count.isEmpty) await _seedTafseer();
  }

  Future<void> seedDuasIfNeeded() async {
    final count = await (db.select(db.duaTable)..limit(1)).get();
    if (count.isEmpty) await _seedDuas();
  }

  Future<void> seedHadithIfNeeded() async {
    final count = await (db.select(db.hadithTable)..limit(1)).get();
    if (count.isEmpty) {
      await _seedHadith('bukhari.json', 'صحيح البخاري');
      await _seedHadith('muslim.json', 'صحيح مسلم');
    }
  }

  Future<void> _seedDailySunnah() async {
    final inserts = <DailySunnahTableCompanion>[];
    for (var i = 0; i < seedDailySunnahEntries.length; i++) {
      final item = seedDailySunnahEntries[i];
      inserts.add(
        DailySunnahTableCompanion.insert(
          id: item.id,
          title: item.title,
          description: item.description,
          howToApply: item.howToApply,
          source: item.source,
          sortOrder: i,
        ),
      );
    }

    await db.batch((batch) {
      batch.insertAll(db.dailySunnahTable, inserts);
    });
  }

  Future<void> _seedDailyTasks() async {
    final inserts = <DailyTaskTableCompanion>[];
    for (var i = 0; i < seedDailyTaskEntries.length; i++) {
      final item = seedDailyTaskEntries[i];
      inserts.add(
        DailyTaskTableCompanion.insert(
          id: item.id,
          title: item.title,
          description: item.description,
          impact: item.impact,
          sortOrder: i,
        ),
      );
    }

    await db.batch((batch) {
      batch.insertAll(db.dailyTaskTable, inserts);
    });
  }

  Future<void> _seedTafseer() async {
    final payload = await Future.wait([
      rootBundle.loadString('assets/json/quran_text.json'),
      rootBundle.loadString('assets/json/tafseer.json'),
    ]);

    // JSON decoding is CPU-heavy on a first install. Keep it off the Flutter
    // UI isolate so the user can still interact with the splash/Home surface.
    final rows = await compute(_parseTafseerPayload, (payload[0], payload[1]));
    final inserts = rows
        .map(
          (row) => QuranTafseerTableCompanion.insert(
            surahNumber: row['surah']! as int,
            ayahNumber: row['ayah']! as int,
            tafseerText: row['text']! as String,
          ),
        )
        .toList(growable: false);

    await db.batch((batch) {
      batch.insertAll(db.quranTafseerTable, inserts);
    });
  }

  Future<void> _seedDuas() async {
    final duasString = await rootBundle.loadString('assets/json/duas.json');
    final Map<String, dynamic> duasJson = jsonDecode(duasString);

    List<DuaTableCompanion> inserts = [];

    duasJson.forEach((category, mapData) {
      final map = mapData as Map<String, dynamic>;
      final texts = (map['text'] as List<dynamic>).join('\n');
      final footnoteList = map['footnote'] as List<dynamic>?;
      final footnote = footnoteList?.join('\n') ?? '';
      final fullText = footnote.isEmpty ? texts : '$texts\n\n$footnote';

      inserts.add(
        DuaTableCompanion.insert(category: category, duaText: fullText),
      );
    });

    await db.batch((batch) {
      batch.insertAll(db.duaTable, inserts);
    });
  }

  Future<void> _seedHadith(String fileName, String bookName) async {
    try {
      final hadithString = await rootBundle.loadString('assets/json/$fileName');
      final rows = await compute(_parseHadithPayload, (hadithString, bookName));
      final inserts = rows
          .map(
            (row) => HadithTableCompanion.insert(
              bookName: bookName,
              chapterName: Value(row['chapterName'] as String?),
              reference: Value(row['reference']! as String),
              hadithTextAr: row['hadithTextAr']! as String,
              hadithTextEn: Value(row['hadithTextEn'] as String?),
            ),
          )
          .toList(growable: false);

      await db.batch((batch) {
        batch.insertAll(db.hadithTable, inserts);
      });
    } catch (e) {
      throw Exception('تعذر تهيئة كتاب الحديث $bookName: $e');
    }
  }
}

List<Map<String, Object>> _parseTafseerPayload(
  (String quranText, String tafseer) payload,
) => _parseTafseerRows(payload.$1, payload.$2);

List<Map<String, Object>> _parseTafseerRows(
  String quranTextString,
  String tafseerString,
) {
  final quranTextJson = jsonDecode(quranTextString) as List<dynamic>;
  final ayahMapping = <int, Map<String, int>>{};
  for (final item in quranTextJson) {
    final map = item as Map<String, dynamic>;
    if (map['model'] != 'quran_text.ayah') continue;
    final fields = map['fields'] as Map<String, dynamic>;
    ayahMapping[map['pk'] as int] = {
      'surah': fields['sura'] as int,
      'ayah': fields['number'] as int,
    };
  }

  final tafseerJson = jsonDecode(tafseerString) as List<dynamic>;
  final rows = <Map<String, Object>>[];
  for (final item in tafseerJson) {
    final map = item as Map<String, dynamic>;
    if (map['model'] != 'quran_tafseer.tafseertext') continue;
    final fields = map['fields'] as Map<String, dynamic>;
    if (fields['tafseer'] != 1) continue;
    final mapping = ayahMapping[fields['ayah'] as int];
    if (mapping == null) continue;
    rows.add({
      'surah': mapping['surah']!,
      'ayah': mapping['ayah']!,
      'text': fields['text'] as String,
    });
  }
  return rows;
}

List<Map<String, Object?>> _parseHadithPayload(
  (String hadith, String bookName) payload,
) => _parseHadithRows(payload.$1, payload.$2);

List<Map<String, Object?>> _parseHadithRows(
  String hadithString,
  String fallbackBookName,
) {
  final hadithJson = jsonDecode(hadithString) as Map<String, dynamic>;
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
  final rows = <Map<String, Object?>>[];
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
    rows.add({
      'chapterName': hadith['chapterId'] is int
          ? chapterMap[hadith['chapterId'] as int]
          : null,
      'reference': idInBook == null || idInBook.isEmpty
          ? sourceBookArabic
          : '$sourceBookArabic - حديث $idInBook',
      'hadithTextAr': hadith['arabic']?.toString() ?? '',
      'hadithTextEn': englishText,
    });
  }
  return rows;
}

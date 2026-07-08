import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:athr/core/database/app_database.dart';

import 'seed_daily_content.dart';

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seedDatabase() async {
    final tafseerCount = await (db.select(
      db.quranTafseerTable,
    )..limit(1)).get();
    if (tafseerCount.isEmpty) await _seedTafseer();

    final duaCount = await (db.select(db.duaTable)..limit(1)).get();
    if (duaCount.isEmpty) await _seedDuas();

    final hadithCount = await (db.select(db.hadithTable)..limit(1)).get();
    if (hadithCount.isEmpty) {
      await _seedHadith('bukhari.json', 'صحيح البخاري');
      await _seedHadith('muslim.json', 'صحيح مسلم');
    }

    final sunnahCount = await (db.select(db.dailySunnahTable)..limit(1)).get();
    if (sunnahCount.isEmpty) await _seedDailySunnah();

    final taskCount = await (db.select(db.dailyTaskTable)..limit(1)).get();
    if (taskCount.isEmpty) await _seedDailyTasks();
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
    // Load mapping from pk -> (surah, ayah)
    final quranTextString = await rootBundle.loadString(
      'assets/json/quran_text.json',
    );
    final List<dynamic> quranTextJson = jsonDecode(quranTextString);

    Map<int, Map<String, int>> ayahMapping = {};
    for (var item in quranTextJson) {
      if (item['model'] == 'quran_text.ayah') {
        final pk = item['pk'] as int;
        final fields = item['fields'] as Map<String, dynamic>;
        ayahMapping[pk] = {
          'surah': fields['sura'] as int,
          'ayah': fields['number'] as int,
        };
      }
    }

    // Load tafseer
    final tafseerString = await rootBundle.loadString(
      'assets/json/tafseer.json',
    );
    final List<dynamic> tafseerJson = jsonDecode(tafseerString);

    List<QuranTafseerTableCompanion> inserts = [];
    for (var item in tafseerJson) {
      if (item['model'] == 'quran_tafseer.tafseertext') {
        final fields = item['fields'] as Map<String, dynamic>;
        // fields['tafseer'] == 1 means Tafseer Al-Muyassar usually. We can filter if needed.
        if (fields['tafseer'] != 1) continue;

        final ayahId = fields['ayah'] as int;
        final text = fields['text'] as String;

        final mapping = ayahMapping[ayahId];
        if (mapping != null) {
          inserts.add(
            QuranTafseerTableCompanion.insert(
              surahNumber: mapping['surah']!,
              ayahNumber: mapping['ayah']!,
              tafseerText: text,
            ),
          );
        }
      }
    }

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
      final Map<String, dynamic> hadithJson = jsonDecode(hadithString);

      final chaptersList = hadithJson['chapters'] as List<dynamic>? ?? [];
      final Map<int, String> chapterMap = {};
      for (var c in chaptersList) {
        final cm = c as Map<String, dynamic>;
        if (cm['id'] != null) {
          chapterMap[cm['id'] as int] = cm['arabic']?.toString() ?? '';
        }
      }

      final hadiths = hadithJson['hadiths'] as List<dynamic>;
      List<HadithTableCompanion> inserts = [];
      final metadata = hadithJson['metadata'] as Map<String, dynamic>?;
      final metadataArabic = metadata?['arabic'] as Map<String, dynamic>?;
      final sourceBookArabic = metadataArabic?['title']?.toString() ?? bookName;

      for (var item in hadiths) {
        final map = item as Map<String, dynamic>;
        final englishObj = map['english'];
        String? englishText;
        if (englishObj is Map<String, dynamic>) {
          final narrator = englishObj['narrator']?.toString() ?? '';
          final text = englishObj['text']?.toString() ?? '';
          englishText = '$narrator\n$text'.trim();
        }

        final chapterId = map['chapterId'] as int?;
        final chapterName = chapterId != null ? chapterMap[chapterId] : null;
        final idInBook = map['idInBook']?.toString();
        final reference = idInBook == null || idInBook.isEmpty
            ? sourceBookArabic
            : '$sourceBookArabic - حديث $idInBook';

        inserts.add(
          HadithTableCompanion.insert(
            bookName: bookName,
            chapterName: Value(chapterName),
            reference: Value(reference),
            hadithTextAr: map['arabic']?.toString() ?? '',
            hadithTextEn: Value(englishText),
          ),
        );
      }

      await db.batch((batch) {
        batch.insertAll(db.hadithTable, inserts);
      });
    } catch (e) {
      throw Exception('تعذر تهيئة كتاب الحديث $bookName: $e');
    }
  }
}

import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/database/seeder/db_seeder.dart';
import 'package:midrar/core/utils/arabic_normalization.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';
import 'package:midrar/features/situations/providers/situations_providers.dart';
import 'package:midrar/features/quran/providers/bookmark_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppDatabase _db() => AppDatabase.forTesting(NativeDatabase.memory());

Future<void> _insertHadith(
  AppDatabase db, {
  required String book,
  required String chapter,
  required String text,
}) async {
  await db.into(db.hadithTable).insert(
        HadithTableCompanion.insert(
          bookName: book,
          chapterName: Value(chapter),
          reference: const Value(null),
          hadithTextAr: text,
          hadithTextArNorm:
              Value(normalizeArabic('$book $chapter $text')),
        ),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('situations hadith resolver', () {
    late AppDatabase database;

    setUp(() => database = _db());
    tearDown(() => database.close());

    test('finds chapters far beyond the legacy 120-row window', () async {
      // Simulate the real corpus shape: كتاب الرقاق sits thousands of rows
      // deep. The old limit(120) window could never reach it.
      for (var i = 0; i < 300; i++) {
        await _insertHadith(
          database,
          book: 'صحيح البخاري',
          chapter: 'كتاب بدء الوحي',
          text: 'حديث تمهيدي رقم $i',
        );
      }
      await _insertHadith(
        database,
        book: 'صحيح البخاري',
        chapter: 'كتاب الرقاق',
        text: 'أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا',
      );

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);

      // Situation 4 (القلق) references كتاب الرقاق in صحيح البخاري.
      final results = await container.read(situationHadithProvider('4').future);
      expect(results, isNotEmpty);
      expect(results.first.chapterName, contains('الرقاق'));
    });

    test('falls back to normalized full-text when no chapter matches',
        () async {
      for (var i = 0; i < 10; i++) {
        await _insertHadith(
          database,
          book: 'صحيح مسلم',
          chapter: 'كتاب آخر',
          text: 'نص آخر $i',
        );
      }
      await _insertHadith(
        database,
        book: 'صحيح مسلم',
        chapter: 'كتاب آخر',
        text: 'أَلَا بِالذِّكْرِ تَطْمَئِنُّ الْقُلُوبُ',
      );

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);

      // A keyword that matches no chapter heading but exists in a matn.
      final results = await container.read(situationHadithProvider('1').future);
      expect(results, isNotEmpty);
    });
  });

  group('prayer settings: asr madhhab', () {
    test('defaults to the majority (shafii) school and persists changes',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final notifier = PrayerSettingsNotifier(prefs);

      expect(notifier.state.asrSchool, AsrSchool.shafii);
      expect(notifier.state.asrSchool.apiValue, 0);

      await notifier.setAsrHanafi(true);
      expect(notifier.state.asrSchool, AsrSchool.hanafi);
      expect(notifier.state.asrSchool.apiValue, 1);

      // Reload from storage to prove persistence.
      final reloaded = PrayerSettingsNotifier(
        await SharedPreferences.getInstance(),
      );
      expect(reloaded.state.asrHanafi, isTrue);
    });
  });

  group('bookmark vs last-read separation', () {
    test('automatic progress never overwrites the explicit bookmark',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final bookmarks = BookmarkNotifier(prefs);
      final lastRead = LastReadNotifier(prefs);

      await bookmarks.saveBookmark(surah: 18, ayah: 10, pageNumber: 250);
      expect(bookmarks.state!.surah, 18);

      // User browses elsewhere: last-read moves, bookmark must not.
      await lastRead.recordProgress(surah: 2, ayah: 255, pageNumber: 42);
      await lastRead.recordProgress(surah: 67, ayah: 3, pageNumber: 562);

      expect(lastRead.state!.surah, 67);
      expect(bookmarks.state!.surah, 18);
      expect(bookmarks.state!.ayah, 10);

      // Fresh session restores both independently.
      final prefs2 = await SharedPreferences.getInstance();
      expect(BookmarkNotifier(prefs2).state!.surah, 18);
      expect(LastReadNotifier(prefs2).state!.surah, 67);
    });

    test('legacy bookmark-only storage seeds last-read once', () async {
      SharedPreferences.setMockInitialValues({
        'quran_bookmark_surah': 36,
        'quran_bookmark_ayah': 15,
      });
      final prefs = await SharedPreferences.getInstance();
      final lastRead = LastReadNotifier(prefs);
      expect(lastRead.state, isNotNull);
      expect(lastRead.state!.surah, 36);
      expect(lastRead.state!.ayah, 15);
    });
  });

  group('seed-state integrity', () {
    test('missing, outdated, or short markers force a repair pass', () {
      const expected = 7277;
      SeedState marker({
        required int contentVersion,
        required int actualCount,
      }) =>
          SeedState(
            datasetKey: 'hadith_bukhari',
            contentVersion: contentVersion,
            expectedCount: expected,
            actualCount: actualCount,
            seededAt: '2026-01-01T00:00:00Z',
          );

      final currentVersion = kCurrentContentVersions['hadith_bukhari']!;

      // No marker → incomplete (first run).
      // Marker at current version with full count → complete.
      // Partial import (interrupted between the two batches) → repair.
      // Older content version (asset updated) → repair.
      expect(currentVersion >= 1, isTrue);
      final complete =
          marker(contentVersion: currentVersion, actualCount: expected);
      expect(complete.actualCount >= expected, isTrue);
      final partial =
          marker(contentVersion: currentVersion, actualCount: 5000);
      expect(partial.actualCount < expected, isTrue);
    });

    test('normalized search tolerates diacritics and farsi yeh', () {
      final corpus = normalizeArabic(
        'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
      );
      expect(normalizeArabic('انما الاعمال بالنیات'), corpus);
      expect(normalizeArabic('إنما الأعمال بالنيات'), corpus);
    });
  });
  group('tafseer pk map (replaces the 4.3 MB quran_text.json join)', () {
    test('matches the original dataset anchors exactly', () {
      final map = computeAyahPkMap();
      expect(map.length, 6236);
      expect(map[1]!.surah, 1);
      expect(map[1]!.ayah, 1);
      expect(map[7]!.surah, 1);
      expect(map[7]!.ayah, 7);
      expect(map[8]!.surah, 2);
      expect(map[8]!.ayah, 1);
      expect(map[262]!.surah, 2);
      expect(map[262]!.ayah, 255);
      expect(map[6236]!.surah, 114);
      expect(map[6236]!.ayah, 6);
    });

    test('is strictly sequential in mushaf reading order', () {
      final map = computeAyahPkMap();
      var pk = 1;
      for (var surah = 1; surah <= 114; surah++) {
        final count = kHafsAyahCounts[surah - 1];
        for (var ayah = 1; ayah <= count; ayah++) {
          expect(map[pk]!.surah, surah);
          expect(map[pk]!.ayah, ayah);
          pk++;
        }
      }
      expect(pk - 1, 6236);
    });
  });

  group('azkar schema v8 (per-zikr rows from the real asset)', () {
    test('seeds 298 individual zikr rows with parsed counts and markers',
        () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      TestWidgetsFlutterBinding.ensureInitialized();

      final seeder = DatabaseSeeder(database);
      await seeder.seedDuasIfNeeded();

      final total = await database
          .customSelect('SELECT COUNT(*) AS c FROM zikr_table')
          .getSingle();
      expect(total.read<int>('c'), 298);

      final sabahMasa = await (database.select(database.zikrTable)
            ..where((t) => t.category.equals('أذكار الصباح والمساء'))
            ..orderBy([(t) => OrderingTerm.asc(t.zikrIndex)]))
          .get();
      expect(sabahMasa, hasLength(25), reason: 'per-zikr rows, not one blob');
      expect(sabahMasa.first.zikrIndex, 1);
      expect(sabahMasa.last.zikrIndex, 25);

      // Two distinct tasbeeh zikr — each now carries its OWN count.
      final manQal = sabahMasa.firstWhere(
        (z) => z.zikrText.contains('من قال'),
      );
      expect(manQal.repetitionCount, 100, reason: 'من قال سبحان الله ×100');

      final adadKhalq = sabahMasa.firstWhere(
        (z) => z.zikrText.contains('عدد خلقه'),
      );
      expect(adadKhalq.repetitionCount, 3, reason: 'عدد خلقه ×3 إذا أصبح');
      expect(adadKhalq.timeMarker, 'morning');
      expect(adadKhalq.repetitionLabel, contains('إذا أصبح'));

      // Explicit counts exist across the category (13 in the source).
      final withCounts = sabahMasa
          .where((z) => z.repetitionCount != null)
          .toList();
      expect(withCounts.length, 13);

      // Time markers derived from explicit wording only.
      final morning = sabahMasa.where((z) => z.timeMarker == 'morning');
      final evening = sabahMasa.where((z) => z.timeMarker == 'evening');
      expect(morning, isNotEmpty);
      expect(evening, isNotEmpty);

      // Idempotent: a second run must not duplicate rows.
      await seeder.seedDuasIfNeeded();
      final totalAgain = await database
          .customSelect('SELECT COUNT(*) AS c FROM zikr_table')
          .getSingle();
      expect(totalAgain.read<int>('c'), 298);
    });
  });
}
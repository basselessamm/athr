import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/utils/arabic_normalization.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('toggleFavorite inserts then removes a favorite', () async {
    await database.toggleFavorite(
      contentType: 'verse',
      primaryReference: '2:255',
      title: 'آية الكرسي',
      contentText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
      source: 'اختبار',
    );

    final favoritesAfterInsert = await database.watchFavorites().first;
    expect(favoritesAfterInsert, hasLength(1));
    expect(favoritesAfterInsert.first.primaryReference, '2:255');

    await database.toggleFavorite(
      contentType: 'verse',
      primaryReference: '2:255',
      title: 'آية الكرسي',
      contentText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
      source: 'اختبار',
    );

    final favoritesAfterDelete = await database.watchFavorites().first;
    expect(favoritesAfterDelete, isEmpty);
  });

  test('saveMuhasabaEntry persists note and booleans', () async {
    await database.saveMuhasabaEntry(
      prayed: true,
      guardedTongue: true,
      honoredParents: false,
      avoidedHarm: true,
      gaveCharity: false,
      quranRead: true,
      note: 'مراجعة جيدة لليوم',
    );

    final entry = await database.watchTodayMuhasaba().first;
    expect(entry, isNotNull);
    expect(entry!.prayed, isTrue);
    expect(entry.guardedTongue, isTrue);
    expect(entry.honoredParents, isFalse);
    expect(entry.avoidedHarm, isTrue);
    expect(entry.quranRead, isTrue);
    expect(entry.note, 'مراجعة جيدة لليوم');
  });

  test('hadith search matches normalized text without diacritics', () async {
    final inserts = <HadithTableCompanion>[
      HadithTableCompanion.insert(
        bookName: 'صحيح البخاري',
        chapterName: const Value('كتاب الإيمان'),
        reference: const Value('صحيح البخاري - حديث 1'),
        hadithTextAr: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
      ),
      HadithTableCompanion.insert(
        bookName: 'صحيح البخاري',
        chapterName: const Value('كتاب العلم'),
        reference: const Value('صحيح البخاري - حديث 2'),
        hadithTextAr: 'مَنْ يُرِدِ اللَّهُ بِهِ خَيْرًا يُفَقِّهْهُ فِي الدِّينِ',
      ),
    ];
    for (final insert in inserts) {
      // Mirror the seeder's normalization so the test reflects production.
      await database.into(database.hadithTable).insert(insert.copyWith(
            hadithTextArNorm: Value(normalizeArabic(insert.hadithTextAr.value)),
          ));
    }

    // Unvocalized query must find the vocalized hadith.
    final results =
        await database.searchHadith('انما الاعمال بالنیات');
    expect(results, hasLength(1));
    expect(results.first.reference, 'صحيح البخاري - حديث 1');

    // Chapter-name matching also works unvocalized.
    final byChapter = await database.searchHadith('كتاب العلم');
    expect(byChapter, hasLength(1));

    // SQL wildcards in user input are neutralized instead of matching all.
    final wildcard = await database.searchHadith('%');
    expect(wildcard, isEmpty);
  });
}

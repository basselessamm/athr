import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/database/seeder/database_seed_providers.dart';
import 'package:midrar/features/hadith/providers/hadith_providers.dart';

void main() {
  group('Hadith Chapter Pagination & Memory Optimization', () {
    late AppDatabase database;
    late ProviderContainer container;

    setUp(() async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          // Override seeder to no-op so tests control data directly
          hadithSeedProvider.overrideWith((ref) async {}),
        ],
      );

      // Seed small controlled dataset
      await database.batch((batch) {
        batch.insertAll(database.hadithTable, [
          HadithTableCompanion.insert(
            bookName: 'صحيح البخاري',
            chapterName: const Value('كتاب بدء الوحي'),
            reference: const Value('حديث 1'),
            hadithTextAr: 'إنما الأعمال بالنيات',
          ),
          HadithTableCompanion.insert(
            bookName: 'صحيح البخاري',
            chapterName: const Value('كتاب بدء الوحي'),
            reference: const Value('حديث 2'),
            hadithTextAr: 'سأل رجل رسول الله...',
          ),
          HadithTableCompanion.insert(
            bookName: 'صحيح البخاري',
            chapterName: const Value('كتاب الإيمان'),
            reference: const Value('حديث 3'),
            hadithTextAr: 'بني الإسلام على خمس',
          ),
          HadithTableCompanion.insert(
            bookName: 'صحيح مسلم',
            chapterName: const Value('كتاب الإيمان'),
            reference: const Value('حديث 1'),
            hadithTextAr: 'الإيمان بضع وسبعون شعبة',
          ),
        ]);
      });
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    test('resolveHadithBookTitle maps canonical and English names correctly', () {
      expect(resolveHadithBookTitle('bukhari'), 'صحيح البخاري');
      expect(resolveHadithBookTitle('صحيح البخاري'), 'صحيح البخاري');
      expect(resolveHadithBookTitle('muslim'), 'صحيح مسلم');
      expect(resolveHadithBookTitle('صحيح مسلم'), 'صحيح مسلم');
    });

    test('hadithChaptersProvider aggregates chapters with exact counts', () async {
      final bukhariChapters = await container.read(
        hadithChaptersProvider('bukhari').future,
      );

      expect(bukhariChapters, hasLength(2));
      expect(bukhariChapters[0].chapterName, 'كتاب بدء الوحي');
      expect(bukhariChapters[0].hadithCount, 2);
      expect(bukhariChapters[1].chapterName, 'كتاب الإيمان');
      expect(bukhariChapters[1].hadithCount, 1);

      final muslimChapters = await container.read(
        hadithChaptersProvider('muslim').future,
      );
      expect(muslimChapters, hasLength(1));
      expect(muslimChapters[0].chapterName, 'كتاب الإيمان');
      expect(muslimChapters[0].hadithCount, 1);
    });

    test('chapterHadithsProvider loads only hadiths for the requested chapter', () async {
      final hadiths = await container.read(
        chapterHadithsProvider(
          const ChapterHadithsQuery(
            bookName: 'bukhari',
            chapterName: 'كتاب بدء الوحي',
          ),
        ).future,
      );

      expect(hadiths, hasLength(2));
      expect(hadiths.first.hadithTextAr, 'إنما الأعمال بالنيات');
      expect(hadiths.every((h) => h.chapterName == 'كتاب بدء الوحي'), isTrue);
    });

    test('hadithChapterForHadithIdProvider accurately identifies parent chapter', () async {
      // Hadith 3 is in 'كتاب الإيمان' in Bukhari
      final chapterName = await container.read(
        hadithChapterForHadithIdProvider(3).future,
      );
      expect(chapterName, 'كتاب الإيمان');
    });
  });
}

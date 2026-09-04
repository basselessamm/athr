import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/features/hadith/presentation/hadith_chapters_screen.dart';
import 'package:midrar/features/hadith/presentation/hadith_reading_screen.dart';
import 'package:midrar/features/hadith/providers/hadith_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';

void main() {
  group('Hadith UI Screens', () {
    late SharedPreferences prefs;

    final mockChapters = [
      const HadithChapterInfo(
        chapterName: 'كتاب بدء الوحي',
        hadithCount: 7,
        firstHadithId: 1,
      ),
      const HadithChapterInfo(
        chapterName: 'كتاب الإيمان',
        hadithCount: 53,
        firstHadithId: 8,
      ),
    ];

    final mockHadiths = [
      const Hadith(
        id: 1,
        bookName: 'صحيح البخاري',
        chapterName: 'كتاب بدء الوحي',
        reference: 'حديث 1',
        hadithTextAr: 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
        hadithTextArNorm: 'انما الاعمال بالنيات',
        isBookmarked: false,
      ),
    ];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('HadithChaptersScreen renders chapters and search filter works',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hadithChaptersProvider('صحيح البخاري').overrideWith(
              (ref) async => mockChapters,
            ),
          ],
          child: const MaterialApp(
            home: HadithChaptersScreen(bookName: 'صحيح البخاري'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.textContaining('صحيح البخاري'), findsOneWidget);
      expect(find.text('كتاب بدء الوحي'), findsOneWidget);
      expect(find.text('كتاب الإيمان'), findsOneWidget);
      expect(find.text('7 حديث'), findsOneWidget);

      // Filter by search
      await tester.enterText(find.byType(TextField), 'الوحي');
      await tester.pump();

      expect(find.text('كتاب بدء الوحي'), findsOneWidget);
      expect(find.text('كتاب الإيمان'), findsNothing);
    });

    testWidgets('HadithReadingScreen renders selected chapter and flip widget',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            hadithChaptersProvider('صحيح البخاري').overrideWith(
              (ref) async => mockChapters,
            ),
            chapterHadithsProvider(
              const ChapterHadithsQuery(
                bookName: 'صحيح البخاري',
                chapterName: 'كتاب بدء الوحي',
              ),
            ).overrideWith((ref) async => mockHadiths),
          ],
          child: const MaterialApp(
            home: HadithReadingScreen(
              bookName: 'صحيح البخاري',
              initialChapter: 'كتاب بدء الوحي',
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(find.text('كتاب بدء الوحي'), findsWidgets);
      expect(find.textContaining('إنما الأعمال بالنيات'), findsOneWidget);
      expect(find.byIcon(Icons.format_list_bulleted_rounded), findsOneWidget);
    });
  });
}

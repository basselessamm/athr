import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/features/azkar/presentation/azkar_categories_screen.dart';
import 'package:midrar/features/azkar/presentation/azkar_reading_screen.dart';
import 'package:midrar/features/azkar/providers/azkar_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Azkar UI and Reading Smoothness Verification', () {
    late SharedPreferences prefs;

    final List<Zikr> mockZikrList = [
      const Zikr(
        id: 1,
        category: 'أذكار الصباح',
        zikrIndex: 1,
        zikrText: 'أصبحنا وأصبح الملك لله والحمد لله',
        textNorm: 'اصبحنا واصبح الملك لله والحمد لله',
        repetitionCount: 3,
        repetitionLabel: 'ثلاث مرات',
        timeMarker: 'morning',
      ),
      const Zikr(
        id: 2,
        category: 'أذكار الصباح',
        zikrIndex: 2,
        zikrText: 'اللهم بك أصبحنا وبك أمسينا',
        textNorm: 'اللهم بك اصبحنا وبك امسينا',
        repetitionCount: 1,
        repetitionLabel: 'مرة واحدة',
        timeMarker: 'morning',
      ),
    ];

    final List<String> mockCategories = ['أذكار الصباح', 'أذكار المساء', 'أذكار النوم'];

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('AzkarCategoriesScreen displays categories list smoothly',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            azkarCategoriesProvider.overrideWith((ref) async => mockCategories),
          ],
          child: const MaterialApp(
            locale: Locale('ar', 'SA'),
            supportedLocales: [Locale('ar', 'SA')],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: AzkarCategoriesScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('الأذكار'), findsWidgets);
      expect(find.text('أذكار الصباح'), findsOneWidget);
      expect(find.text('أذكار المساء'), findsOneWidget);
      expect(find.text('أذكار النوم'), findsOneWidget);
    });

    testWidgets(
        'AzkarReadingScreen renders tactile counter, decrements on tap, and marks done',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            zikrByCategoryProvider('أذكار الصباح')
                .overrideWith((ref) async => mockZikrList),
            azkarByCategoryProvider('أذكار الصباح')
                .overrideWith((ref) async => <Dua>[]),
          ],
          child: const MaterialApp(
            locale: Locale('ar', 'SA'),
            supportedLocales: [Locale('ar', 'SA')],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: AzkarReadingScreen(category: 'أذكار الصباح'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify header and zikr text
      expect(find.text('أذكار الصباح'), findsWidgets);
      expect(find.text('أصبحنا وأصبح الملك لله والحمد لله'), findsOneWidget);
      expect(find.text('(ثلاث مرات)'), findsOneWidget);

      // Initial count is 3 (shown as ٣ in Arabic)
      expect(find.text('٣'), findsOneWidget);

      // Tap counter once -> 2 (٢)
      await tester.tap(find.text('٣'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('٢'), findsOneWidget);

      // Tap counter again -> 1 (١)
      await tester.tap(find.text('٢'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('١'), findsOneWidget);

      // Tap counter final time -> completed ('تم')
      await tester.tap(find.text('١'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('تم'), findsOneWidget);

      // Verify reset button appears
      expect(find.text('إعادة العداد'), findsOneWidget);

      // Tap reset button -> restores count back to 3 (٣)
      await tester.tap(find.text('إعادة العداد'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('٣'), findsOneWidget);
    });

    testWidgets(
        'AzkarReadingScreen flips smoothly between pages and preserves state',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            zikrByCategoryProvider('أذكار الصباح')
                .overrideWith((ref) async => mockZikrList),
            azkarByCategoryProvider('أذكار الصباح')
                .overrideWith((ref) async => <Dua>[]),
          ],
          child: const MaterialApp(
            locale: Locale('ar', 'SA'),
            supportedLocales: [Locale('ar', 'SA')],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: AzkarReadingScreen(category: 'أذكار الصباح'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Page 1 is visible
      expect(find.text('أصبحنا وأصبح الملك لله والحمد لله'), findsOneWidget);

      // Drag forward in RTL to flip to Page 2
      await tester.drag(find.byType(PageView), const Offset(500, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Page 2 is visible
      expect(find.text('اللهم بك أصبحنا وبك أمسينا'), findsOneWidget);
      expect(find.text('الذكر ٢'), findsOneWidget);
    });
  });
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midrar/features/quran/presentation/quran_reading_screen.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Quran Continuous Reading Transitions', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      await Quran.initialize();
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('Surah 108 endPage presents next surah button (Al-Kafirun)',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: QuranReadingScreen(surahNumber: 108),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Drag to next page (endPage)
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.textContaining('الانتقال إلى سورة الكافرون'), findsOneWidget);
      expect(find.text('فهرس السور'), findsOneWidget);
    });

    testWidgets('Surah 114 endPage presents completion message without next surah button',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: QuranReadingScreen(surahNumber: 114),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Drag to next page (endPage)
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('ختم القرآن الكريم'), findsOneWidget);
      expect(find.text('تقبل الله طاعتكم وصالح أعمالكم'), findsOneWidget);
      expect(find.textContaining('الانتقال إلى سورة'), findsNothing);
      expect(find.text('فهرس السور'), findsOneWidget);
    });
  });
}

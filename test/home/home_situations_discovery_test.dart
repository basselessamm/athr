import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/features/home/presentation/home_screen.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';
import 'package:midrar/core/memory/memory_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('HomeScreen features situations discovery card and gentle utility link', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          prayerScheduleProvider.overrideWith((ref) => Future.error(StateError('no location'))),
          memoryThreadsProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Pump frames
    await tester.pump(const Duration(milliseconds: 200));

    final mainScrollable = find.byType(Scrollable).first;

    // Verify card title and button are present in the list
    final cardFinder = find.text('سكينة في مواقف الحياة');
    await tester.scrollUntilVisible(cardFinder, 300, scrollable: mainScrollable);
    expect(cardFinder, findsOneWidget);
    expect(find.text('استعراض المواقف والتأملات'), findsOneWidget);

    // Verify gentle utility button
    final utilityFinder = find.text('مواقف وتأملات');
    await tester.scrollUntilVisible(utilityFinder, 300, scrollable: mainScrollable);
    expect(utilityFinder, findsOneWidget);
  });
}

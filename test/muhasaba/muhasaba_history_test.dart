import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/features/home/providers/home_providers.dart';
import 'package:midrar/features/muhasaba/presentation/muhasaba_screen.dart';
import 'package:midrar/features/muhasaba/providers/muhasaba_providers.dart';

void main() {
  group('Muhasaba Screen & History Log', () {
    const historicalEntry = MuhasabaEntry(
      activityDate: '2026-08-30',
      prayed: true,
      guardedTongue: true,
      honoredParents: true,
      avoidedHarm: true,
      gaveCharity: true,
      quranRead: true,
      updatedAt: '2026-08-30T22:00:00.000Z',
      note: 'يوم مبارك مليء بالسكينة',
    );

    testWidgets('Renders both tabs and shows past entry in history tab',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todayMuhasabaProvider.overrideWith((ref) => Stream.value(null)),
            allMuhasabaEntriesProvider.overrideWith(
              (ref) => Stream.value([historicalEntry]),
            ),
          ],
          child: const MaterialApp(
            home: MuhasabaScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('محاسبة اليوم'), findsOneWidget);
      expect(find.text('السجل والتدبر'), findsOneWidget);

      // Verify today view controls exist
      expect(find.text('حافظت على الصلاة في وقتها قدر استطاعتي'), findsOneWidget);

      // Switch to History tab
      await tester.tap(find.text('السجل والتدبر'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Verify historical entry is shown
      expect(find.text('2026-08-30'), findsOneWidget);
      expect(find.text('6 من 6 خصال'), findsOneWidget);
      expect(find.text('يوم مبارك مليء بالسكينة'), findsOneWidget);
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/progress/providers/goal_engine_provider.dart';
import 'package:athr/features/progress/providers/goal_wiring_providers.dart';

void main() {
  group('goalSummaryProvider', () {
    test(
      'calculates totals, completed count, average percent, and primary goal',
      () {
        final container = ProviderContainer(
          overrides: [
            goalEngineProvider.overrideWith((ref) {
              return AsyncValue.data([
                GoalProgress(
                  goal: UserGoal(
                    id: 1,
                    goalType: 'pages',
                    metric: 'quran_pages',
                    title: 'ورد الصفحات',
                    icon: 'menu_book',
                    targetValue: 10,
                    resetPolicy: 'daily',
                    metadata: null,
                    updatedAt: '2026-07-09T00:00:00.000',
                  ),
                  currentValue: 8,
                  isCompleted: false,
                ),
                GoalProgress(
                  goal: UserGoal(
                    id: 2,
                    goalType: 'azkar',
                    metric: 'azkar_count',
                    title: 'ورد الأذكار',
                    icon: 'favorite',
                    targetValue: 100,
                    resetPolicy: 'daily',
                    metadata: null,
                    updatedAt: '2026-07-09T00:00:00.000',
                  ),
                  currentValue: 100,
                  isCompleted: true,
                ),
                GoalProgress(
                  goal: UserGoal(
                    id: 3,
                    goalType: 'minutes',
                    metric: 'quran_minutes',
                    title: 'دقائق القراءة',
                    icon: 'timer',
                    targetValue: 30,
                    resetPolicy: 'daily',
                    metadata: null,
                    updatedAt: '2026-07-09T00:00:00.000',
                  ),
                  currentValue: 15,
                  isCompleted: false,
                ),
              ]);
            }),
          ],
        );

        addTearDown(container.dispose);

        final summary = container.read(goalSummaryProvider).value;

        expect(summary, isNotNull);
        expect(summary!.totalGoals, 3);
        expect(summary.completedGoals, 1);
        expect(summary.inProgressGoals, 2);
        expect(summary.averagePercent, closeTo((0.8 + 1.0 + 0.5) / 3, 0.0001));
        expect(summary.primaryGoal, isNotNull);
        expect(summary.primaryGoal!.goal.title, 'ورد الصفحات');
      },
    );

    test('returns empty summary when there are no goals', () {
      final container = ProviderContainer(
        overrides: [
          goalEngineProvider.overrideWith((ref) {
            return const AsyncValue.data([]);
          }),
        ],
      );

      addTearDown(container.dispose);

      final summary = container.read(goalSummaryProvider).value;

      expect(summary, isNotNull);
      expect(summary!.totalGoals, 0);
      expect(summary.completedGoals, 0);
      expect(summary.inProgressGoals, 0);
      expect(summary.averagePercent, 0);
      expect(summary.primaryGoal, isNull);
    });
  });
}

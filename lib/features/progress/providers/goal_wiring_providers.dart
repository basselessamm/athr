import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/features/progress/providers/goal_engine_provider.dart';

class GoalSummary {
  final int totalGoals;
  final int completedGoals;
  final int inProgressGoals;
  final double averagePercent;
  final GoalProgress? primaryGoal;

  const GoalSummary({
    required this.totalGoals,
    required this.completedGoals,
    required this.inProgressGoals,
    required this.averagePercent,
    required this.primaryGoal,
  });
}

final primaryGoalProgressProvider = Provider<AsyncValue<GoalProgress?>>((ref) {
  final summaryAsync = ref.watch(goalSummaryProvider);

  return summaryAsync.whenData((summary) => summary.primaryGoal);
});

final goalSummaryProvider = Provider<AsyncValue<GoalSummary>>((ref) {
  final goalsAsync = ref.watch(goalEngineProvider);

  return goalsAsync.whenData((goals) {
    if (goals.isEmpty) {
      return const GoalSummary(
        totalGoals: 0,
        completedGoals: 0,
        inProgressGoals: 0,
        averagePercent: 0,
        primaryGoal: null,
      );
    }

    final completedGoals = goals.where((goal) => goal.isCompleted).length;
    final averagePercent =
        goals.fold<double>(0, (sum, goal) => sum + goal.percent) / goals.length;

    return GoalSummary(
      totalGoals: goals.length,
      completedGoals: completedGoals,
      inProgressGoals: goals.length - completedGoals,
      averagePercent: averagePercent,
      primaryGoal: _selectPrimaryGoal(goals),
    );
  });
});

GoalProgress? _selectPrimaryGoal(List<GoalProgress> goals) {
  if (goals.isEmpty) {
    return null;
  }

  final sortedGoals = [...goals]
    ..sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      final percentCompare = b.percent.compareTo(a.percent);
      if (percentCompare != 0) {
        return percentCompare;
      }

      final targetCompare = a.goal.targetValue.compareTo(b.goal.targetValue);
      if (targetCompare != 0) {
        return targetCompare;
      }

      return a.goal.title.compareTo(b.goal.title);
    });

  return sortedGoals.first;
}

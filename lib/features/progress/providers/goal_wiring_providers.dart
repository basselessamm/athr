import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/features/progress/providers/goal_engine_provider.dart';

final primaryGoalProgressProvider = Provider<AsyncValue<GoalProgress?>>((ref) {
  final goalsAsync = ref.watch(goalEngineProvider);

  return goalsAsync.whenData((goals) {
    if (goals.isEmpty) {
      return null;
    }

    goals.sort((a, b) => b.percent.compareTo(a.percent));

    final inProgress = goals.where((goal) => !goal.isCompleted).toList();
    if (inProgress.isNotEmpty) {
      inProgress.sort((a, b) => b.percent.compareTo(a.percent));
      return inProgress.first;
    }

    return goals.first;
  });
});

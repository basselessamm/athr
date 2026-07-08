import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/features/progress/data/user_goals_repository.dart';
import 'package:athr/features/progress/providers/metric_registry_provider.dart';

final userGoalsRepositoryProvider = Provider<UserGoalsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserGoalsRepository(db);
});

final userGoalsProvider = StreamProvider<List<UserGoal>>((ref) {
  final repo = ref.watch(userGoalsRepositoryProvider);
  return repo.watchUserGoals();
});

class GoalProgress {
  final UserGoal goal;
  final int currentValue;
  final bool isCompleted;

  double get percent => goal.targetValue > 0
      ? (currentValue / goal.targetValue).clamp(0.0, 1.0)
      : 0.0;

  GoalProgress({
    required this.goal,
    required this.currentValue,
    required this.isCompleted,
  });
}

// The core Goal Engine that cross-references goals with today's progress via the registry
final goalEngineProvider = Provider<AsyncValue<List<GoalProgress>>>((ref) {
  final goalsAsync = ref.watch(userGoalsProvider);
  final registry = ref.watch(metricRegistryProvider);

  if (goalsAsync is AsyncLoading) {
    return const AsyncValue.loading();
  }

  if (goalsAsync is AsyncError) {
    return AsyncValue.error(goalsAsync.error!, goalsAsync.stackTrace!);
  }

  final goals = goalsAsync.value ?? [];

  final List<GoalProgress> progressList = goals.map((goal) {
    // Completely data-driven resolution
    final current = registry.resolve(goal.metric, ref);

    return GoalProgress(
      goal: goal,
      currentValue: current,
      isCompleted: current >= goal.targetValue,
    );
  }).toList();

  return AsyncValue.data(progressList);
});

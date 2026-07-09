import 'package:athr/core/database/app_database.dart';

List<UserGoal> findDuplicateGoalsToDelete(
  List<UserGoal> goals,
  Set<String> supportedGoalTypes,
) {
  final duplicates = <UserGoal>[];

  for (final goalType in supportedGoalTypes) {
    final matchingGoals =
        goals.where((goal) => goal.goalType == goalType).toList()
          ..sort(compareGoalRecencyDescending);

    if (matchingGoals.length > 1) {
      duplicates.addAll(matchingGoals.skip(1));
    }
  }

  return duplicates;
}

int compareGoalRecencyDescending(UserGoal a, UserGoal b) {
  final aDate =
      DateTime.tryParse(a.updatedAt) ?? DateTime.fromMillisecondsSinceEpoch(0);
  final bDate =
      DateTime.tryParse(b.updatedAt) ?? DateTime.fromMillisecondsSinceEpoch(0);

  final dateCompare = bDate.compareTo(aDate);
  if (dateCompare != 0) {
    return dateCompare;
  }

  return b.id.compareTo(a.id);
}

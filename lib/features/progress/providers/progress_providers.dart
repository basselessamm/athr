import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/features/progress/data/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProgressRepository(db);
});

final dailyProgressProvider = StreamProvider<ProgressRecord?>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.watchDailyProgress();
});

final weeklyProgressProvider = FutureProvider<List<ProgressRecord>>((
  ref,
) async {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getWeeklyProgress();
});

final monthlyStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getMonthlyStats();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/modules/recent_activity/domain/repositories/recent_activity_repository.dart';
import 'package:athr/features/library/modules/recent_activity/data/repositories/recent_activity_repository_impl.dart';

final recentActivityRepositoryProvider = Provider<RecentActivityRepository>((
  ref,
) {
  return RecentActivityRepositoryImpl(ref.watch(appDatabaseProvider));
});

final recentActivitiesProvider = StreamProvider<List<RecentActivity>>((ref) {
  return ref.watch(recentActivityRepositoryProvider).watchRecentActivities();
});

final lastQuranReadProvider = FutureProvider<RecentActivity?>((ref) async {
  return ref.watch(recentActivityRepositoryProvider).getLastRead('quran');
});

final lastAzkarReadProvider = FutureProvider<RecentActivity?>((ref) async {
  return ref.watch(recentActivityRepositoryProvider).getLastRead('azkar');
});

import 'package:athr/core/database/app_database.dart';

abstract class RecentActivityRepository {
  Stream<List<RecentActivity>> watchRecentActivities();
  Future<void> addRecentActivity({
    required String type,
    required String title,
    String? subtitle,
    required String routePath,
  });
  Future<RecentActivity?> getLastRead(String type);
}

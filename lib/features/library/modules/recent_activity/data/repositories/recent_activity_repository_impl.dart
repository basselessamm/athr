import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/modules/recent_activity/domain/repositories/recent_activity_repository.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class RecentActivityRepositoryImpl implements RecentActivityRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  RecentActivityRepositoryImpl(this._db);

  @override
  Stream<List<RecentActivity>> watchRecentActivities() {
    return (_db.select(_db.recentActivityTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ])
          ..limit(10))
        .watch();
  }

  @override
  Future<void> addRecentActivity({
    required String type,
    required String title,
    String? subtitle,
    required String routePath,
  }) async {
    final existing =
        await (_db.select(_db.recentActivityTable)
              ..where((t) => t.type.equals(type) & t.title.equals(title)))
            .getSingleOrNull();

    if (existing != null) {
      await _db
          .update(_db.recentActivityTable)
          .replace(
            existing.copyWith(
              subtitle: Value(subtitle),
              routePath: routePath,
              timestamp: DateTime.now(),
            ),
          );
    } else {
      await _db
          .into(_db.recentActivityTable)
          .insert(
            RecentActivityTableCompanion.insert(
              id: _uuid.v4(),
              type: type,
              title: title,
              subtitle: Value(subtitle),
              routePath: routePath,
              timestamp: DateTime.now(),
            ),
          );
    }
  }

  @override
  Future<RecentActivity?> getLastRead(String type) async {
    return await (_db.select(_db.recentActivityTable)
          ..where((t) => t.type.equals(type))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }
}

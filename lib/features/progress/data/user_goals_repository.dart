import 'package:athr/core/database/app_database.dart';
import 'package:drift/drift.dart';

class UserGoalsRepository {
  final AppDatabase _db;

  UserGoalsRepository(this._db);

  Stream<List<UserGoal>> watchUserGoals() {
    return _db.select(_db.userGoalsTable).watch();
  }

  Future<void> addOrUpdateGoal({
    int? id,
    required String goalType,
    required String metric,
    required String title,
    required String icon,
    required int targetValue,
    String resetPolicy = 'daily',
    String? metadata,
  }) async {
    final companion = UserGoalsTableCompanion(
      id: id == null ? const Value.absent() : Value(id),
      goalType: Value(goalType),
      metric: Value(metric),
      title: Value(title),
      icon: Value(icon),
      targetValue: Value(targetValue),
      resetPolicy: Value(resetPolicy),
      metadata: metadata == null ? const Value.absent() : Value(metadata),
      updatedAt: Value(DateTime.now().toIso8601String()),
    );
    await _db.into(_db.userGoalsTable).insertOnConflictUpdate(companion);
  }

  Future<void> deleteGoal(int id) async {
    await (_db.delete(_db.userGoalsTable)..where((t) => t.id.equals(id))).go();
  }
}

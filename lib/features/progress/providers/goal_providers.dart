import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';

final userGoalProvider = FutureProvider<UserGoal?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return await (db.select(db.userGoalsTable)
        ..orderBy([(t) => OrderingTerm.desc(t.id)])
        ..limit(1))
      .getSingleOrNull();
});

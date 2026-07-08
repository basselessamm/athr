import 'package:drift/drift.dart';

@DataClassName('UserGoal')
class UserGoalsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get goalType => text()(); // Category e.g., 'reading', 'adhkar'
  TextColumn get metric => text().withDefault(
    const Constant('quran_pages'),
  )(); // The engine metric identifier e.g., 'quran_pages'
  TextColumn get title => text()();
  TextColumn get icon => text()();
  IntColumn get targetValue => integer()();
  TextColumn get resetPolicy => text().withDefault(
    const Constant('daily'),
  )(); // 'daily', 'weekly', 'monthly', 'never'
  TextColumn get metadata =>
      text().nullable()(); // JSON string for additional arguments
  TextColumn get updatedAt => text()();
}

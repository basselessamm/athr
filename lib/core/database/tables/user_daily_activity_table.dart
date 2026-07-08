import 'package:drift/drift.dart';

@DataClassName('UserDailyActivity')
class UserDailyActivityTable extends Table {
  TextColumn get activityDate => text()();
  TextColumn get completedTaskId => text().nullable()();
  TextColumn get completedSunnahId => text().nullable()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {activityDate};
}

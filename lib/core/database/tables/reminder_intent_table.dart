import 'package:drift/drift.dart';

@DataClassName('ReminderIntentRow')
class ReminderIntentTable extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  TextColumn get scheduledAt => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {threadId},
  ];
}

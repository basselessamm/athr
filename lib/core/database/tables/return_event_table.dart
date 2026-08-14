import 'package:drift/drift.dart';

@DataClassName('ReturnEventRow')
class ReturnEventTable extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  TextColumn get kind => text()();
  TextColumn get occurredAt => text()();
  IntColumn get durationSeconds => integer().nullable()();
  TextColumn get reflectionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

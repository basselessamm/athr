import 'package:drift/drift.dart';

@DataClassName('ReflectionEntryRow')
class ReflectionEntryTable extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text()();
  TextColumn get body => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {threadId, createdAt},
  ];
}

import 'package:drift/drift.dart';

@DataClassName('MemoryThreadRow')
class MemoryThreadTable extends Table {
  TextColumn get id => text()();
  TextColumn get sourceKind => text()();
  TextColumn get sourceCanonicalId => text()();
  TextColumn get sourceLabel => text()();
  TextColumn get sourceBook => text().nullable()();
  TextColumn get sourceCitation => text().nullable()();
  TextColumn get sourceVersion => text().nullable()();
  TextColumn get sourceSecondaryReference => text().nullable()();
  TextColumn get userContextKind => text().nullable()();
  TextColumn get userContextLabel => text().nullable()();
  TextColumn get userLabel => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get resurfacing => text().withDefault(const Constant('on'))();
  TextColumn get legacyKey => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get lastReturnedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {legacyKey},
  ];
}

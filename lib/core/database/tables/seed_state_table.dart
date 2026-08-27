import 'package:drift/drift.dart';

/// Tracks which bundled content datasets have been fully imported and at
/// which content revision. Enables idempotent, recoverable seeding: a
/// missing marker or an actual row count below [expectedCount] triggers a
/// safe re-import of that dataset inside a transaction.
@DataClassName('SeedState')
class SeedStateTable extends Table {
  TextColumn get datasetKey => text()();
  IntColumn get contentVersion => integer()();
  IntColumn get expectedCount => integer()();
  IntColumn get actualCount => integer()();
  TextColumn get seededAt => text()();

  @override
  Set<Column> get primaryKey => {datasetKey};
}

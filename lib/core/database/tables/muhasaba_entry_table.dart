import 'package:drift/drift.dart';

@DataClassName('MuhasabaEntry')
class MuhasabaEntryTable extends Table {
  TextColumn get activityDate => text()();
  BoolColumn get prayed => boolean().withDefault(const Constant(false))();
  BoolColumn get guardedTongue =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get honoredParents =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get avoidedHarm => boolean().withDefault(const Constant(false))();
  BoolColumn get gaveCharity => boolean().withDefault(const Constant(false))();
  BoolColumn get quranRead => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {activityDate};
}

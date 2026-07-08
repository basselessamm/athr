import 'package:drift/drift.dart';

@DataClassName('ProgressRecord')
class ProgressRecordTable extends Table {
  TextColumn get date => text()(); // Format: YYYY-MM-DD
  IntColumn get pagesRead => integer().withDefault(const Constant(0))();
  IntColumn get readingSeconds => integer().withDefault(const Constant(0))();
  IntColumn get azkarCount => integer().withDefault(const Constant(0))();
  IntColumn get hadithCount => integer().withDefault(const Constant(0))();
  BoolColumn get isMuhasabaDone =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {date};
}

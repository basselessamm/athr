import 'package:drift/drift.dart';

@DataClassName('DailySunnah')
class DailySunnahTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get howToApply => text()();
  TextColumn get source => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

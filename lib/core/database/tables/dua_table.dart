import 'package:drift/drift.dart';

@DataClassName('Dua')
class DuaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  TextColumn get duaText => text()();
  TextColumn get duaTextNorm => text().withDefault(const Constant(''))();
  TextColumn get reference => text().nullable()();
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();
}

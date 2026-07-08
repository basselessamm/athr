import 'package:drift/drift.dart';

@DataClassName('Hadith')
class HadithTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookName => text()();
  TextColumn get chapterName => text().nullable()();
  TextColumn get reference => text().nullable()();
  TextColumn get hadithTextAr => text()();
  TextColumn get hadithTextEn => text().nullable()();
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();
}

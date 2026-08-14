import 'package:drift/drift.dart';

@DataClassName('ReadingAnchorRow')
class ReadingAnchorTable extends Table {
  TextColumn get id => text()();
  TextColumn get threadId => text().nullable()();
  TextColumn get sourceCanonicalId => text()();
  IntColumn get surahNumber => integer().nullable()();
  IntColumn get ayahNumber => integer().nullable()();
  IntColumn get pageNumber => integer().nullable()();
  IntColumn get itemIndex => integer().nullable()();
  RealColumn get scrollOffset => real().nullable()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {threadId},
  ];
}

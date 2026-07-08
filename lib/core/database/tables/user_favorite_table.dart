import 'package:drift/drift.dart';

@DataClassName('UserFavorite')
class UserFavoriteTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get contentType => text()();
  TextColumn get primaryReference => text()();
  TextColumn get secondaryReference => text().nullable()();
  TextColumn get title => text()();
  TextColumn get contentText => text()();
  TextColumn get source => text()();
  TextColumn get createdAt => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {contentType, primaryReference},
  ];
}

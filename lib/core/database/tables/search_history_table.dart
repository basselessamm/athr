import 'package:drift/drift.dart';

class SearchHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {query},
  ];
}

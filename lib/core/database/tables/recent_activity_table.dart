import 'package:drift/drift.dart';

@DataClassName('RecentActivity')
class RecentActivityTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get type => text()(); // 'quran', 'azkar', 'hadith', 'muhasaba'
  TextColumn get title => text()(); // e.g., 'سورة البقرة', 'أذكار الصباح'
  TextColumn get subtitle => text().nullable()(); // e.g., 'آية 255'
  TextColumn get routePath => text()(); // Route to resume activity
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

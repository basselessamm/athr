import 'package:drift/drift.dart';

@DataClassName('ReadingSession')
class ReadingSessionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get featureType =>
      text().withDefault(const Constant('quran'))(); // e.g., 'quran', 'hadith'
  IntColumn get bookId => integer().nullable()();
  IntColumn get surahId => integer().nullable()();
  IntColumn get pageNumber => integer().nullable()();
  IntColumn get verseNumber => integer().nullable()();
  RealColumn get scrollOffset => real().withDefault(const Constant(0.0))();
  TextColumn get themeId => text().nullable()();
  RealColumn get fontSize => real().nullable()();
  TextColumn get updatedAt => text()();
}

import 'package:drift/drift.dart';

@DataClassName('SearchableItem')
class SearchableItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get featureType =>
      text()(); // 'quran_verse', 'surah_name', 'hadith'
  IntColumn get referenceId => integer()(); // surahId or hadith book ID
  IntColumn get secondaryId =>
      integer().nullable()(); // verseNumber or hadith number
  TextColumn get title => text().nullable()();
  TextColumn get content => text()(); // The original text (with diacritics)
  TextColumn get normalizedContent =>
      text()(); // Searchable text (no diacritics)
}

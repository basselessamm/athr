import 'package:drift/drift.dart';

@DataClassName('SavedItem')
class SavedItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get featureType => text()(); // 'quran', 'hadith', 'azkar'
  IntColumn get referenceId => integer()(); // surahId, hadithId
  IntColumn get secondaryId => integer().nullable()(); // verseNumber
  TextColumn get collectionId => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get previewText => text()();
  TextColumn get createdAt => text()();
}

@DataClassName('LibraryCollection')
class CollectionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserNote')
class NotesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get featureType => text()(); // What is this note attached to?
  IntColumn get referenceId =>
      integer().nullable()(); // Can be null if it's a general note
  IntColumn get secondaryId => integer().nullable()();
  TextColumn get content => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';

class ReadingSessionRepository {
  final AppDatabase _db;

  ReadingSessionRepository(this._db);

  Stream<ReadingSession?> watchLastSession(String featureType) {
    return (_db.select(_db.readingSessionTable)
          ..where((t) => t.featureType.equals(featureType))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<ReadingSession?> getLastSession(String featureType) async {
    return (_db.select(_db.readingSessionTable)
          ..where((t) => t.featureType.equals(featureType))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> saveSession({
    required String featureType,
    int? bookId,
    int? surahId,
    int? pageNumber,
    int? verseNumber,
    double scrollOffset = 0.0,
    String? themeId,
    double? fontSize,
  }) async {
    // Delete existing session for this feature
    await (_db.delete(
      _db.readingSessionTable,
    )..where((t) => t.featureType.equals(featureType))).go();

    // Insert new session
    await _db
        .into(_db.readingSessionTable)
        .insert(
          ReadingSessionTableCompanion.insert(
            featureType: Value(featureType),
            bookId: Value(bookId),
            surahId: Value(surahId),
            pageNumber: Value(pageNumber),
            verseNumber: Value(verseNumber),
            scrollOffset: Value(scrollOffset),
            themeId: Value(themeId),
            fontSize: Value(fontSize),
            updatedAt: DateTime.now().toIso8601String(),
          ),
        );
  }
}

final readingSessionRepositoryProvider = Provider<ReadingSessionRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return ReadingSessionRepository(db);
});

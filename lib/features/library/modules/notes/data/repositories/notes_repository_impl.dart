import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/modules/notes/domain/repositories/notes_repository.dart';
import 'package:drift/drift.dart';

class NotesRepositoryImpl implements NotesRepository {
  final AppDatabase _db;

  NotesRepositoryImpl(this._db);

  @override
  Stream<List<UserNote>> watchNotes() {
    return (_db.select(_db.notesTable)..orderBy([
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  @override
  Future<void> remove(int id) async {
    await (_db.delete(_db.notesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> addNote(String content, {String featureType = 'general'}) async {
    final now = DateTime.now().toIso8601String();
    await _db
        .into(_db.notesTable)
        .insert(
          NotesTableCompanion.insert(
            featureType: featureType,
            content: content,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }
}

import 'package:athr/core/database/app_database.dart';

abstract class NotesRepository {
  Stream<List<UserNote>> watchNotes();
  Future<void> remove(int id);
  Future<void> addNote(String content, {String featureType = 'general'});
}

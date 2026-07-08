import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/features/library/modules/notes/domain/repositories/notes_repository.dart';
import 'package:athr/features/library/modules/notes/data/repositories/notes_repository_impl.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepositoryImpl(ref.watch(appDatabaseProvider));
});

final notesProvider = StreamProvider<List<UserNote>>((ref) {
  return ref.watch(notesRepositoryProvider).watchNotes();
});

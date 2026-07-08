import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';

final allMuhasabaEntriesProvider = StreamProvider<List<MuhasabaEntry>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAllMuhasabaEntries();
});

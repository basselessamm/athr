import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';

final allMuhasabaEntriesProvider = StreamProvider<List<MuhasabaEntry>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAllMuhasabaEntries();
});

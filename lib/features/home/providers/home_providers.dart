import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';

final todayMuhasabaProvider = StreamProvider<MuhasabaEntry?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchTodayMuhasaba();
});

final completionActionsProvider = Provider<CompletionActions>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CompletionActions(db);
});

class CompletionActions {
  final AppDatabase _db;

  const CompletionActions(this._db);

  Future<void> saveMuhasaba({
    required bool prayed,
    required bool guardedTongue,
    required bool honoredParents,
    required bool avoidedHarm,
    required bool gaveCharity,
    required bool quranRead,
    String? note,
  }) {
    return _db.saveMuhasabaEntry(
      prayed: prayed,
      guardedTongue: guardedTongue,
      honoredParents: honoredParents,
      avoidedHarm: avoidedHarm,
      gaveCharity: gaveCharity,
      quranRead: quranRead,
      note: note,
    );
  }
}

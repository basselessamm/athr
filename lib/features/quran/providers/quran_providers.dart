import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import 'package:athr/core/database/database_providers.dart';

// Provider to fetch Tafseer for a specific Ayah
final tafseerProvider = FutureProvider.family<String, ({int surah, int ayah})>((
  ref,
  args,
) async {
  final db = ref.watch(appDatabaseProvider);
  final result =
      await (db.select(db.quranTafseerTable)..where(
            (t) =>
                t.surahNumber.equals(args.surah) &
                t.ayahNumber.equals(args.ayah),
          ))
          .getSingleOrNull();

  return result?.tafseerText ?? 'التفسير غير متوفر حالياً.';
});

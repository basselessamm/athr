import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/database/seeder/database_seed_providers.dart';

/// Loads the Quran package only when a Quran surface is opened. Its data
/// initialization is intentionally kept off the app's Home startup path.
final quranInitializationProvider = FutureProvider<void>((ref) async {
  await Quran.initialize();
});

// Provider to fetch Tafseer for a specific Ayah
final tafseerProvider = FutureProvider.family<String, ({int surah, int ayah})>((
  ref,
  args,
) async {
  await ref.watch(tafseerSeedProvider.future);
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

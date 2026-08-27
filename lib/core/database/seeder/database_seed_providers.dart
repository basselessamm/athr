import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/database/database_providers.dart';
import 'db_seeder.dart';

final databaseSeederProvider = Provider<DatabaseSeeder>((ref) {
  return DatabaseSeeder(ref.watch(appDatabaseProvider));
});

final tafseerSeedProvider = FutureProvider<void>((ref) async {
  await ref.watch(databaseSeederProvider).seedTafseerIfNeeded();
});

final azkarSeedProvider = FutureProvider<void>((ref) async {
  await ref.watch(databaseSeederProvider).seedDuasIfNeeded();
});

final hadithSeedProvider = FutureProvider<void>((ref) async {
  await ref.watch(databaseSeederProvider).seedHadithIfNeeded();
});

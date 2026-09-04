import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'domain/memory_contracts.dart';
import 'memory_thread_repository.dart';

final memoryThreadRepositoryProvider = Provider<MemoryThreadRepository>((ref) {
  return MemoryThreadRepository(ref.watch(appDatabaseProvider));
});

final memoryThreadsProvider = StreamProvider<List<MemoryThread>>((ref) {
  return ref.watch(memoryThreadRepositoryProvider).watchActiveThreads();
});

final allMemoryThreadsProvider = StreamProvider<List<MemoryThread>>((ref) {
  return ref.watch(memoryThreadRepositoryProvider).watchAllThreads();
});

final memoryThreadProvider = StreamProvider.family<MemoryThread?, String>((
  ref,
  threadId,
) {
  return ref.watch(memoryThreadRepositoryProvider).watchThread(threadId);
});

final memoryFoundationMigrationProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(memoryThreadRepositoryProvider);
  final preferences = ref.watch(sharedPreferencesProvider);
  return repository.migrateLegacyBookmark(preferences);
});

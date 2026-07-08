import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/search/data/search_repository.dart';

import 'package:athr/features/search/domain/entities/search_result_entity.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<SearchResultEntity>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  // Implement debouncing natively using Riverpod 2.0 cancellation
  // Wait for 300ms before firing the database query.
  // If the query changes within 300ms, the previous FutureProvider gets disposed
  // and the Future.delayed gets cancelled, preventing the db call.
  var isCancelled = false;
  ref.onDispose(() => isCancelled = true);

  await Future.delayed(const Duration(milliseconds: 300));
  if (isCancelled) return []; // Abandon fetch if a new query arrived

  final repository = ref.read(searchRepositoryProvider);
  return repository.search(query);
});

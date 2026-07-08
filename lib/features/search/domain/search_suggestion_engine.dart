import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/search/data/search_history_repository.dart';

class SearchSuggestionEngine {
  final SearchHistoryRepository _historyRepo;

  SearchSuggestionEngine(this._historyRepo);

  Future<List<String>> getSuggestions(String query) async {
    final cleanQuery = query.trim().toLowerCase();

    // Empty State: Show mix of recent and popular
    if (cleanQuery.isEmpty) {
      final recents = await _historyRepo.getRecentSearches(limit: 5);
      if (recents.length >= 5) return recents;

      final populars = await _historyRepo.getPopularSearches();
      final combined = {...recents, ...populars}.toList();
      return combined.take(5).toList();
    }

    // Typing State: Match recent searches by prefix
    final allRecents = await _historyRepo.getRecentSearches(limit: 50);
    final prefixMatches = allRecents
        .where((s) => s.toLowerCase().startsWith(cleanQuery))
        .toList();
    final containsMatches = allRecents
        .where(
          (s) =>
              !s.toLowerCase().startsWith(cleanQuery) &&
              s.toLowerCase().contains(cleanQuery),
        )
        .toList();

    return [...prefixMatches, ...containsMatches].take(5).toList();
  }
}

final searchSuggestionEngineProvider = Provider<SearchSuggestionEngine>((ref) {
  return SearchSuggestionEngine(ref.watch(searchHistoryRepositoryProvider));
});

final searchSuggestionsProvider = FutureProvider.family<List<String>, String>((
  ref,
  query,
) {
  return ref.watch(searchSuggestionEngineProvider).getSuggestions(query);
});

import 'package:athr/features/search/domain/entities/search_result_entity.dart';
import 'package:athr/features/search/domain/search_normalizer.dart';

class SearchRankingEngine {
  /// Ranks a list of search results against a query.
  ///
  /// Priority:
  /// 1. Exact phrase match
  /// 2. Exact word match
  /// 3. Prefix match
  /// 4. Partial match
  static List<SearchResultEntity> rankResults(
    List<SearchResultEntity> results,
    String query,
  ) {
    if (query.trim().isEmpty) return results;

    final normalizedQuery = SearchNormalizer.normalize(query);
    final queryWords = normalizedQuery
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    for (int i = 0; i < results.length; i++) {
      final item = results[i];
      final normalizedContent = SearchNormalizer.normalize(item.content);
      double score = 0.0;

      // 1. Exact phrase match
      if (normalizedContent.contains(normalizedQuery)) {
        score += 1000.0;

        // Exact full content match is even better
        if (normalizedContent == normalizedQuery) {
          score += 500.0;
        }
      }

      // 2. Exact word match
      final contentWords = normalizedContent
          .split(' ')
          .where((w) => w.isNotEmpty)
          .toList();
      for (var qWord in queryWords) {
        if (contentWords.contains(qWord)) {
          score += 100.0;
        }
      }

      // 3. Prefix match
      for (var qWord in queryWords) {
        if (contentWords.any((cWord) => cWord.startsWith(qWord))) {
          score += 50.0;
        }
      }

      // 4. Boost Quran if exact match requested (assumption based on common Islamic app behavior)
      if (item.featureType == 'quran' || item.featureType == 'quran_surah') {
        score += 10.0;
      }

      // Update score
      results[i] = item.copyWith(rankScore: score);
    }

    // Sort descending by score
    results.sort((a, b) => b.rankScore.compareTo(a.rankScore));
    return results;
  }
}

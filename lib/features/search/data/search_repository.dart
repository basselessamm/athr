import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/features/search/domain/search_normalizer.dart';
import 'package:drift/drift.dart';

import 'package:athr/features/search/domain/entities/search_result_entity.dart';
import 'package:athr/features/search/domain/search_result_mapper.dart';
import 'package:athr/features/search/domain/search_ranking_engine.dart';

class SearchRepository {
  final AppDatabase _db;

  SearchRepository(this._db);

  /// Performs a fast FTS5 search across all indexed modules.
  Future<List<SearchResultEntity>> search(
    String query, {
    int limit = 50,
  }) async {
    final normalizedQuery = SearchNormalizer.normalize(query);
    if (normalizedQuery.isEmpty) return [];

    // Use FTS5 MATCH syntax
    final result = await _db
        .customSelect(
          '''
      SELECT rowid as id, title, content, feature_type as featureType, reference_id as referenceId, secondary_id as secondaryId
      FROM search_index 
      WHERE search_index MATCH ? 
      ORDER BY rank 
      LIMIT ?
      ''',
          variables: [
            // Prefix search for the last word to enable incremental typing search
            Variable<String>('"$normalizedQuery"*'),
            Variable<int>(limit),
          ],
        )
        .get();

    final mappedResults = result
        .map((row) => SearchResultMapper.fromDriftRow(row))
        .toList();

    // Apply domain-level ranking
    return SearchRankingEngine.rankResults(mappedResults, query);
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(appDatabaseProvider));
});

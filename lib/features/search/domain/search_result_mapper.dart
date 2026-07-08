import 'package:athr/features/search/domain/entities/search_result_entity.dart';
import 'package:drift/drift.dart';

class SearchResultMapper {
  /// Maps a raw Drift FTS5 row query result to the domain entity.
  static SearchResultEntity fromDriftRow(QueryRow row) {
    return SearchResultEntity(
      id: row.read<int>('id'),
      title: row.read<String?>('title'),
      content: row.read<String>('content'),
      featureType: row.read<String>('featureType'),
      referenceId: row.read<int>('referenceId'),
      secondaryId: row.read<int?>('secondaryId'),
      // Initially, rankScore is mapped to the SQLite BM25 rank (if requested in query)
      // Note: SQLite rank is usually negative (more negative is better), so we multiply by -1
      // or we can just leave it 0 and let SearchRankingEngine handle it.
      rankScore: 0.0,
    );
  }
}

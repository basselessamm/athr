import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:drift/drift.dart';

class SearchHistoryRepository {
  final AppDatabase _db;

  SearchHistoryRepository(this._db);

  /// Get the top recent searches
  Future<List<String>> getRecentSearches({int limit = 10}) async {
    final results =
        await (_db.select(_db.searchHistoryTable)
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.timestamp,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(limit))
            .get();
    return results.map((e) => e.query).toList();
  }

  /// Get popular searches (currently returning static list, can be expanded to analyze local usage)
  Future<List<String>> getPopularSearches() async {
    return ['سورة الكهف', 'سورة يس', 'أذكار الصباح', 'دعاء السفر', 'الاستغفار'];
  }

  /// Add a search query to history (upserting timestamp if it already exists)
  Future<void> addSearchQuery(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    await _db
        .into(_db.searchHistoryTable)
        .insertOnConflictUpdate(
          SearchHistoryTableCompanion.insert(
            query: cleanQuery,
            timestamp: DateTime.now(),
          ),
        );
  }

  /// Delete a search query from history
  Future<void> deleteSearchQuery(String query) async {
    await (_db.delete(
      _db.searchHistoryTable,
    )..where((t) => t.query.equals(query))).go();
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await _db.delete(_db.searchHistoryTable).go();
  }
}

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((
  ref,
) {
  return SearchHistoryRepository(ref.watch(appDatabaseProvider));
});

import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/database/seeder/database_seed_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:midrar/features/settings/providers/settings_providers.dart';

/// Distinct azkar categories (from the category container rows).
final azkarCategoriesProvider = FutureProvider<List<String>>((ref) async {
  await ref.watch(azkarSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final query = db.selectOnly(db.duaTable, distinct: true)
    ..addColumns([db.duaTable.category]);

  final result = await query.map((row) => row.read(db.duaTable.category)).get();
  return result.whereType<String>().toList();
});

/// Category container rows (title + references).
final azkarByCategoryProvider = FutureProvider.family<List<Dua>, String>((
  ref,
  category,
) async {
  await ref.watch(azkarSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final result = await (db.select(
    db.duaTable,
  )..where((t) => t.category.equals(category))).get();
  return result;
});

/// The individual zikr rows of a category, in source order (schema v8).
final zikrByCategoryProvider = FutureProvider.family<List<Zikr>, String>((
  ref,
  category,
) async {
  await ref.watch(azkarSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.zikrTable)
        ..where((t) => t.category.equals(category))
        ..orderBy([(t) => OrderingTerm.asc(t.zikrIndex)]))
      .get();
});

/// Per-category daily session: which zikr ids the user completed today.
///
/// Deliberately NOT a streak or lifetime score — a fresh day starts fresh,
/// and there is nothing to accumulate. State lives in SharedPreferences as
/// {"date": "YYYY-MM-DD", "done": [zikrIds]} and can be reset any time.
class AzkarSessionState {
  const AzkarSessionState({this.completedIds = const <int>{}});

  final Set<int> completedIds;
}

class AzkarSessionNotifier extends StateNotifier<AzkarSessionState> {
  AzkarSessionNotifier(this._prefs, this._category)
    : super(const AzkarSessionState()) {
    _load();
  }

  final SharedPreferences _prefs;
  final String _category;

  static Map<String, Object?> _decode(String? raw) {
    if (raw == null || raw.isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }

  String get _key => 'azkar_session_${_category.hashCode}';

  void _load() {
    final raw = _prefs.getString(_key);
    final data = _decode(raw);
    final storedDate = data['date'];
    final today = _todayKey();
    // A new day starts a fresh session — azkar are daily by nature, and we
    // deliberately keep no history, streaks, or totals.
    if (storedDate != today) {
      state = const AzkarSessionState();
      return;
    }
    final done = (data['done'] as List<dynamic>? ?? const [])
        .whereType<int>()
        .toSet();
    state = AzkarSessionState(completedIds: done);
  }

  Future<void> _persist() async {
    await _prefs.setString(
      _key,
      jsonEncode({
        'date': _todayKey(),
        'done': state.completedIds.toList(growable: false),
      }),
    );
  }

  static String _todayKey() {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '${now.year}-$m-$d';
  }

  Future<void> markCompleted(int zikrId) async {
    if (state.completedIds.contains(zikrId)) return;
    state = AzkarSessionState(completedIds: {...state.completedIds, zikrId});
    await _persist();
  }

  Future<void> markUncompleted(int zikrId) async {
    if (!state.completedIds.contains(zikrId)) return;
    state = AzkarSessionState(
      completedIds: state.completedIds.where((id) => id != zikrId).toSet(),
    );
    await _persist();
  }

  Future<void> reset() async {
    state = const AzkarSessionState();
    await _persist();
  }
}

final azkarSessionProvider = StateNotifierProvider.autoDispose
    .family<AzkarSessionNotifier, AzkarSessionState, String>((ref, category) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return AzkarSessionNotifier(prefs, category);
    });

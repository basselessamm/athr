import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';

import 'package:athr/core/database/database_providers.dart';

// Fetch distinct categories
final azkarCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final query = db.selectOnly(db.duaTable, distinct: true)
    ..addColumns([db.duaTable.category]);

  final result = await query.map((row) => row.read(db.duaTable.category)).get();
  return result.whereType<String>().toList();
});

// Fetch Duas for a specific category
final azkarByCategoryProvider = FutureProvider.family<List<Dua>, String>((
  ref,
  category,
) async {
  final db = ref.watch(appDatabaseProvider);
  final result = await (db.select(
    db.duaTable,
  )..where((t) => t.category.equals(category))).get();
  return result;
});

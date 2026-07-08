import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/database/app_database.dart';

import 'package:athr/core/database/database_providers.dart';

final hadithBooksProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final query = db.selectOnly(db.hadithTable, distinct: true)
    ..addColumns([db.hadithTable.bookName]);

  final result = await query
      .map((row) => row.read(db.hadithTable.bookName))
      .get();
  return result.whereType<String>().toList();
});

final allHadithsProvider = FutureProvider.family<List<Hadith>, String>((
  ref,
  bookName,
) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(
    db.hadithTable,
  )..where((t) => t.bookName.equals(bookName))).get();
});

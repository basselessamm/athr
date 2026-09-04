import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/database/seeder/database_seed_providers.dart';

String resolveHadithBookTitle(String name) {
  final trimmed = name.trim().toLowerCase();
  if (trimmed.contains('bukhari') || trimmed.contains('البخاري')) {
    return 'صحيح البخاري';
  }
  if (trimmed.contains('muslim') || trimmed.contains('مسلم')) {
    return 'صحيح مسلم';
  }
  return name.trim();
}

class HadithChapterInfo {
  final String chapterName;
  final int hadithCount;
  final int firstHadithId;

  const HadithChapterInfo({
    required this.chapterName,
    required this.hadithCount,
    required this.firstHadithId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HadithChapterInfo &&
          runtimeType == other.runtimeType &&
          chapterName == other.chapterName &&
          hadithCount == other.hadithCount &&
          firstHadithId == other.firstHadithId;

  @override
  int get hashCode => Object.hash(chapterName, hadithCount, firstHadithId);
}

class ChapterHadithsQuery {
  final String bookName;
  final String chapterName;

  const ChapterHadithsQuery({
    required this.bookName,
    required this.chapterName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterHadithsQuery &&
          runtimeType == other.runtimeType &&
          bookName == other.bookName &&
          chapterName == other.chapterName;

  @override
  int get hashCode => Object.hash(bookName, chapterName);
}

final hadithBooksProvider = FutureProvider<List<String>>((ref) async {
  await ref.watch(hadithSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final query = db.selectOnly(db.hadithTable, distinct: true)
    ..addColumns([db.hadithTable.bookName]);

  final result = await query
      .map((row) => row.read(db.hadithTable.bookName))
      .get();
  return result.whereType<String>().toList();
});

final hadithChaptersProvider =
    FutureProvider.family<List<HadithChapterInfo>, String>((
  ref,
  bookName,
) async {
  await ref.watch(hadithSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final resolved = resolveHadithBookTitle(bookName);

  final rows = await db.customSelect(
    'SELECT COALESCE(chapter_name, \'بدون باب\') AS ch_name, '
    'COUNT(*) AS cnt, '
    'MIN(id) AS min_id '
    'FROM hadith_table '
    'WHERE book_name = ? '
    'GROUP BY chapter_name '
    'ORDER BY min_id ASC',
    variables: [Variable.withString(resolved)],
    readsFrom: {db.hadithTable},
  ).get();

  return rows.map((row) {
    return HadithChapterInfo(
      chapterName: row.read<String>('ch_name'),
      hadithCount: row.read<int>('cnt'),
      firstHadithId: row.read<int>('min_id'),
    );
  }).toList();
});

final hadithChapterForHadithIdProvider =
    FutureProvider.family<String?, int>((ref, hadithId) async {
  await ref.watch(hadithSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final item = await (db.select(db.hadithTable)
        ..where((t) => t.id.equals(hadithId)))
      .getSingleOrNull();
  return item?.chapterName;
});

final chapterHadithsProvider =
    FutureProvider.family<List<Hadith>, ChapterHadithsQuery>((
  ref,
  query,
) async {
  await ref.watch(hadithSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final resolvedBook = resolveHadithBookTitle(query.bookName);

  if (query.chapterName == 'بدون باب') {
    return (db.select(db.hadithTable)
          ..where(
            (t) =>
                t.bookName.equals(resolvedBook) &
                (t.chapterName.isNull() | t.chapterName.equals('')),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
  }

  return (db.select(db.hadithTable)
        ..where(
          (t) =>
              t.bookName.equals(resolvedBook) &
              t.chapterName.equals(query.chapterName),
        )
        ..orderBy([(t) => OrderingTerm(expression: t.id)]))
      .get();
});

final allHadithsProvider = FutureProvider.family<List<Hadith>, String>((
  ref,
  bookName,
) async {
  await ref.watch(hadithSeedProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final resolvedBook = resolveHadithBookTitle(bookName);
  return (db.select(
    db.hadithTable,
  )..where((t) => t.bookName.equals(resolvedBook))).get();
});

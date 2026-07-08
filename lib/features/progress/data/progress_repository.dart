import 'package:athr/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

class ProgressRepository {
  final AppDatabase _db;

  ProgressRepository(this._db);

  String get _todayDate => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> updateProgress({
    int pagesRead = 0,
    int readingSeconds = 0,
    int azkarCount = 0,
    int hadithCount = 0,
    bool? isMuhasabaDone,
  }) async {
    final today = _todayDate;
    final existing = await (_db.select(
      _db.progressRecordTable,
    )..where((t) => t.date.equals(today))).getSingleOrNull();

    if (existing != null) {
      await _db
          .update(_db.progressRecordTable)
          .replace(
            existing.copyWith(
              pagesRead: existing.pagesRead + pagesRead,
              readingSeconds: existing.readingSeconds + readingSeconds,
              azkarCount: existing.azkarCount + azkarCount,
              hadithCount: existing.hadithCount + hadithCount,
              isMuhasabaDone: isMuhasabaDone ?? existing.isMuhasabaDone,
            ),
          );
    } else {
      await _db
          .into(_db.progressRecordTable)
          .insert(
            ProgressRecordTableCompanion.insert(
              date: today,
              pagesRead: Value(pagesRead),
              readingSeconds: Value(readingSeconds),
              azkarCount: Value(azkarCount),
              hadithCount: Value(hadithCount),
              isMuhasabaDone: Value(isMuhasabaDone ?? false),
            ),
          );
    }
  }

  Stream<ProgressRecord?> watchDailyProgress() {
    return (_db.select(
      _db.progressRecordTable,
    )..where((t) => t.date.equals(_todayDate))).watchSingleOrNull();
  }

  Future<List<ProgressRecord>> getWeeklyProgress() async {
    final sevenDaysAgo = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().subtract(const Duration(days: 7)));
    return await (_db.select(_db.progressRecordTable)
          ..where((t) => t.date.isBiggerOrEqualValue(sevenDaysAgo))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<Map<String, dynamic>> getMonthlyStats() async {
    final thirtyDaysAgo = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().subtract(const Duration(days: 30)));

    final query = _db.select(_db.progressRecordTable)
      ..where((t) => t.date.isBiggerOrEqualValue(thirtyDaysAgo));

    final records = await query.get();

    int totalPages = 0;
    int totalSeconds = 0;
    int activeDays = records.length;

    for (var r in records) {
      totalPages += r.pagesRead;
      totalSeconds += r.readingSeconds;
    }

    return {
      'totalPages': totalPages,
      'totalMinutes': totalSeconds ~/ 60,
      'activeDays': activeDays,
    };
  }
}

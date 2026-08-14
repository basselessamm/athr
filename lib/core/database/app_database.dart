import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'tables/quran_tafseer_table.dart';
import 'tables/hadith_table.dart';
import 'tables/dua_table.dart';
import 'tables/daily_sunnah_table.dart';
import 'tables/daily_task_table.dart';
import 'tables/muhasaba_entry_table.dart';
import 'tables/user_daily_activity_table.dart';
import 'tables/user_favorite_table.dart';
import 'tables/memory_thread_table.dart';
import 'tables/reflection_entry_table.dart';
import 'tables/reading_anchor_table.dart';
import 'tables/return_event_table.dart';
import 'tables/reminder_intent_table.dart';
import 'package:athr/core/memory/migration/legacy_memory_migration.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    QuranTafseerTable,
    HadithTable,
    DuaTable,
    DailySunnahTable,
    DailyTaskTable,
    MuhasabaEntryTable,
    UserFavoriteTable,
    UserDailyActivityTable,
    MemoryThreadTable,
    ReflectionEntryTable,
    ReadingAnchorTable,
    ReturnEventTable,
    ReminderIntentTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(hadithTable, hadithTable.reference);
        await m.createTable(userFavoriteTable);
        await m.createTable(userDailyActivityTable);
      }
      if (from < 3) {
        await m.createTable(dailySunnahTable);
        await m.createTable(dailyTaskTable);
        await m.createTable(muhasabaEntryTable);
      }
      if (from < 4) {
        await customStatement(
          "UPDATE hadith_table SET book_name = 'صحيح البخاري' WHERE book_name = 'Sahih al-Bukhari'",
        );
        await customStatement(
          "UPDATE hadith_table SET book_name = 'صحيح مسلم' WHERE book_name = 'Sahih Muslim'",
        );
      }
      if (from < 5) {
        await m.createTable(memoryThreadTable);
        await m.createTable(reflectionEntryTable);
        await m.createTable(readingAnchorTable);
        await m.createTable(returnEventTable);
        await _migrateLegacyFavorites();
      }
      if (from < 6) {
        await m.createTable(reminderIntentTable);
      }
    },
    beforeOpen: (details) async {
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tafseer_surah_ayah ON quran_tafseer_table (surah_number, ayah_number)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_hadith_book_name ON hadith_table (book_name)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_dua_category ON dua_table (category)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_favorites_lookup ON user_favorite_table (content_type, primary_reference)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_muhasaba_date ON muhasaba_entry_table (activity_date)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_memory_thread_status_updated ON memory_thread_table (status, updated_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_reflection_thread_created ON reflection_entry_table (thread_id, created_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_reading_anchor_thread ON reading_anchor_table (thread_id)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_return_event_thread_occurred ON return_event_table (thread_id, occurred_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_reminder_intent_scheduled ON reminder_intent_table (enabled, scheduled_at)',
      );
    },
  );

  Future<DailySunnah?> getDailySunnahForSeed(int seed) async {
    final count = await _countRows('daily_sunnah_table');
    if (count == 0) {
      return null;
    }

    final offset = Random(seed).nextInt(count);
    return (select(dailySunnahTable)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
          ..limit(1, offset: offset))
        .getSingleOrNull();
  }

  Future<DailyTask?> getDailyTaskForSeed(int seed) async {
    final count = await _countRows('daily_task_table');
    if (count == 0) {
      return null;
    }

    final offset = Random(seed).nextInt(count);
    return (select(dailyTaskTable)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
          ..limit(1, offset: offset))
        .getSingleOrNull();
  }

  Stream<List<UserFavorite>> watchFavorites() {
    return (select(
      userFavoriteTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Stream<bool> watchIsFavorite(String contentType, String primaryReference) {
    final query = select(userFavoriteTable)
      ..where(
        (t) =>
            t.contentType.equals(contentType) &
            t.primaryReference.equals(primaryReference),
      )
      ..limit(1);

    return query.watchSingleOrNull().map((favorite) => favorite != null);
  }

  Future<void> toggleFavorite({
    required String contentType,
    required String primaryReference,
    String? secondaryReference,
    required String title,
    required String contentText,
    required String source,
  }) async {
    final existing =
        await (select(userFavoriteTable)
              ..where(
                (t) =>
                    t.contentType.equals(contentType) &
                    t.primaryReference.equals(primaryReference),
              )
              ..limit(1))
            .getSingleOrNull();

    if (existing != null) {
      await (delete(
        userFavoriteTable,
      )..where((t) => t.id.equals(existing.id))).go();
      return;
    }

    await into(userFavoriteTable).insert(
      UserFavoriteTableCompanion.insert(
        contentType: contentType,
        primaryReference: primaryReference,
        secondaryReference: Value(secondaryReference),
        title: title,
        contentText: contentText,
        source: source,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  Stream<UserDailyActivity?> watchTodayActivity() {
    final today = _dateKey(DateTime.now());
    return (select(userDailyActivityTable)
          ..where((t) => t.activityDate.equals(today))
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<UserDailyActivity>> watchAllActivities() {
    return (select(
      userDailyActivityTable,
    )..orderBy([(t) => OrderingTerm.desc(t.activityDate)])).watch();
  }

  Stream<MuhasabaEntry?> watchTodayMuhasaba() {
    final today = _dateKey(DateTime.now());
    return (select(muhasabaEntryTable)
          ..where((t) => t.activityDate.equals(today))
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<MuhasabaEntry>> watchAllMuhasabaEntries() {
    return (select(
      muhasabaEntryTable,
    )..orderBy([(t) => OrderingTerm.desc(t.activityDate)])).watch();
  }

  Future<void> setDailyTaskCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    final today = _dateKey(DateTime.now());
    final existing =
        await (select(userDailyActivityTable)
              ..where((t) => t.activityDate.equals(today))
              ..limit(1))
            .getSingleOrNull();

    await into(userDailyActivityTable).insertOnConflictUpdate(
      UserDailyActivityTableCompanion(
        activityDate: Value(today),
        completedTaskId: Value(isCompleted ? taskId : null),
        completedSunnahId: Value(existing?.completedSunnahId),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<void> setDailySunnahCompletion({
    required String sunnahId,
    required bool isCompleted,
  }) async {
    final today = _dateKey(DateTime.now());
    final existing =
        await (select(userDailyActivityTable)
              ..where((t) => t.activityDate.equals(today))
              ..limit(1))
            .getSingleOrNull();

    await into(userDailyActivityTable).insertOnConflictUpdate(
      UserDailyActivityTableCompanion(
        activityDate: Value(today),
        completedTaskId: Value(existing?.completedTaskId),
        completedSunnahId: Value(isCompleted ? sunnahId : null),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<void> saveMuhasabaEntry({
    required bool prayed,
    required bool guardedTongue,
    required bool honoredParents,
    required bool avoidedHarm,
    required bool gaveCharity,
    required bool quranRead,
    String? note,
  }) async {
    final today = _dateKey(DateTime.now());
    await into(muhasabaEntryTable).insertOnConflictUpdate(
      MuhasabaEntryTableCompanion(
        activityDate: Value(today),
        prayed: Value(prayed),
        guardedTongue: Value(guardedTongue),
        honoredParents: Value(honoredParents),
        avoidedHarm: Value(avoidedHarm),
        gaveCharity: Value(gaveCharity),
        quranRead: Value(quranRead),
        note: Value(note?.trim().isEmpty ?? true ? null : note!.trim()),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<List<Hadith>> searchHadith(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];
    return (select(hadithTable)
          ..where(
            (t) =>
                t.hadithTextAr.like('%$cleanQuery%') |
                t.chapterName.like('%$cleanQuery%'),
          )
          ..limit(50))
        .get();
  }

  Future<List<Dua>> searchAzkar(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];
    return (select(duaTable)
          ..where(
            (t) =>
                t.duaText.like('%$cleanQuery%') |
                t.reference.like('%$cleanQuery%'),
          )
          ..limit(50))
        .get();
  }

  Future<int> _countRows(String tableName) async {
    final row = await customSelect(
      'SELECT COUNT(*) AS count FROM $tableName',
    ).getSingle();
    return row.read<int>('count');
  }

  Future<void> _migrateLegacyFavorites() async {
    final legacyRows = await select(userFavoriteTable).get();
    if (legacyRows.isEmpty) return;

    final records = <LegacyFavoriteRecord>[];
    for (final row in legacyRows) {
      final createdAt = DateTime.tryParse(row.createdAt);
      if (createdAt == null) continue;
      records.add(
        LegacyFavoriteRecord(
          id: row.id,
          contentType: row.contentType,
          primaryReference: row.primaryReference,
          secondaryReference: row.secondaryReference,
          title: row.title,
          contentText: row.contentText,
          source: row.source,
          createdAt: createdAt,
        ),
      );
    }

    final result = const LegacyMemoryMigration().map(
      favorites: records,
      migrationTime: DateTime.now().toUtc(),
    );
    for (final candidate in result.acceptedFavorites) {
      final thread = candidate.thread;
      await into(memoryThreadTable).insert(
        MemoryThreadTableCompanion.insert(
          id: thread.id,
          sourceKind: thread.source.kind.storageKey,
          sourceCanonicalId: thread.source.canonicalId,
          sourceLabel: thread.source.sourceLabel,
          sourceBook: Value(thread.source.sourceBook),
          sourceCitation: Value(thread.source.sourceCitation),
          sourceVersion: Value(thread.source.sourceVersion),
          sourceSecondaryReference: Value(thread.source.secondaryReference),
          userContextKind: Value(thread.context?.kind.storageKey),
          userContextLabel: Value(thread.context?.customLabel),
          userLabel: Value(thread.userLabel),
          status: Value(thread.status.storageKey),
          resurfacing: Value(thread.resurfacing.storageKey),
          legacyKey: Value(candidate.legacyKey),
          createdAt: thread.createdAt.toIso8601String(),
          updatedAt: thread.updatedAt.toIso8601String(),
          lastReturnedAt: Value(thread.lastReturnedAt?.toIso8601String()),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'athr_db.sqlite'));

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}

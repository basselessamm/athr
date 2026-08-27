import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'tables/quran_tafseer_table.dart';
import 'tables/hadith_table.dart';
import 'tables/dua_table.dart';
import 'tables/zikr_table.dart';
import 'tables/muhasaba_entry_table.dart';
import 'tables/user_favorite_table.dart';
import 'tables/memory_thread_table.dart';
import 'tables/reflection_entry_table.dart';
import 'tables/reading_anchor_table.dart';
import 'tables/return_event_table.dart';
import 'tables/reminder_intent_table.dart';
import 'tables/seed_state_table.dart';
import 'package:midrar/core/memory/migration/legacy_memory_migration.dart';
import 'package:midrar/core/utils/arabic_normalization.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    QuranTafseerTable,
    HadithTable,
    DuaTable,
    ZikrTable,
    MuhasabaEntryTable,
    UserFavoriteTable,
    MemoryThreadTable,
    ReflectionEntryTable,
    ReadingAnchorTable,
    ReturnEventTable,
    ReminderIntentTable,
    SeedStateTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(hadithTable, hadithTable.reference);
        await m.createTable(userFavoriteTable);
      }
      if (from < 3) {
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
      if (from < 7) {
        await m.createTable(seedStateTable);
        await m.addColumn(hadithTable, hadithTable.hadithTextArNorm);
        await m.addColumn(duaTable, duaTable.duaTextNorm);
        // Remove legacy daily-content tables that shipped unseeded and had
        // no consumers; their feature was cut.
        await customStatement('DROP TABLE IF EXISTS daily_sunnah_table');
        await customStatement('DROP TABLE IF EXISTS daily_task_table');
        await customStatement('DROP TABLE IF EXISTS user_daily_activity_table');
        await _backfillNormalizedSearchColumns();
      }
      if (from < 8) {
        await m.createTable(zikrTable);
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
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_hadith_norm ON hadith_table (hadith_text_ar_norm)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_dua_norm ON dua_table (dua_text_norm)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_zikr_category ON zikr_table (category, zikr_index)',
      );
    },
  );

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
    final patterns = _searchPatterns(query);
    if (patterns == null) return const [];
    final (rawPattern, normPattern) = patterns;
    return (select(hadithTable)
          ..where(
            (t) =>
                t.hadithTextAr.like(rawPattern) |
                t.chapterName.like(rawPattern) |
                t.hadithTextArNorm.like(normPattern),
          )
          ..limit(50))
        .get();
  }

  /// Per-zikr search over the schema-v8 item rows (normalized + raw), so a
  /// hit points at the exact zikr rather than a merged category blob.
  Future<List<Zikr>> searchAzkar(String query) async {
    final patterns = _searchPatterns(query);
    if (patterns == null) return const [];
    final (rawPattern, normPattern) = patterns;
    return (select(zikrTable)
          ..where(
            (t) =>
                t.zikrText.like(rawPattern) |
                t.textNorm.like(normPattern),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.category), (t) => OrderingTerm.asc(t.zikrIndex)])
          ..limit(50))
        .get();
  }

  /// Builds (raw, normalized) LIKE patterns for a user query.
  ///
  /// SQL wildcards typed by the user are neutralized rather than escaped;
  /// diacritics/orthography tolerance comes from the normalized column.
  /// Returns null when nothing searchable remains (e.g. query was only
  /// punctuation), preventing degenerate `%%` patterns.
  (String, String)? _searchPatterns(String query) {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return null;
    final safeRaw = cleanQuery.replaceAll(RegExp(r'[%_\\]'), ' ');
    final rawCore = _collapseSpaces(safeRaw);
    final normCore = _collapseSpaces(normalizeArabic(cleanQuery));
    if (rawCore.isEmpty && normCore.isEmpty) return null;
    return (
      '%${rawCore.isEmpty ? normCore : rawCore}%',
      '%$normCore%',
    );
  }

  String _collapseSpaces(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Backfills the normalized search columns for databases created before
  /// schema v7. Runs in chunks so a large hadith corpus cannot block the
  /// migration for long.
  Future<void> _backfillNormalizedSearchColumns() async {
    final hadithRows = await customSelect(
      'SELECT id, hadith_text_ar FROM hadith_table WHERE hadith_text_ar_norm = \'\'',
      readsFrom: {hadithTable},
    ).get();
    for (final row in hadithRows) {
      await customStatement(
        'UPDATE hadith_table SET hadith_text_ar_norm = ? WHERE id = ?',
        [
          normalizeArabic(row.read<String>('hadith_text_ar')),
          row.read<int>('id'),
        ],
      );
    }
    final duaRows = await customSelect(
      'SELECT id, dua_text FROM dua_table WHERE dua_text_norm = \'\'',
      readsFrom: {duaTable},
    ).get();
    for (final row in duaRows) {
      await customStatement(
        'UPDATE dua_table SET dua_text_norm = ? WHERE id = ?',
        [normalizeArabic(row.read<String>('dua_text')), row.read<int>('id')],
      );
    }
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
    final file = File(p.join(dbFolder.path, 'midrar_db.sqlite'));

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}


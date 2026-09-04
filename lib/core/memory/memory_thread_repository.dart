import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:midrar/core/database/app_database.dart';
import 'domain/memory_contracts.dart';
import 'domain/reminder_intent.dart';

class MemoryThreadRepository {
  MemoryThreadRepository(
    this._db, {
    DateTime Function()? now,
    String Function()? idGenerator,
  }) : _now = now ?? DateTime.now,
       _idGenerator = idGenerator ?? _defaultId;

  final AppDatabase _db;
  final DateTime Function() _now;
  final String Function() _idGenerator;

  static const legacyBookmarkMigrationKey =
      'memory_foundation_legacy_bookmark_migrated';
  static const legacyBookmarkAnchorId = 'legacy-quran-bookmark';
  static const legacyBookmarkSurahKey = 'quran_bookmark_surah';
  static const legacyBookmarkOffsetKey = 'quran_bookmark_offset';

  Stream<List<MemoryThread>> watchActiveThreads() {
    final query = _db.select(_db.memoryThreadTable)
      ..where((row) => row.status.equals(ThreadStatus.active.storageKey))
      ..orderBy([
        (row) => OrderingTerm.desc(row.updatedAt),
        (row) => OrderingTerm.desc(row.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<MemoryThread>> watchAllThreads() {
    final query = _db.select(_db.memoryThreadTable)
      ..orderBy([
        (row) => OrderingTerm.desc(row.updatedAt),
        (row) => OrderingTerm.desc(row.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<MemoryThread>> listThreads({bool includeArchived = false}) async {
    final query = _db.select(_db.memoryThreadTable)
      ..orderBy([
        (row) => OrderingTerm.desc(row.updatedAt),
        (row) => OrderingTerm.desc(row.createdAt),
      ]);
    if (!includeArchived) {
      query.where((row) => row.status.equals(ThreadStatus.active.storageKey));
    }
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  Future<MemoryThread?> findThread(String id) async {
    final row =
        await (_db.select(_db.memoryThreadTable)
              ..where((thread) => thread.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Stream<MemoryThread?> watchThread(String id) {
    return (_db.select(_db.memoryThreadTable)
          ..where((thread) => thread.id.equals(id))
          ..limit(1))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toDomain(row));
  }

  Future<MemoryThread> createThread({
    required SourceReference source,
    UserContext? context,
    String? userLabel,
    ResurfacingPolicy resurfacing = ResurfacingPolicy.on,
    String? legacyKey,
  }) async {
    final now = _now();
    final thread = MemoryThread(
      id: _idGenerator(),
      source: source,
      context: context,
      userLabel: userLabel,
      resurfacing: resurfacing,
      createdAt: now,
      updatedAt: now,
    );
    await _db
        .into(_db.memoryThreadTable)
        .insert(_toInsertCompanion(thread, legacyKey: legacyKey));
    return thread;
  }

  Future<void> updateThread(MemoryThread thread) {
    return (_db.update(_db.memoryThreadTable)
          ..where((row) => row.id.equals(thread.id)))
        .write(_toUpdateCompanion(thread));
  }

  Future<void> archiveThread(String threadId) async {
    final thread = await findThread(threadId);
    if (thread == null) return;
    await updateThread(
      thread.copyWith(status: ThreadStatus.archived, updatedAt: _now()),
    );
  }

  Future<void> setResurfacing(String threadId, ResurfacingPolicy policy) async {
    final thread = await findThread(threadId);
    if (thread == null) return;
    await updateThread(thread.copyWith(resurfacing: policy, updatedAt: _now()));
  }

  Future<void> deleteThread(String threadId) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.returnEventTable,
      )..where((row) => row.threadId.equals(threadId))).go();
      await (_db.delete(
        _db.reflectionEntryTable,
      )..where((row) => row.threadId.equals(threadId))).go();
      await (_db.delete(
        _db.readingAnchorTable,
      )..where((row) => row.threadId.equals(threadId))).go();
      await (_db.delete(
        _db.reminderIntentTable,
      )..where((row) => row.threadId.equals(threadId))).go();
      await (_db.delete(
        _db.memoryThreadTable,
      )..where((row) => row.id.equals(threadId))).go();
    });
  }

  Future<void> saveReflection(ReflectionEntry reflection) async {
    final thread = await findThread(reflection.threadId);
    if (thread == null) {
      throw StateError('Cannot save reflection for missing memory thread');
    }
    await _db
        .into(_db.reflectionEntryTable)
        .insertOnConflictUpdate(
          ReflectionEntryTableCompanion.insert(
            id: reflection.id,
            threadId: reflection.threadId,
            body: reflection.body,
            createdAt: reflection.createdAt.toIso8601String(),
            updatedAt: reflection.updatedAt.toIso8601String(),
            deletedAt: Value(reflection.deletedAt?.toIso8601String()),
          ),
        );
  }

  Future<List<ReflectionEntry>> listReflections(String threadId) async {
    final rows =
        await (_db.select(_db.reflectionEntryTable)
              ..where(
                (row) => row.threadId.equals(threadId) & row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
            .get();
    return rows
        .map(
          (row) => ReflectionEntry(
            id: row.id,
            threadId: row.threadId,
            body: row.body,
            createdAt: DateTime.parse(row.createdAt),
            updatedAt: DateTime.parse(row.updatedAt),
            deletedAt: row.deletedAt == null
                ? null
                : DateTime.parse(row.deletedAt!),
          ),
        )
        .toList();
  }

  Future<void> saveReadingAnchor(
    ReadingAnchor anchor, {
    String? threadId,
    String? anchorId,
  }) async {
    final id =
        anchorId ??
        (threadId == null
            ? 'reading-anchor-${anchor.sourceCanonicalId}'
            : 'reading-anchor-thread-$threadId');
    await _db
        .into(_db.readingAnchorTable)
        .insertOnConflictUpdate(
          ReadingAnchorTableCompanion.insert(
            id: id,
            threadId: Value(threadId),
            sourceCanonicalId: anchor.sourceCanonicalId,
            surahNumber: Value(anchor.surahNumber),
            ayahNumber: Value(anchor.ayahNumber),
            pageNumber: Value(anchor.pageNumber),
            itemIndex: Value(anchor.itemIndex),
            scrollOffset: Value(anchor.scrollOffset),
            updatedAt: anchor.updatedAt.toIso8601String(),
          ),
        );
  }

  Future<ReadingAnchor?> findReadingAnchor({
    String? threadId,
    String? anchorId,
  }) async {
    if (threadId == null && anchorId == null) {
      throw ArgumentError('threadId or anchorId is required');
    }
    final id = anchorId ?? 'reading-anchor-thread-$threadId';
    final row =
        await (_db.select(_db.readingAnchorTable)
              ..where((anchor) => anchor.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return ReadingAnchor(
      sourceCanonicalId: row.sourceCanonicalId,
      surahNumber: row.surahNumber,
      ayahNumber: row.ayahNumber,
      pageNumber: row.pageNumber,
      itemIndex: row.itemIndex,
      scrollOffset: row.scrollOffset,
      updatedAt: DateTime.parse(row.updatedAt),
    );
  }

  Future<List<ReturnEvent>> listReturnEvents(String threadId) async {
    final rows =
        await (_db.select(_db.returnEventTable)
              ..where((row) => row.threadId.equals(threadId))
              ..orderBy([(row) => OrderingTerm.desc(row.occurredAt)]))
            .get();
    return rows
        .map(
          (row) => ReturnEvent(
            id: row.id,
            threadId: row.threadId,
            kind: ReturnEventKind.fromStorageKey(row.kind),
            occurredAt: DateTime.parse(row.occurredAt),
            durationSeconds: row.durationSeconds,
            reflectionId: row.reflectionId,
          ),
        )
        .toList();
  }

  Future<List<ReminderIntent>> listReminderIntents() async {
    final rows = await (_db.select(
      _db.reminderIntentTable,
    )..orderBy([(row) => OrderingTerm.asc(row.scheduledAt)])).get();
    return rows.map(_reminderFromRow).toList();
  }

  Future<ReminderIntent?> findReminderIntent(String threadId) async {
    final row =
        await (_db.select(_db.reminderIntentTable)
              ..where((item) => item.threadId.equals(threadId))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _reminderFromRow(row);
  }

  Future<void> saveReminderIntent(ReminderIntent intent) async {
    if (await findThread(intent.threadId) == null) {
      throw StateError('Cannot save reminder for missing memory thread');
    }
    await _db
        .into(_db.reminderIntentTable)
        .insertOnConflictUpdate(
          ReminderIntentTableCompanion.insert(
            id: intent.id,
            threadId: intent.threadId,
            scheduledAt: intent.scheduledAt.toIso8601String(),
            enabled: Value(intent.enabled),
          ),
        );
  }

  Future<void> deleteReminderIntent(String threadId) async {
    await (_db.delete(
      _db.reminderIntentTable,
    )..where((row) => row.threadId.equals(threadId))).go();
  }

  Future<void> recordReturn(ReturnEvent event) async {
    await _db.transaction(() async {
      final thread = await findThread(event.threadId);
      if (thread == null) {
        throw StateError('Cannot record return for missing memory thread');
      }
      await _db
          .into(_db.returnEventTable)
          .insert(
            ReturnEventTableCompanion.insert(
              id: event.id,
              threadId: event.threadId,
              kind: event.kind.storageKey,
              occurredAt: event.occurredAt.toIso8601String(),
              durationSeconds: Value(event.durationSeconds),
              reflectionId: Value(event.reflectionId),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      await (_db.update(
        _db.memoryThreadTable,
      )..where((row) => row.id.equals(event.threadId))).write(
        MemoryThreadTableCompanion(
          updatedAt: Value(_now().toIso8601String()),
          lastReturnedAt: Value(event.occurredAt.toIso8601String()),
        ),
      );
    });
  }

  Future<bool> migrateLegacyBookmark(SharedPreferences preferences) async {
    if (preferences.getBool(legacyBookmarkMigrationKey) ?? false) {
      return false;
    }

    final surah = preferences.getInt(legacyBookmarkSurahKey);
    if (surah == null) {
      await preferences.setBool(legacyBookmarkMigrationKey, true);
      return false;
    }

    final offset = preferences.getDouble(legacyBookmarkOffsetKey) ?? 0.0;
    final anchor = ReadingAnchor(
      sourceCanonicalId: 'quran:surah:$surah',
      surahNumber: surah,
      scrollOffset: offset,
      updatedAt: _now(),
    );
    await saveReadingAnchor(anchor, anchorId: legacyBookmarkAnchorId);
    await preferences.setBool(legacyBookmarkMigrationKey, true);
    return true;
  }

  ReminderIntent _reminderFromRow(ReminderIntentRow row) {
    return ReminderIntent(
      id: row.id,
      threadId: row.threadId,
      scheduledAt: DateTime.parse(row.scheduledAt),
      enabled: row.enabled,
    );
  }

  MemoryThread _toDomain(MemoryThreadRow row) {
    final contextKind = row.userContextKind == null
        ? null
        : UserContextKind.fromStorageKey(row.userContextKind!);
    return MemoryThread(
      id: row.id,
      source: SourceReference(
        kind: SourceKind.fromStorageKey(row.sourceKind),
        canonicalId: row.sourceCanonicalId,
        sourceLabel: row.sourceLabel,
        sourceBook: row.sourceBook,
        sourceCitation: row.sourceCitation,
        sourceVersion: row.sourceVersion,
        secondaryReference: row.sourceSecondaryReference,
      ),
      context: contextKind == null
          ? null
          : UserContext(kind: contextKind, customLabel: row.userContextLabel),
      userLabel: row.userLabel,
      status: ThreadStatus.fromStorageKey(row.status),
      resurfacing: ResurfacingPolicy.fromStorageKey(row.resurfacing),
      createdAt: DateTime.parse(row.createdAt),
      updatedAt: DateTime.parse(row.updatedAt),
      lastReturnedAt: row.lastReturnedAt == null
          ? null
          : DateTime.parse(row.lastReturnedAt!),
    );
  }

  MemoryThreadTableCompanion _toInsertCompanion(
    MemoryThread thread, {
    String? legacyKey,
  }) {
    return MemoryThreadTableCompanion.insert(
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
      legacyKey: Value(legacyKey),
      createdAt: thread.createdAt.toIso8601String(),
      updatedAt: thread.updatedAt.toIso8601String(),
      lastReturnedAt: Value(thread.lastReturnedAt?.toIso8601String()),
    );
  }

  MemoryThreadTableCompanion _toUpdateCompanion(MemoryThread thread) {
    return MemoryThreadTableCompanion(
      sourceKind: Value(thread.source.kind.storageKey),
      sourceCanonicalId: Value(thread.source.canonicalId),
      sourceLabel: Value(thread.source.sourceLabel),
      sourceBook: Value(thread.source.sourceBook),
      sourceCitation: Value(thread.source.sourceCitation),
      sourceVersion: Value(thread.source.sourceVersion),
      sourceSecondaryReference: Value(thread.source.secondaryReference),
      userContextKind: Value(thread.context?.kind.storageKey),
      userContextLabel: Value(thread.context?.customLabel),
      userLabel: Value(thread.userLabel),
      status: Value(thread.status.storageKey),
      resurfacing: Value(thread.resurfacing.storageKey),
      updatedAt: Value(thread.updatedAt.toIso8601String()),
      lastReturnedAt: Value(thread.lastReturnedAt?.toIso8601String()),
    );
  }
}

String _defaultId() => 'thread-${DateTime.now().microsecondsSinceEpoch}';

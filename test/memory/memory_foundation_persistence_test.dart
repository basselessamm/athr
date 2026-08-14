import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/core/memory/memory_thread_repository.dart';

void main() {
  late AppDatabase database;

  tearDown(() async {
    await database.close();
  });

  test(
    'creates, hydrates, and deletes a memory thread with user data separated',
    () async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      final repository = MemoryThreadRepository(
        database,
        now: () => DateTime.utc(2026, 1, 1),
        idGenerator: () => 'thread-1',
      );
      final source = SourceReference.quranVerse(
        surahNumber: 18,
        ayahNumber: 10,
        sourceLabel: 'القرآن الكريم',
      );

      final thread = await repository.createThread(
        source: source,
        context: const UserContext(kind: UserContextKind.returnTo),
      );
      await repository.saveReflection(
        ReflectionEntry(
          id: 'reflection-1',
          threadId: thread.id,
          body: 'ملاحظتي الخاصة',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );
      await repository.saveReadingAnchor(
        ReadingAnchor(
          sourceCanonicalId: source.canonicalId,
          surahNumber: 18,
          ayahNumber: 10,
          scrollOffset: 12.5,
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
        threadId: thread.id,
      );
      await repository.recordReturn(
        ReturnEvent(
          id: 'return-1',
          threadId: thread.id,
          kind: ReturnEventKind.resumed,
          occurredAt: DateTime.utc(2026, 1, 2),
        ),
      );

      final hydrated = await repository.findThread(thread.id);
      final reflections = await repository.listReflections(thread.id);
      final anchor = await repository.findReadingAnchor(threadId: thread.id);
      final events = await (database.select(database.returnEventTable).get());

      expect(hydrated, isNotNull);
      expect(hydrated!.source.canonicalId, 'quran:verse:18:10');
      expect(hydrated.context?.kind, UserContextKind.returnTo);
      expect(hydrated.lastReturnedAt, DateTime.utc(2026, 1, 2));
      expect(reflections.single.body, 'ملاحظتي الخاصة');
      expect(anchor!.sourceCanonicalId, source.canonicalId);
      expect(anchor.ayahNumber, 10);
      expect(anchor.scrollOffset, 12.5);
      expect(events.single.kind, ReturnEventKind.resumed.storageKey);

      await repository.deleteThread(thread.id);
      expect(await repository.findThread(thread.id), isNull);
      expect(await repository.listReflections(thread.id), isEmpty);
      expect(await repository.findReadingAnchor(threadId: thread.id), isNull);
      expect(await database.select(database.returnEventTable).get(), isEmpty);
    },
  );

  test(
    'migrates v4 favorites to threads and preserves legacy fallback rows',
    () async {
      database = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (db) {
            _createV4Schema(db);
            db.execute('''
            INSERT INTO user_favorite_table
              (id, content_type, primary_reference, secondary_reference, title, content_text, source, created_at)
            VALUES
              (1, 'verse', '2:255', NULL, 'آية', 'نص legacy', 'القرآن الكريم', '2025-12-31T00:00:00.000Z'),
              (2, 'hadith', '1', 'صحيح البخاري', 'حديث', 'نص حديث legacy', 'صحيح البخاري، حديث 1', '2025-12-31T00:00:00.000Z'),
              (3, 'unknown', 'x', NULL, 'غير مدعوم', 'fallback text', 'legacy', '2025-12-31T00:00:00.000Z')
          ''');
            db.execute('PRAGMA user_version = 4');
          },
        ),
      );

      final threads = await database.select(database.memoryThreadTable).get();
      final legacyRows = await database
          .select(database.userFavoriteTable)
          .get();

      expect(threads, hasLength(2));
      expect(
        threads.map((row) => row.sourceCanonicalId),
        containsAll(<String>['quran:verse:2:255', 'hadith:bukhari:1']),
      );
      expect(threads.every((row) => row.userLabel == null), isTrue);
      expect(legacyRows, hasLength(3));
      expect(legacyRows.last.contentText, 'fallback text');
      expect(database.schemaVersion, 6);
      expect(
        await database.select(database.reminderIntentTable).get(),
        isEmpty,
      );
    },
  );

  test('migrates legacy bookmark once and keeps it idempotent', () async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({
      'quran_bookmark_surah': 36,
      'quran_bookmark_offset': 18.25,
    });
    final preferences = await SharedPreferences.getInstance();
    final repository = MemoryThreadRepository(
      database,
      now: () => DateTime.utc(2026, 1, 1),
    );

    expect(await repository.migrateLegacyBookmark(preferences), isTrue);
    expect(await repository.migrateLegacyBookmark(preferences), isFalse);

    final anchor = await repository.findReadingAnchor(
      anchorId: MemoryThreadRepository.legacyBookmarkAnchorId,
    );
    expect(anchor!.sourceCanonicalId, 'quran:surah:36');
    expect(anchor.surahNumber, 36);
    expect(anchor.scrollOffset, 18.25);
    expect(
      preferences.getBool(MemoryThreadRepository.legacyBookmarkMigrationKey),
      isTrue,
    );
  });

  test(
    'does not create a bookmark anchor when legacy bookmark is absent',
    () async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = MemoryThreadRepository(database);

      expect(await repository.migrateLegacyBookmark(preferences), isFalse);
      expect(
        await repository.findReadingAnchor(
          anchorId: MemoryThreadRepository.legacyBookmarkAnchorId,
        ),
        isNull,
      );
      expect(
        preferences.getBool(MemoryThreadRepository.legacyBookmarkMigrationKey),
        isTrue,
      );
    },
  );
}

void _createV4Schema(dynamic db) {
  db.execute('''
    CREATE TABLE quran_tafseer_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      surah_number INTEGER NOT NULL,
      ayah_number INTEGER NOT NULL,
      tafseer_text TEXT NOT NULL
    )
  ''');
  db.execute('''
    CREATE TABLE hadith_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      book_name TEXT NOT NULL,
      chapter_name TEXT,
      reference TEXT,
      hadith_text_ar TEXT NOT NULL,
      hadith_text_en TEXT,
      is_bookmarked INTEGER NOT NULL DEFAULT 0
    )
  ''');
  db.execute('''
    CREATE TABLE dua_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category TEXT NOT NULL,
      dua_text TEXT NOT NULL,
      reference TEXT,
      is_bookmarked INTEGER NOT NULL DEFAULT 0
    )
  ''');
  db.execute('''
    CREATE TABLE daily_sunnah_table (
      id TEXT NOT NULL PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      how_to_apply TEXT NOT NULL,
      source TEXT NOT NULL,
      sort_order INTEGER NOT NULL
    )
  ''');
  db.execute('''
    CREATE TABLE daily_task_table (
      id TEXT NOT NULL PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      impact TEXT NOT NULL,
      sort_order INTEGER NOT NULL
    )
  ''');
  db.execute('''
    CREATE TABLE muhasaba_entry_table (
      activity_date TEXT NOT NULL PRIMARY KEY,
      prayed INTEGER NOT NULL DEFAULT 0,
      guarded_tongue INTEGER NOT NULL DEFAULT 0,
      honored_parents INTEGER NOT NULL DEFAULT 0,
      avoided_harm INTEGER NOT NULL DEFAULT 0,
      gave_charity INTEGER NOT NULL DEFAULT 0,
      quran_read INTEGER NOT NULL DEFAULT 0,
      note TEXT,
      updated_at TEXT NOT NULL
    )
  ''');
  db.execute('''
    CREATE TABLE user_daily_activity_table (
      activity_date TEXT NOT NULL PRIMARY KEY,
      completed_task_id TEXT,
      completed_sunnah_id TEXT,
      updated_at TEXT NOT NULL
    )
  ''');
  db.execute('''
    CREATE TABLE user_favorite_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content_type TEXT NOT NULL,
      primary_reference TEXT NOT NULL,
      secondary_reference TEXT,
      title TEXT NOT NULL,
      content_text TEXT NOT NULL,
      source TEXT NOT NULL,
      created_at TEXT NOT NULL,
      UNIQUE (content_type, primary_reference)
    )
  ''');
}

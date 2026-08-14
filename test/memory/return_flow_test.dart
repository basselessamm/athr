import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/core/memory/memory_thread_repository.dart';
import 'package:athr/features/memory_return/application/memory_return_service.dart';

void main() {
  late AppDatabase database;
  late MemoryThreadRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = MemoryThreadRepository(
      database,
      now: () => DateTime.utc(2026, 3, 1),
      idGenerator: () => 'thread-return-1',
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'resolves exact canonical source routes for all returnable source kinds',
    () {
      final service = MemoryReturnService(repository);

      expect(
        service.routeForSource(
          SourceReference.quranVerse(
            surahNumber: 18,
            ayahNumber: 10,
            sourceLabel: 'القرآن الكريم',
          ),
        ),
        '/quran/18?ayah=10',
      );
      expect(
        service.routeForSource(
          SourceReference.hadith(
            bookId: 'bukhari',
            hadithId: '42',
            sourceLabel: 'صحيح البخاري',
            sourceBook: 'صحيح البخاري',
          ),
        ),
        '/hadith/%D8%B5%D8%AD%D9%8A%D8%AD%20%D8%A7%D9%84%D8%A8%D8%AE%D8%A7%D8%B1%D9%8A?hadithId=42',
      );
      expect(
        service.routeForSource(
          SourceReference.azkar(
            itemId: '7',
            category: 'morning',
            sourceLabel: 'الأذكار',
          ),
        ),
        '/azkar/morning?itemId=7',
      );
    },
  );

  test(
    'records return event and updates lastReturnedAt without a score',
    () async {
      final thread = await repository.createThread(
        source: SourceReference.quranVerse(
          surahNumber: 18,
          ayahNumber: 10,
          sourceLabel: 'القرآن الكريم',
        ),
      );
      final service = MemoryReturnService(
        repository,
        now: () => DateTime.utc(2026, 3, 2),
        idGenerator: (_) => 'return-1',
      );

      final event = await service.recordReturn(thread);
      final hydrated = await repository.findThread(thread.id);
      final events = await repository.listReturnEvents(thread.id);

      expect(event.kind, ReturnEventKind.resumed);
      expect(events.single.id, 'return-1');
      expect(hydrated!.lastReturnedAt, DateTime.utc(2026, 3, 2));
    },
  );

  test(
    '14-day resurfacing clock is quiet, eligible, and disableable',
    () async {
      final thread = MemoryThread(
        id: 'thread-clock',
        source: SourceReference.quranReading(
          surahNumber: 18,
          sourceLabel: 'القرآن الكريم',
        ),
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );
      final service = MemoryReturnService(
        repository,
        now: () => DateTime.utc(2026, 1, 15),
      );

      expect(
        service.shouldResurface(thread, now: DateTime.utc(2026, 1, 15)),
        isTrue,
      );
      expect(
        service.shouldResurface(thread, now: DateTime.utc(2026, 1, 14)),
        isFalse,
      );
      expect(
        service.shouldResurface(
          thread.copyWith(resurfacing: ResurfacingPolicy.off),
          now: DateTime.utc(2026, 2, 1),
        ),
        isFalse,
      );
    },
  );

  test('archive and delete controls preserve safe local lifecycle', () async {
    final thread = await repository.createThread(
      source: SourceReference.azkar(
        itemId: '7',
        category: 'morning',
        sourceLabel: 'الأذكار',
      ),
    );
    final service = MemoryReturnService(repository);

    await service.setResurfacing(thread.id, ResurfacingPolicy.off);
    await service.archive(thread.id);
    final archived = await repository.findThread(thread.id);
    expect(archived!.status, ThreadStatus.archived);
    expect(archived.resurfacing, ResurfacingPolicy.off);

    await service.delete(thread.id);
    expect(await repository.findThread(thread.id), isNull);
  });
}

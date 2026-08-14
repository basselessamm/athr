import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/core/memory/domain/reminder_intent.dart';
import 'package:athr/core/memory/memory_thread_repository.dart';

void main() {
  late AppDatabase database;
  late MemoryThreadRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = MemoryThreadRepository(
      database,
      now: () => DateTime.utc(2026, 4, 1),
      idGenerator: () => 'thread-reminder-1',
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'stores one user-selected reminder per existing thread idempotently',
    () async {
      final thread = await repository.createThread(
        source: SourceReference.quranVerse(
          surahNumber: 18,
          ayahNumber: 10,
          sourceLabel: 'القرآن الكريم',
        ),
      );
      final first = ReminderIntent(
        id: 'reminder-${thread.id}',
        threadId: thread.id,
        scheduledAt: DateTime.utc(2026, 4, 2, 9),
      );
      final replacement = first.copyWith(
        scheduledAt: DateTime.utc(2026, 4, 3, 19),
      );

      await repository.saveReminderIntent(first);
      await repository.saveReminderIntent(replacement);
      final stored = await repository.findReminderIntent(thread.id);

      expect(stored!.scheduledAt, DateTime.utc(2026, 4, 3, 19));
      expect((await repository.listReminderIntents()), hasLength(1));
    },
  );

  test('rejects reminders whose thread does not exist', () async {
    final intent = ReminderIntent(
      id: 'missing-reminder',
      threadId: 'missing-thread',
      scheduledAt: DateTime.utc(2026, 4, 2),
    );

    expect(
      () => repository.saveReminderIntent(intent),
      throwsA(isA<StateError>()),
    );
  });

  test(
    'deleting a thread removes its reminder through cascade cleanup',
    () async {
      final thread = await repository.createThread(
        source: SourceReference.azkar(
          itemId: '7',
          category: 'morning',
          sourceLabel: 'الأذكار',
        ),
      );
      await repository.saveReminderIntent(
        ReminderIntent(
          id: 'reminder-${thread.id}',
          threadId: thread.id,
          scheduledAt: DateTime.utc(2026, 4, 2),
        ),
      );

      await repository.deleteThread(thread.id);

      expect(await repository.findReminderIntent(thread.id), isNull);
    },
  );
}

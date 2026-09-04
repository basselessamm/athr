import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/memory/memory_providers.dart';
import 'package:midrar/core/memory/memory_thread_repository.dart';
import 'package:midrar/features/home/presentation/continuation_canvas.dart';
import 'package:midrar/features/memory_return/application/memory_return_service.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  Widget harness(List<MemoryThread> threads) {
    return ProviderScope(
      overrides: [
        memoryThreadsProvider.overrideWith((ref) => Stream.value(threads)),
        memoryReturnServiceProvider.overrideWithValue(
          MemoryReturnService(
            MemoryThreadRepositoryForTest(database),
            now: () => DateTime.utc(2026, 1, 15),
          ),
        ),
      ],
      child: const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: ContinuationCanvas()),
        ),
      ),
    );
  }

  testWidgets('zero threads gives an invitation, not a daily dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(harness(const []));
    await tester.pump();

    expect(find.text('لا توجد خيوط بعد'), findsOneWidget);
    expect(find.text('اكتشاف معنى جديد'), findsNothing);
    expect(find.textContaining('سلسلة'), findsNothing);
    expect(find.textContaining('برنامجك اليومي'), findsNothing);
  });

  testWidgets('one thread renders source, context, and return action in RTL', (
    tester,
  ) async {
    final thread = MemoryThread(
      id: 'canvas-thread-1',
      source: SourceReference.quranVerse(
        surahNumber: 18,
        ayahNumber: 10,
        sourceLabel: 'القرآن الكريم',
      ),
      context: const UserContext(kind: UserContextKind.returnTo),
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    await tester.pumpWidget(harness([thread]));
    await tester.pump();

    expect(find.text('خيوط العودة'), findsOneWidget);
    expect(find.text('القرآن الكريم'), findsOneWidget);
    expect(find.textContaining('18:10'), findsOneWidget);
    expect(find.text('أعود إليه'), findsOneWidget);
    expect(find.text('العودة إلى المصدر'), findsOneWidget);
    expect(find.textContaining('سلسلة'), findsNothing);
    expect(find.textContaining('نقاط'), findsNothing);
  });
}

class MemoryThreadRepositoryForTest extends MemoryThreadRepository {
  MemoryThreadRepositoryForTest(super.database)
    : super(now: () => DateTime.utc(2026, 1, 15));
}

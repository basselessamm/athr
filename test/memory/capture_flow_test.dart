import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/core/memory/memory_providers.dart';
import 'package:athr/core/memory/memory_thread_repository.dart';
import 'package:athr/features/memory_capture/presentation/capture_flow.dart';

void main() {
  late AppDatabase database;
  late MemoryThreadRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = MemoryThreadRepository(
      database,
      now: () => DateTime.utc(2026, 2, 1),
      idGenerator: () => 'thread-capture-1',
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('captures a real source immediately without context or note', () async {
    final service = CaptureService(
      repository,
      now: () => DateTime.utc(2026, 2, 1),
      reflectionIdGenerator: (_) => 'reflection-capture-1',
    );
    final source = CaptureSource(
      reference: SourceReference.quranVerse(
        surahNumber: 18,
        ayahNumber: 10,
        sourceLabel: 'القرآن الكريم',
      ),
      displayText: 'رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً',
    );

    final thread = await service.capture(source: source);
    final persisted = await repository.findThread(thread.id);
    final reflections = await repository.listReflections(thread.id);

    expect(persisted, isNotNull);
    expect(persisted!.source.canonicalId, 'quran:verse:18:10');
    expect(persisted.source.sourceCitation, '18:10');
    expect(persisted.context, isNull);
    expect(persisted.userLabel, isNull);
    expect(reflections, isEmpty);
  });

  test(
    'stores optional context and private note outside the source contract',
    () async {
      final service = CaptureService(
        repository,
        now: () => DateTime.utc(2026, 2, 1),
        reflectionIdGenerator: (_) => 'reflection-capture-2',
      );
      final source = CaptureSource(
        reference: SourceReference.azkar(
          itemId: '7',
          category: 'morning',
          sourceLabel: 'الأذكار',
          sourceCitation: 'صحيح',
        ),
        displayText: 'ذكر موثق من قاعدة المحتوى',
      );

      final thread = await service.capture(
        source: source,
        contextKind: UserContextKind.applyLater,
        privateNote: 'أريد تذكر هذا عند العودة',
      );
      final persisted = await repository.findThread(thread.id);
      final reflections = await repository.listReflections(thread.id);
      final sourceRow = await (database.select(
        database.memoryThreadTable,
      )..where((row) => row.id.equals(thread.id))).getSingle();

      expect(persisted!.source.canonicalId, 'azkar:7');
      expect(persisted.context?.kind, UserContextKind.applyLater);
      expect(reflections.single.body, 'أريد تذكر هذا عند العودة');
      expect(sourceRow.sourceCanonicalId, 'azkar:7');
      expect(sourceRow.userContextKind, 'apply_later');
      expect(sourceRow.userLabel, isNull);
      expect(
        sourceRow.toString().contains('ذكر موثق من قاعدة المحتوى'),
        isFalse,
      );
    },
  );

  testWidgets(
    'CaptureSheet shows provenance and exposes one-tap capture action',
    (tester) async {
      final source = CaptureSource(
        reference: SourceReference.hadith(
          bookId: 'bukhari',
          hadithId: '42',
          sourceLabel: 'صحيح البخاري',
          sourceBook: 'صحيح البخاري',
          sourceCitation: 'حديث 42',
        ),
        displayText: 'نص الحديث من المصدر',
      );
      final parent = ProviderContainer(
        overrides: [
          memoryThreadRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(parent.dispose);
      await tester.binding.setSurfaceSize(const Size(800, 2600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: parent,
          child: MaterialApp(
            home: Scaffold(body: CaptureSheet(source: source)),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('اترك أثرًا'), findsOneWidget);
      expect(find.text('من المصدر'), findsOneWidget);
      expect(find.text('صحيح البخاري'), findsWidgets);
      expect(find.text('نص الحديث من المصدر'), findsOneWidget);
      expect(find.text('ملاحظة خاصة (اختيارية)'), findsOneWidget);

      final captureButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(captureButton.onPressed, isNotNull);
    },
  );
}

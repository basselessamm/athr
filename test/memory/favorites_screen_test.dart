import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/memory/memory_providers.dart';
import 'package:midrar/features/favorites/presentation/favorites_screen.dart';
import 'package:midrar/features/favorites/providers/favorites_providers.dart';

void main() {
  testWidgets('FavoritesScreen renders filter chips and handles active threads', (tester) async {
    final fakeThread = MemoryThread(
      id: 'test-thread-1',
      source: SourceReference.quranVerse(
        surahNumber: 67,
        ayahNumber: 3,
        sourceLabel: 'سورة الملك · الآية 3',
      ),
      context: const UserContext(kind: UserContextKind.returnTo),
      userLabel: 'تأمل في الإتقان',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allMemoryThreadsProvider.overrideWith((ref) => Stream.value([fakeThread])),
          favoritesProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const MaterialApp(
          home: FavoritesScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify filter chips
    expect(find.text('خيوط العودة النشطة'), findsOneWidget);
    expect(find.text('المؤرشفة'), findsOneWidget);
    expect(find.text('المحفوظات السابقة'), findsOneWidget);

    // Verify thread content rendered
    expect(find.text('سورة الملك · الآية 3'), findsOneWidget);
    expect(find.text('العودة للموضع'), findsOneWidget);
    expect(find.text('التفاصيل'), findsOneWidget);
  });
}

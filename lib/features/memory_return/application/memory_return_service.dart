import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/core/memory/domain/reminder_intent.dart';
import 'package:athr/core/memory/memory_providers.dart';
import 'package:athr/core/memory/memory_thread_repository.dart';

class MemoryReturnService {
  MemoryReturnService(
    this._repository, {
    DateTime Function()? now,
    String Function(String threadId)? idGenerator,
  }) : _now = now ?? DateTime.now,
       _idGenerator = idGenerator ?? _defaultReturnId;

  final MemoryThreadRepository _repository;
  final DateTime Function() _now;
  final String Function(String threadId)? _idGenerator;

  Future<ReturnEvent> recordReturn(
    MemoryThread thread, {
    ReturnEventKind kind = ReturnEventKind.resumed,
  }) async {
    final event = ReturnEvent(
      id: _idGenerator!(thread.id),
      threadId: thread.id,
      kind: kind,
      occurredAt: _now(),
    );
    await _repository.recordReturn(event);
    return event;
  }

  Future<void> returnToThread(
    GoRouter router,
    MemoryThread thread, {
    ReturnEventKind kind = ReturnEventKind.resumed,
  }) async {
    await recordReturn(thread, kind: kind);
    router.push(_routeFor(thread.source));
  }

  bool shouldResurface(
    MemoryThread thread, {
    DateTime? now,
    Duration quietPeriod = const Duration(days: 14),
  }) {
    if (thread.resurfacing == ResurfacingPolicy.off) return false;
    final reference = thread.lastReturnedAt ?? thread.createdAt;
    final current = now ?? _now();
    return !current.isBefore(reference.add(quietPeriod));
  }

  String routeForSource(SourceReference source) => _routeFor(source);

  String _routeFor(SourceReference source) {
    switch (source.kind) {
      case SourceKind.quranVerse:
        final parts = source.canonicalId.split(':');
        if (parts.length != 4) {
          throw StateError('Invalid Quran verse canonical reference');
        }
        return '/quran/${parts[2]}?ayah=${parts[3]}';
      case SourceKind.hadith:
        final parts = source.canonicalId.split(':');
        if (parts.length != 3) {
          throw StateError('Invalid hadith canonical reference');
        }
        final book = Uri.encodeComponent(source.sourceBook ?? parts[1]);
        return '/hadith/$book?hadithId=${parts[2]}';
      case SourceKind.azkar:
        final itemId = source.canonicalId.substring('azkar:'.length);
        final category = source.secondaryReference;
        if (itemId.isEmpty || category == null || category.isEmpty) {
          throw StateError('Invalid azkar canonical reference');
        }
        return '/azkar/${Uri.encodeComponent(category)}?itemId=$itemId';
      case SourceKind.dua:
        final itemId = source.canonicalId.substring('dua:'.length);
        final category = source.secondaryReference;
        if (itemId.isEmpty || category == null || category.isEmpty) {
          throw StateError('Invalid dua canonical reference');
        }
        return '/azkar/${Uri.encodeComponent(category)}?itemId=$itemId';
      case SourceKind.quranReading:
        final parts = source.canonicalId.split(':');
        if (parts.length != 3) {
          throw StateError('Invalid Quran reading canonical reference');
        }
        return '/quran/${parts[2]}';
      case SourceKind.situation:
        final id = source.canonicalId.substring('situation:'.length);
        if (id.isEmpty) {
          throw StateError('Invalid situation canonical reference');
        }
        return '/situations/$id';
    }
  }

  Future<void> archive(String threadId) => _repository.archiveThread(threadId);

  Future<void> delete(String threadId) => _repository.deleteThread(threadId);

  Future<void> setResurfacing(String threadId, ResurfacingPolicy policy) =>
      _repository.setResurfacing(threadId, policy);
}

String _defaultReturnId(String threadId) =>
    'return-$threadId-${DateTime.now().microsecondsSinceEpoch}';

final memoryReturnServiceProvider = Provider<MemoryReturnService>((ref) {
  return MemoryReturnService(ref.watch(memoryThreadRepositoryProvider));
});

final threadReflectionsProvider =
    FutureProvider.family<List<ReflectionEntry>, String>((ref, threadId) {
      return ref
          .watch(memoryThreadRepositoryProvider)
          .listReflections(threadId);
    });

final threadReturnEventsProvider =
    FutureProvider.family<List<ReturnEvent>, String>((ref, threadId) {
      return ref
          .watch(memoryThreadRepositoryProvider)
          .listReturnEvents(threadId);
    });

final threadAnchorProvider = FutureProvider.family<ReadingAnchor?, String>((
  ref,
  threadId,
) {
  return ref
      .watch(memoryThreadRepositoryProvider)
      .findReadingAnchor(threadId: threadId);
});

final threadReminderIntentProvider =
    FutureProvider.family<ReminderIntent?, String>((ref, threadId) {
      return ref
          .watch(memoryThreadRepositoryProvider)
          .findReminderIntent(threadId);
    });

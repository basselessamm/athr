import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/memory/memory_providers.dart';
import 'package:midrar/features/memory_return/application/memory_return_service.dart';

class ContinuationCanvas extends ConsumerWidget {
  const ContinuationCanvas({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(memoryThreadsProvider);
    final theme = Theme.of(context);

    return threadsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _CanvasMessage(
        title: 'تعذر فتح خيوطك الآن',
        body: 'يمكنك متابعة القراءة، وسنحاول تحميل الخيوط مرة أخرى لاحقًا.',
        actionLabel: 'استكشاف المصادر',
        onAction: () => context.push('/quran'),
      ),
      data: (threads) {
        final ordered = [...threads]
          ..sort((a, b) => _threadSortKey(b).compareTo(_threadSortKey(a)));
        final surfaced = ordered
            .where(
              (thread) =>
                  ref.read(memoryReturnServiceProvider).shouldResurface(thread),
            )
            .toList();
        final visible = surfaced.isEmpty ? ordered : surfaced;

        if (visible.isEmpty) {
          return _CanvasMessage(
            title: 'لا توجد خيوط بعد',
            body:
                'ابدأ من آية أو حديث أو ذكر واحفظ ما يلهمك لتعود إليه متى شئت.',
            actionLabel: 'اكتشاف مصدر',
            onAction: () => context.push('/quran'),
          );
        }

        final content = <Widget>[
          Text(
            'خيوط العودة',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            'ما التقطته من معنى، محفوظًا لتعود إليه بطريقتك.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 20),
          ...visible.map(
            (thread) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ThreadCanvasCard(
                thread: thread,
                onOpen: () => context.push('/memory/${thread.id}'),
                onReturn: () => ref
                    .read(memoryReturnServiceProvider)
                    .returnToThread(
                      GoRouter.of(context),
                      thread,
                      kind: ReturnEventKind.opened,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/quran'),
            icon: const Icon(Icons.explore_outlined),
            label: const Text('اكتشاف معنى جديد'),
          ),
        ];
        if (embedded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: content,
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: content,
        );
      },
    );
  }

  DateTime _threadSortKey(MemoryThread thread) {
    return thread.lastReturnedAt ?? thread.updatedAt;
  }
}

class _ThreadCanvasCard extends StatelessWidget {
  final MemoryThread thread;
  final VoidCallback onOpen;
  final VoidCallback onReturn;

  const _ThreadCanvasCard({
    required this.thread,
    required this.onOpen,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final source = thread.source;
    final citation = [
      source.sourceBook,
      source.sourceCitation,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF1C443B).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: isDark ? 0.4 : 0.6,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _iconFor(source.kind),
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        source.sourceLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                if (citation.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    citation,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
                if (thread.context != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      avatar: Icon(
                        Icons.bookmark_outline,
                        size: 15,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        _contextLabel(thread.context!),
                        style: const TextStyle(fontSize: 12),
                      ),
                      side: BorderSide(color: theme.colorScheme.outline),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: onReturn,
                  icon: const Icon(Icons.keyboard_return, size: 18),
                  label: const Text('العودة إلى المصدر'),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onOpen,
                    child: const Text('فتح تفاصيل الخيط'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(SourceKind kind) {
    switch (kind) {
      case SourceKind.quranVerse:
      case SourceKind.quranReading:
        return Icons.menu_book_outlined;
      case SourceKind.hadith:
        return Icons.library_books_outlined;
      case SourceKind.dua:
      case SourceKind.azkar:
        return Icons.spa_outlined;
      case SourceKind.situation:
        return Icons.lightbulb_outline;
    }
  }

  String _contextLabel(UserContext context) {
    switch (context.kind) {
      case UserContextKind.returnTo:
        return 'أعود إليه';
      case UserContextKind.continueLater:
        return 'أكمله لاحقًا';
      case UserContextKind.quietReading:
        return 'قراءة هادئة';
      case UserContextKind.applyLater:
        return 'أطبقه لاحقًا';
      case UserContextKind.custom:
        return context.customLabel ?? 'سياق خاص';
    }
  }
}

class _CanvasMessage extends StatelessWidget {
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  const _CanvasMessage({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.route_outlined,
              size: 52,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.explore_outlined),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

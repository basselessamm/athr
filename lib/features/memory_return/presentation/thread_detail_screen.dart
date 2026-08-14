import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/core/memory/domain/reminder_intent.dart';
import 'package:athr/core/services/notification_service.dart';
import 'package:athr/core/memory/memory_providers.dart';
import '../application/memory_return_service.dart';

/// A reminder must point to a future local instant. This is intentionally
/// separate from the picker UI so it is deterministic and regression-testable.
bool isFutureReminderSchedule(DateTime scheduledAt, {DateTime? now}) {
  return scheduledAt.isAfter(now ?? DateTime.now());
}

class ThreadDetailScreen extends ConsumerWidget {
  final String threadId;

  const ThreadDetailScreen({super.key, required this.threadId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadAsync = ref.watch(memoryThreadProvider(threadId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخيط'),
        actions: [
          threadAsync.maybeWhen(
            data: (thread) => thread == null
                ? const SizedBox.shrink()
                : PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenu(context, ref, thread, value),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'archive',
                        child: Text('أرشفة الخيط'),
                      ),
                      PopupMenuItem(value: 'delete', child: Text('حذف الخيط')),
                    ],
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: threadAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('تعذر تحميل الخيط: $error')),
        data: (thread) {
          if (thread == null) {
            return const Center(child: Text('هذا الخيط غير متاح.'));
          }
          return _ThreadDetailBody(thread: thread);
        },
      ),
    );
  }

  Future<void> _handleMenu(
    BuildContext context,
    WidgetRef ref,
    MemoryThread thread,
    String value,
  ) async {
    final service = ref.read(memoryReturnServiceProvider);
    if (value == 'archive') {
      await service.archive(thread.id);
      ref.invalidate(memoryThreadProvider(thread.id));
      if (context.mounted) context.pop();
      return;
    }
    if (value == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('حذف الخيط؟'),
          content: const Text('سيُحذف الخيط وانعكاساته وموضعه المحلي.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('حذف'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      await service.delete(thread.id);
      if (context.mounted) context.pop();
    }
  }
}

class _ThreadDetailBody extends ConsumerWidget {
  final MemoryThread thread;

  const _ThreadDetailBody({required this.thread});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reflectionsAsync = ref.watch(threadReflectionsProvider(thread.id));
    final anchorAsync = ref.watch(threadAnchorProvider(thread.id));
    final eventsAsync = ref.watch(threadReturnEventsProvider(thread.id));
    final theme = Theme.of(context);
    final source = thread.source;
    final citation = [
      source.sourceBook,
      source.sourceCitation,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'من المصدر',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Text(
                  source.sourceLabel,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                if (citation.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(citation, textAlign: TextAlign.right),
                ],
                const SizedBox(height: 10),
                Text(
                  source.canonicalId,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
        if (thread.context != null) ...[
          const SizedBox(height: 12),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            tileColor: theme.colorScheme.surfaceContainerHighest,
            leading: const Icon(Icons.bookmark_outline),
            title: const Text('سياق العودة'),
            subtitle: Text(_contextLabel(thread.context!)),
          ),
        ],
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          value: thread.resurfacing == ResurfacingPolicy.on,
          onChanged: (enabled) async {
            await ref
                .read(memoryReturnServiceProvider)
                .setResurfacing(
                  thread.id,
                  enabled ? ResurfacingPolicy.on : ResurfacingPolicy.off,
                );
            ref.invalidate(memoryThreadProvider(thread.id));
          },
          title: const Text('السماح بإعادة الظهور'),
          subtitle: const Text(
            'تحكم محلي، بلا إشعارات تلقائية في هذه المرحلة.',
          ),
        ),
        const SizedBox(height: 12),
        _ReminderIntentCard(thread: thread),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => ref
              .read(memoryReturnServiceProvider)
              .returnToThread(GoRouter.of(context), thread),
          icon: const Icon(Icons.open_in_new),
          label: const Text('العودة إلى المصدر'),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                'انعكاساتك الخاصة',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            IconButton(
              onPressed: () => _addReflection(context, ref),
              icon: const Icon(Icons.add_comment_outlined),
              tooltip: 'إضافة انعكاس',
            ),
          ],
        ),
        reflectionsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text('تعذر تحميل الانعكاسات: $error'),
          data: (reflections) => reflections.isEmpty
              ? const Text('لا توجد ملاحظة خاصة لهذا الخيط بعد.')
              : Column(
                  children: reflections
                      .map(
                        (reflection) => Card(
                          margin: const EdgeInsets.only(top: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text(
                              reflection.body,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 22),
        Text(
          'موضع القراءة',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        anchorAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text('تعذر تحميل الموضع: $error'),
          data: (anchor) => Text(
            anchor == null
                ? 'سيُحفظ موضع القراءة عند توفره.'
                : _anchorLabel(anchor),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'سجل العودة',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        eventsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text('تعذر تحميل سجل العودة: $error'),
          data: (events) => events.isEmpty
              ? const Text('لم تسجل عودة بعد.')
              : Text(
                  '${events.length} عودة مسجلة محليًا.',
                  textAlign: TextAlign.right,
                ),
        ),
      ],
    );
  }

  Future<void> _addReflection(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final body = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انعكاس خاص'),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            hintText: 'اكتب ما تريد تذكره عند العودة',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    controller.dispose();
    final cleanBody = body?.trim();
    if (cleanBody == null || cleanBody.isEmpty) return;
    final now = DateTime.now();
    await ref
        .read(memoryThreadRepositoryProvider)
        .saveReflection(
          ReflectionEntry(
            id: 'reflection-${thread.id}-${now.microsecondsSinceEpoch}',
            threadId: thread.id,
            body: cleanBody,
            createdAt: now,
            updatedAt: now,
          ),
        );
    ref.invalidate(threadReflectionsProvider(thread.id));
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

  String _anchorLabel(ReadingAnchor anchor) {
    final values = [
      if (anchor.surahNumber != null) 'سورة ${anchor.surahNumber}',
      if (anchor.ayahNumber != null) 'آية ${anchor.ayahNumber}',
      if (anchor.pageNumber != null) 'صفحة ${anchor.pageNumber}',
      if (anchor.itemIndex != null) 'عنصر ${anchor.itemIndex}',
    ];
    return values.isEmpty ? 'موضع محفوظ' : values.join(' · ');
  }
}

class _ReminderIntentCard extends ConsumerWidget {
  final MemoryThread thread;

  const _ReminderIntentCard({required this.thread});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderAsync = ref.watch(threadReminderIntentProvider(thread.id));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: reminderAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text('تعذر تحميل التذكير: $error'),
          data: (intent) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'تذكير اختياري',
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                intent == null
                    ? 'اختر موعدًا واحدًا للعودة إلى هذا الخيط.'
                    : 'موعد العودة: ${_formatDateTime(intent.scheduledAt)}',
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _choose(context, ref),
                icon: const Icon(Icons.schedule_outlined),
                label: Text(intent == null ? 'اختيار موعد' : 'تغيير الموعد'),
              ),
              if (intent != null) ...[
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => _disable(context, ref, intent),
                  child: const Text('إلغاء التذكير'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _choose(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !context.mounted) return;
    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    if (!isFutureReminderSchedule(scheduledAt)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('اختر وقتًا لاحقًا من الآن لتفعيل التذكير.'),
          ),
        );
      }
      return;
    }
    final intent = ReminderIntent(
      id: 'reminder-${thread.id}',
      threadId: thread.id,
      scheduledAt: scheduledAt,
    );
    final notificationService = ref.read(notificationServiceProvider);
    final granted = await notificationService.requestPermission();
    if (!granted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يلزم السماح بالإشعارات لتفعيل التذكير.'),
          ),
        );
      }
      return;
    }
    final returnService = ref.read(memoryReturnServiceProvider);
    await ref.read(memoryThreadRepositoryProvider).saveReminderIntent(intent);
    await notificationService.scheduleReminderIntent(
      intent: intent,
      thread: thread,
      deepLink: NotificationService.threadSourceDeepLink(
        sourceRoute: returnService.routeForSource(thread.source),
        threadId: thread.id,
      ),
    );
    ref.invalidate(threadReminderIntentProvider(thread.id));
  }

  Future<void> _disable(
    BuildContext context,
    WidgetRef ref,
    ReminderIntent intent,
  ) async {
    final notifications = ref.read(notificationServiceProvider);
    await notifications.cancelReminderIntent(intent);
    await ref
        .read(memoryThreadRepositoryProvider)
        .deleteReminderIntent(thread.id);
    ref.invalidate(threadReminderIntentProvider(thread.id));
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }
}

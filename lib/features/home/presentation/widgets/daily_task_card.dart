import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/widgets/athr_card.dart';
import 'package:athr/features/home/providers/home_providers.dart';

class DailyTaskCard extends ConsumerWidget {
  const DailyTaskCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(dailyTaskProvider);
    final activityAsync = ref.watch(todayActivityProvider);

    return AthrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'مهمة اليوم',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/challenges'),
                child: const Text('كل التحديات'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          taskAsync.when(
            data: (task) {
              if (task == null) {
                return const Text('لا توجد مهمة يومية متاحة الآن.');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    task.impact,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  activityAsync.when(
                    data: (activity) {
                      final isCompleted = activity?.completedTaskId == task.id;
                      return FilledButton.icon(
                        onPressed: () {
                          ref
                              .read(completionActionsProvider)
                              .toggleTask(
                                taskId: task.id,
                                isCompleted: !isCompleted,
                              );
                        },
                        icon: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                        ),
                        label: Text(
                          isCompleted
                              ? 'أُنجزت المهمة اليوم'
                              : 'سأبدأ المهمة الآن',
                        ),
                      );
                    },
                    loading: () => const LinearProgressIndicator(minHeight: 2),
                    error: (error, stackTrace) => const SizedBox.shrink(),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Text('تعذر تحميل مهمة اليوم: $error'),
          ),
        ],
      ),
    );
  }
}

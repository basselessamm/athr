import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/core/widgets/athr_card.dart';
import 'package:athr/features/home/providers/home_providers.dart';

class DailySunnahCard extends ConsumerWidget {
  const DailySunnahCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sunnahAsync = ref.watch(dailySunnahProvider);
    final activityAsync = ref.watch(todayActivityProvider);

    return AthrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'سنة اليوم',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          sunnahAsync.when(
            data: (sunnah) {
              if (sunnah == null) {
                return const Text('لا توجد سنة يومية متاحة الآن.');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    sunnah.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sunnah.description,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'كيف تطبقها اليوم: ${sunnah.howToApply}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    sunnah.source,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  activityAsync.when(
                    data: (activity) {
                      final isCompleted =
                          activity?.completedSunnahId == sunnah.id;
                      return FilledButton.icon(
                        onPressed: () {
                          ref
                              .read(completionActionsProvider)
                              .toggleSunnah(
                                sunnahId: sunnah.id,
                                isCompleted: !isCompleted,
                              );
                        },
                        icon: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.auto_awesome_outlined,
                        ),
                        label: Text(
                          isCompleted ? 'تم تطبيق سنة اليوم' : 'سأطبقها اليوم',
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
            error: (error, stackTrace) => Text('تعذر تحميل سنة اليوم: $error'),
          ),
        ],
      ),
    );
  }
}

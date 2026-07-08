import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/features/favorites/providers/favorites_providers.dart';
import 'package:athr/features/home/providers/home_providers.dart';
import 'package:athr/features/muhasaba/providers/muhasaba_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyProgressAsync = ref.watch(dailyProgressProvider);
    final favoritesAsync = ref.watch(favoritesProvider);
    final activityAsync = ref.watch(todayActivityProvider);
    final muhasabaAsync = ref.watch(allMuhasabaEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإنجازات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          dailyProgressAsync.when(
            data: (progress) {
              final favoritesCount = favoritesAsync.valueOrNull?.length ?? 0;
              final muhasabaCount = muhasabaAsync.valueOrNull?.length ?? 0;

              return _SummaryGrid(
                items: [
                  _SummaryItem(
                    label: 'السلسلة الحالية',
                    value: '${progress.streak}',
                  ),
                  _SummaryItem(
                    label: 'العناصر المحفوظة',
                    value: '$favoritesCount',
                  ),
                  _SummaryItem(
                    label: 'جلسات المحاسبة',
                    value: '$muhasabaCount',
                  ),
                  _SummaryItem(
                    label: 'إنجاز اليوم',
                    value: progress.taskCompleted || progress.sunnahCompleted
                        ? 'نعم'
                        : 'ليس بعد',
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text('تعذر تحميل الإحصاءات: $error'),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'ملخص اليوم',
            child: activityAsync.when(
              data: (activity) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity?.completedTaskId != null
                          ? 'أتممت مهمة اليوم.'
                          : 'لم تُسجل مهمة مكتملة اليوم بعد.',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activity?.completedSunnahId != null
                          ? 'سنة اليوم تم تعليمها كمطبقة.'
                          : 'سنة اليوم لم تُحسم بعد.',
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) =>
                  Text('تعذر تحميل نشاط اليوم: $error'),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'آخر جلسات المحاسبة',
            child: muhasabaAsync.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return const Text('لا توجد جلسات محاسبة محفوظة بعد.');
                }

                return Column(
                  children: entries.take(5).map((entry) {
                    final score = [
                      entry.prayed,
                      entry.guardedTongue,
                      entry.honoredParents,
                      entry.avoidedHarm,
                      entry.gaveCharity,
                      entry.quranRead,
                    ].where((item) => item).length;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(child: Text('$score')),
                      title: Text(entry.activityDate),
                      subtitle: Text(entry.note ?? 'بدون ملاحظة مكتوبة'),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) =>
                  Text('تعذر تحميل جلسات المحاسبة: $error'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final List<_SummaryItem> items;

  const _SummaryGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(item.label, textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryItem {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/features/home/presentation/widgets/daily_dua_card.dart';
import 'package:athr/features/home/presentation/widgets/daily_hadith_card.dart';
import 'package:athr/features/home/presentation/widgets/daily_sunnah_card.dart';
import 'package:athr/features/home/presentation/widgets/daily_task_card.dart';
import 'package:athr/features/home/presentation/widgets/daily_verse_card.dart';
import 'package:athr/features/home/providers/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(dailyProgressProvider);

    return AthrScaffold(
      title: 'أَثَر',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search'),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        physics: const BouncingScrollPhysics(),
        children: [
          _TodayHeader(progressAsync: progressAsync),
          const SizedBox(height: 16),
          const DailyVerseCard(),
          const DailyHadithCard(),
          const DailyDuaCard(),
          const DailySunnahCard(),
          const DailyTaskCard(),
          const SizedBox(height: 12),
          _SituationsBanner(onTap: () => context.push('/situations')),
          const SizedBox(height: 24),
          Text(
            'كل جزء هنا هدفه أن يخرج معك إلى اليوم الحقيقي، لا أن يبقى داخل الشاشة فقط.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 0),
    );
  }
}

class _TodayHeader extends StatelessWidget {
  final AsyncValue<DailyProgress> progressAsync;

  const _TodayHeader({required this.progressAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: progressAsync.when(
        data: (progress) {
          final chips = [
            _HeaderChip(
              icon: progress.taskCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              label: progress.taskCompleted
                  ? 'مهمة اليوم اكتملت'
                  : 'مهمة اليوم بانتظارك',
            ),
            _HeaderChip(
              icon: progress.sunnahCompleted
                  ? Icons.auto_awesome
                  : Icons.auto_awesome_outlined,
              label: progress.sunnahCompleted
                  ? 'سنة اليوم طُبقت'
                  : 'سنة اليوم لم تُطبق بعد',
            ),
            _HeaderChip(
              icon: Icons.local_fire_department_outlined,
              label: progress.streak == 0
                  ? 'ابدأ سلسلة اليوم'
                  : 'سلسلة ${progress.streak} يوم',
            ),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'برنامجك اليومي المختصر',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'اقرأ قليلًا، اعمل قليلًا، لكن لا تنقطع.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, children: chips),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/progress'),
                      icon: const Icon(Icons.insights_outlined),
                      label: const Text('الإنجازات'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.push('/muhasaba'),
                      icon: const Icon(Icons.nightlight_round),
                      label: const Text('المحاسبة'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 96,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'برنامجك اليومي المختصر',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'تعذر تحميل حالة اليوم الآن، لكن المحتوى ما زال متاحًا للقراءة والعمل.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _SituationsBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _SituationsBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text('💡', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مواقف الحياة',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'آيات وأدعية وخطوات عملية للمواقف التي تضيق فيها النفس أو تتردد.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_typography.dart';

import 'package:athr/features/home/presentation/sections/smart_greeting_section.dart';
import 'package:athr/features/home/presentation/sections/continue_reading_card.dart';
import 'package:athr/features/home/presentation/sections/today_goals_section.dart';
import 'package:athr/features/home/presentation/sections/quick_actions_grid.dart';
import 'package:athr/features/home/presentation/widgets/daily_goal_progress_card.dart';

// Old widgets kept for future reference or migration if needed:
// import 'package:athr/features/home/presentation/widgets/daily_verse_card.dart';
// import 'package:athr/features/home/presentation/widgets/daily_hadith_card.dart';
// import 'package:athr/features/home/presentation/widgets/daily_dua_card.dart';
// import 'package:athr/features/home/presentation/widgets/daily_sunnah_card.dart';
// import 'package:athr/features/home/presentation/widgets/daily_task_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.04),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.28, 1.0],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SmartGreetingSection(),
                    const SizedBox(height: AppSpacing.lg),
                    const ContinueReadingCard(),
                    const SizedBox(height: AppSpacing.xl),
                    const _SectionIntro(
                      eyebrow: 'نظرة اليوم',
                      title: 'تابع هدفك بخطوات واضحة',
                      subtitle:
                          'راقب التقدم الحالي ثم انتقل مباشرة إلى الأهداف اليومية الأقرب للإنجاز.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: DailyGoalProgressCard(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const TodayGoalsSection(),
                    const SizedBox(height: AppSpacing.xl),
                    const QuickActionsGrid(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 0),
    );
  }
}

class _SectionIntro extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _SectionIntro({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: AppShadows.minimal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTypography.cairoTextTheme().titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/progress/providers/progress_providers.dart';
import 'package:athr/features/progress/presentation/widgets/daily_progress_circle.dart';
import 'package:athr/features/progress/presentation/widgets/weekly_bar_chart.dart';
import 'package:athr/features/progress/presentation/widgets/streak_heatmap.dart';
import 'package:athr/features/progress/presentation/widgets/insight_cards.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dailyAsync = ref.watch(dailyProgressProvider);
    final weeklyAsync = ref.watch(weeklyProgressProvider);
    final monthlyAsync = ref.watch(monthlyStatsProvider);

    return AthrScaffold(
      title: 'التقدم والإنجاز',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'ملخص اليوم',
                  style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    boxShadow: AppShadows.card,
                  ),
                  child: dailyAsync.when(
                    data: (record) => DailyProgressCircle(record: record),
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) =>
                        const Text('حدث خطأ في تحميل بيانات اليوم'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'أداء الأسبوع',
                  style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    boxShadow: AppShadows.card,
                  ),
                  child: weeklyAsync.when(
                    data: (records) => WeeklyBarChart(records: records),
                    loading: () => const SizedBox(
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) =>
                        const Text('حدث خطأ في تحميل الأسبوع'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'سجل الاستمرارية',
                  style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    boxShadow: AppShadows.card,
                  ),
                  child: weeklyAsync.when(
                    data: (records) => StreakHeatmap(records: records),
                    loading: () => const SizedBox(
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) => const SizedBox(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'رؤى وتحليلات',
                  style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                monthlyAsync.when(
                  data: (stats) => InsightCards(monthlyStats: stats),
                  loading: () => const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => const Text('حدث خطأ في الإحصائيات'),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

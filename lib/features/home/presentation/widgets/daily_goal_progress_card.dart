import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/features/progress/providers/goal_wiring_providers.dart';

class DailyGoalProgressCard extends ConsumerWidget {
  const DailyGoalProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalSummaryAsync = ref.watch(goalSummaryProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملخص أهداف اليوم',
                      style: AppTypography.cairoTextTheme().titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'صورة دقيقة لحالة أهدافك مع إبراز الهدف الأقرب للإنجاز.',
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/goal_setting'),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('تعديل'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          goalSummaryAsync.when(
            data: (summary) {
              final goalProgress = summary.primaryGoal;

              if (goalProgress == null) {
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Icon(
                          Icons.track_changes_rounded,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'لم تقم بتحديد هدف بعد. اختر هدفاً بسيطاً وابدأ من اليوم.',
                          style: AppTypography.cairoTextTheme().bodyMedium
                              ?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final percent = goalProgress.percent;
              final completed = goalProgress.isCompleted;
              final remaining =
                  (goalProgress.goal.targetValue - goalProgress.currentValue)
                      .clamp(0, goalProgress.goal.targetValue);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _SummaryChip(
                        label: '${summary.totalGoals} أهداف',
                        backgroundColor: theme.colorScheme.surface.withValues(
                          alpha: 0.88,
                        ),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      _SummaryChip(
                        label: '${summary.completedGoals} مكتمل',
                        backgroundColor: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.9),
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      _SummaryChip(
                        label:
                            '${_formatPercent(summary.averagePercent)} متوسط الإنجاز',
                        backgroundColor: theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.72),
                        foregroundColor: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: completed
                              ? theme.colorScheme.primary.withValues(
                                  alpha: 0.12,
                                )
                              : theme.colorScheme.secondaryContainer.withValues(
                                  alpha: 0.5,
                                ),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Icon(
                          completed
                              ? Icons.check_circle_rounded
                              : Icons.flag_circle_rounded,
                          color: completed
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goalProgress.goal.title,
                              style: AppTypography.cairoTextTheme().titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              completed
                                  ? 'أحسنت، أنجزت الهدف بالكامل.'
                                  : '${goalProgress.currentValue} من ${goalProgress.goal.targetValue} في الهدف الأقرب الآن',
                              style: AppTypography.cairoTextTheme().bodyMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface.withValues(
                                  alpha: 0.88,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.round,
                                ),
                              ),
                              child: Text(
                                completed
                                    ? 'اكتمل الهدف'
                                    : 'المتبقي $remaining',
                                style: AppTypography.cairoTextTheme()
                                    .labelMedium
                                    ?.copyWith(
                                      color: completed
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: completed
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                        child: Text(
                          _formatPercent(percent),
                          style: AppTypography.cairoTextTheme().labelLarge
                              ?.copyWith(
                                color: completed
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        completed
                            ? 'مسارك اليومي مكتمل'
                            : 'استمر، أنت تبني عادة ثابتة',
                        style: AppTypography.cairoTextTheme().bodySmall
                            ?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        '${goalProgress.currentValue} من ${goalProgress.goal.targetValue}',
                        style: AppTypography.cairoTextTheme().labelMedium
                            ?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.round),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 14,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      color: completed
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                'حدث خطأ في تحميل الهدف: $error',
                style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _SummaryChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Text(
        label,
        style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

String _formatPercent(double value) {
  return '${(value * 100).round()}%';
}

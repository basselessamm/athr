import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/widgets/athr_glass_card.dart';
import 'package:athr/features/progress/providers/goal_engine_provider.dart';
import 'package:athr/features/progress/providers/goal_wiring_providers.dart';

class TodayGoalsSection extends ConsumerWidget {
  const TodayGoalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalEngineProvider);
    final summaryAsync = ref.watch(goalSummaryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                      'أهداف اليوم',
                      style: AppTypography.cairoTextTheme().titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'قسّم إنجازك اليومي إلى أهداف صغيرة يسهل متابعتها وإكمالها.',
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              summaryAsync.maybeWhen(
                data: (summary) => _SectionCountPill(
                  totalGoals: summary.totalGoals,
                  completedGoals: summary.completedGoals,
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          summaryAsync.maybeWhen(
            data: (summary) {
              if (summary.totalGoals == 0) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _GoalsSummaryStrip(summary: summary),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          goalsAsync.when(
            data: (goalProgressList) {
              if (goalProgressList.isEmpty) {
                return const _GoalsEmptyState();
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 720
                      ? 3
                      : constraints.maxWidth >= 430
                      ? 2
                      : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: crossAxisCount == 1 ? 1.55 : 1.05,
                    ),
                    itemCount: goalProgressList.length,
                    itemBuilder: (context, index) {
                      final goalProgress = goalProgressList[index];
                      return _GoalCard(goalProgress: goalProgress);
                    },
                  );
                },
              );
            },
            loading: () => LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 720
                    ? 3
                    : constraints.maxWidth >= 430
                    ? 2
                    : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: crossAxisCount == 1 ? 1.55 : 1.05,
                  ),
                  itemCount: crossAxisCount == 1 ? 2 : 4,
                  itemBuilder: (context, index) => const _ShimmerGoalCard(),
                );
              },
            ),
            error: (err, stack) => _GoalsErrorState(error: err.toString()),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final GoalProgress goalProgress;

  const _GoalCard({required this.goalProgress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = goalProgress.percent;
    final isDone = goalProgress.isCompleted;
    final remaining =
        (goalProgress.goal.targetValue - goalProgress.currentValue).clamp(
          0,
          goalProgress.goal.targetValue,
        );

    IconData getIconData(String iconName) {
      switch (iconName) {
        case 'menu_book':
          return Icons.menu_book_rounded;
        case 'timer':
          return Icons.timer_rounded;
        case 'repeat':
          return Icons.repeat_rounded;
        case 'favorite':
          return Icons.favorite_rounded;
        case 'shield':
          return Icons.shield_rounded;
        case 'self_improvement':
          return Icons.self_improvement_rounded;
        default:
          return Icons.flag_rounded;
      }
    }

    final cardColor = isDone
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
        : theme.colorScheme.secondaryContainer.withValues(alpha: 0.15);

    final borderColor = isDone
        ? theme.colorScheme.primary.withValues(alpha: 0.35)
        : theme.colorScheme.outlineVariant.withValues(alpha: 0.25);

    return AthrGlassCard(
      blur: 16,
      opacity: 0.08,
      color: cardColor,
      border: Border.all(color: borderColor, width: isDone ? 1.4 : 1.0),
      padding: EdgeInsets.zero, // Padding moves to inside InkWell
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/progress'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDone
                            ? theme.colorScheme.primary.withValues(alpha: 0.12)
                            : theme.colorScheme.surfaceContainerHighest.withValues(
                                alpha: 0.5,
                              ),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        boxShadow: isDone
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.18,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        getIconData(goalProgress.goal.icon),
                        color: isDone
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isDone
                            ? theme.colorScheme.primary.withValues(alpha: 0.12)
                            : theme.colorScheme.surface.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(AppRadius.round),
                      ),
                      child: Text(
                        isDone ? 'اكتمل' : '$remaining متبق',
                        style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
                          color: isDone
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalProgress.goal.title,
                      style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                        color: isDone
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _getMotivationalMessage(),
                      style: AppTypography.cairoTextTheme().bodySmall?.copyWith(
                        color: isDone
                            ? theme.colorScheme.primary.withValues(alpha: 0.84)
                            : theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatPercent(percent),
                          style: AppTypography.cairoTextTheme().labelLarge
                              ?.copyWith(
                                color: isDone
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${goalProgress.currentValue} من ${goalProgress.goal.targetValue}',
                          style: AppTypography.cairoTextTheme().labelMedium
                              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: percent),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 8,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDone
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMotivationalMessage() {
    if (goalProgress.isCompleted) return 'رائع! لقد أنجزت الهدف.';
    final remaining = goalProgress.goal.targetValue - goalProgress.currentValue;
    if (goalProgress.percent >= 0.8) return 'اقتربت جداً، تبقى $remaining فقط!';
    if (goalProgress.percent >= 0.5) return 'لقد قطعت نصف الطريق.';
    if (goalProgress.currentValue > 0) return 'بداية جيدة، واصل!';
    return 'ابدأ الآن.';
  }
}

class _ShimmerGoalCard extends StatelessWidget {
  const _ShimmerGoalCard();

  @override
  Widget build(BuildContext context) {
    return AthrGlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 92,
                height: 16,
                color: Colors.grey.withValues(alpha: 0.16),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 132,
                height: 12,
                color: Colors.grey.withValues(alpha: 0.12),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 8,
            color: Colors.grey.withValues(alpha: 0.18),
          ),
        ],
      ),
    );
  }
}

class _GoalsEmptyState extends StatelessWidget {
  const _GoalsEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AthrGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.flag_outlined, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لا توجد أهداف محددة بعد',
                  style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'أضف هدفاً بسيطاً لتبدأ متابعة أثر يومك بشكل أوضح.',
                  style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsErrorState extends StatelessWidget {
  final String error;

  const _GoalsErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AthrGlassCard(
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.15),
      border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: theme.colorScheme.error),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'تعذر تحميل الأهداف الآن. $error',
              style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCountPill extends StatelessWidget {
  final int totalGoals;
  final int completedGoals;

  const _SectionCountPill({
    required this.totalGoals,
    required this.completedGoals,
  });

  @override
  Widget build(BuildContext context) {
    if (totalGoals == 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.65,
        ),
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Text(
        '$completedGoals / $totalGoals مكتمل',
        style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _GoalsSummaryStrip extends StatelessWidget {
  final GoalSummary summary;

  const _GoalsSummaryStrip({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AthrGlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أنجزت ${summary.completedGoals} من ${summary.totalGoals} أهداف',
                style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatPercent(summary.averagePercent),
                style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: summary.averagePercent),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPercent(double value) {
  return '${(value * 100).round()}%';
}

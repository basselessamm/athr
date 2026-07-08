import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/features/progress/providers/goal_engine_provider.dart';

class TodayGoalsSection extends ConsumerWidget {
  const TodayGoalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalEngineProvider);

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
              goalsAsync.maybeWhen(
                data: (goalProgressList) =>
                    _SectionCountPill(count: goalProgressList.length),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
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
                      childAspectRatio: crossAxisCount == 1 ? 1.85 : 1.12,
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
                    childAspectRatio: crossAxisCount == 1 ? 1.85 : 1.12,
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
        case 'self_improvement':
          return Icons.self_improvement_rounded;
        default:
          return Icons.flag_rounded;
      }
    }

    return InkWell(
      onTap: () => context.push('/progress'),
      borderRadius: AppRadius.card,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              isDone
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.95)
                  : theme.colorScheme.surface,
              isDone
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.58)
                  : theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.minimal,
          border: Border.all(
            color: isDone
                ? theme.colorScheme.primary.withValues(alpha: 0.4)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            width: isDone ? 1.4 : 1,
          ),
        ),
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
                            alpha: 0.7,
                          ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
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
                        : theme.colorScheme.surface.withValues(alpha: 0.85),
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
                      '${(percent * 100).toInt()}%',
                      style: AppTypography.cairoTextTheme().labelLarge
                          ?.copyWith(
                            color: isDone
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${goalProgress.currentValue} / ${goalProgress.goal.targetValue}',
                      style: AppTypography.cairoTextTheme().labelMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDone
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
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
  final int count;

  const _SectionCountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
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
        '$count أهداف',
        style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/challenges/providers/challenges_providers.dart';

class ChallengesListScreen extends ConsumerWidget {
  const ChallengesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final challenges = ref.watch(challengesProvider);

    return AthrScaffold(
      title: 'التحديات والإنجازات',
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
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: challenges.length + 1, // +1 for header
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                child: Column(
                  children: [
                    Text(
                      'تحدى نفسك وارتقِ',
                      style: AppTypography.cairoTextTheme().headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'أكمل التحديات اليومية والأسبوعية لتحقيق أهدافك',
                      style: AppTypography.cairoTextTheme().bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            final challenge = challenges[index - 1];
            return _ChallengeCard(challenge: challenge);
          },
        ),
      ),
    );
  }
}

class _ChallengeCard extends ConsumerWidget {
  final Challenge challenge;

  const _ChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    String typeLabel;
    IconData typeIcon;
    Color typeColor;

    switch (challenge.type) {
      case ChallengeType.daily:
        typeLabel = 'تحدي يومي';
        typeIcon = Icons.local_fire_department_rounded;
        typeColor = const Color(0xFFD97736); // Orange
        break;
      case ChallengeType.weekly:
        typeLabel = 'تحدي أسبوعي';
        typeIcon = Icons.emoji_events_rounded;
        typeColor = const Color(0xFF3E6B5B); // Blue/Green
        break;
      case ChallengeType.monthly:
        typeLabel = 'تحدي شهري';
        typeIcon = Icons.diamond_rounded;
        typeColor = const Color(0xFF6B3E6A); // Purple
        break;
    }

    if (challenge.isCompleted) {
      typeColor = theme.colorScheme.outlineVariant;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: challenge.isCompleted
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: challenge.isCompleted
              ? theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
              : typeColor.withValues(alpha: 0.3),
          width: challenge.isCompleted ? 1 : 2,
        ),
        boxShadow: challenge.isCompleted ? AppShadows.minimal : AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(challengesProvider.notifier).toggleChallenge(challenge.id);
          },
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Icon Badge
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: challenge.isCompleted
                        ? theme.colorScheme.surfaceContainerHighest
                        : typeColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: challenge.isCompleted
                          ? theme.colorScheme.outlineVariant
                          : typeColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    challenge.isCompleted ? Icons.check_rounded : typeIcon,
                    size: 32,
                    color: challenge.isCompleted
                        ? theme.colorScheme.onSurfaceVariant
                        : typeColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Challenge Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: challenge.isCompleted
                              ? theme.colorScheme.surface
                              : typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                        child: Text(
                          challenge.isCompleted ? 'مكتمل' : typeLabel,
                          style: AppTypography.cairoTextTheme().labelSmall
                              ?.copyWith(
                                color: challenge.isCompleted
                                    ? theme.colorScheme.onSurfaceVariant
                                    : typeColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        challenge.title,
                        style: AppTypography.cairoTextTheme().titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: challenge.isCompleted
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                              decoration: challenge.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge.description,
                        style: AppTypography.cairoTextTheme().bodySmall
                            ?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

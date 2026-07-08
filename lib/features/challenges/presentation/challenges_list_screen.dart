import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/features/challenges/providers/challenges_providers.dart';

class ChallengesListScreen extends ConsumerWidget {
  const ChallengesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);

    return AthrScaffold(
      title: 'التحديات',
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return _ChallengeCard(challenge: challenge);
        },
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
        typeLabel = 'يومي';
        typeIcon = Icons.today;
        typeColor = Colors.orange;
        break;
      case ChallengeType.weekly:
        typeLabel = 'أسبوعي';
        typeIcon = Icons.date_range;
        typeColor = Colors.blue;
        break;
      case ChallengeType.monthly:
        typeLabel = 'شهري';
        typeIcon = Icons.calendar_month;
        typeColor = Colors.purple;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: challenge.isCompleted
              ? theme.colorScheme.primary.withValues(alpha: 0.5)
              : theme.colorScheme.surfaceContainerHighest,
          width: challenge.isCompleted ? 2 : 1,
        ),
      ),
      elevation: 0,
      color: challenge.isCompleted
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
          : theme.colorScheme.surface,
      child: InkWell(
        onTap: () {
          ref.read(challengesProvider.notifier).toggleChallenge(challenge.id);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Checkbox / Status Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: challenge.isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  challenge.isCompleted ? Icons.check : Icons.star_border,
                  color: challenge.isCompleted
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(typeIcon, size: 16, color: typeColor),
                        const SizedBox(width: 4),
                        Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: typeColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: challenge.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: challenge.isCompleted
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        fontSize: 13,
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
    );
  }
}

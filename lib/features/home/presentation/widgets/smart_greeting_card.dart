import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/features/home/providers/dashboard_context_provider.dart';

class SmartGreetingCard extends ConsumerWidget {
  const SmartGreetingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardContext = ref.watch(dashboardContextProvider);

    // Determine icon based on time for fallback if not part of engine yet
    final hour = DateTime.now().hour;
    IconData icon = Icons.wb_sunny_rounded;
    if (hour >= 15 && hour < 18) icon = Icons.wb_twilight;
    if (hour >= 18 || hour < 4) icon = Icons.nights_stay;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(
          AppSpacing.lg,
        ), // 24 is roughly AppSpacing.lg
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: AppSpacing.xl,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboardContext.greeting,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  dashboardContext.headline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
                if (dashboardContext.subGreeting != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    dashboardContext.subGreeting!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

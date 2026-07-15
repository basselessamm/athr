import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/features/prayer/domain/prayer_formatters.dart';
import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/domain/prayer_schedule.dart';
import 'package:athr/features/prayer/providers/prayer_providers.dart';

class PrayerLiveStatus extends ConsumerWidget {
  final PrayerSchedule schedule;
  final PrayerTimeFormat timeFormat;

  const PrayerLiveStatus({
    super.key,
    required this.schedule,
    required this.timeFormat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = ref.watch(prayerSecondTickerProvider).valueOrNull ?? DateTime.now();
    final snapshot = ref
        .read(prayerRepositoryProvider)
        .resolveStatus(schedule: schedule, now: now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.headline,
            style: AppTypography.cairoTextTheme().titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            snapshot.supportingText,
            style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'العد التنازلي',
                  value: PrayerFormatters.formatCountdown(snapshot.remaining),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricTile(
                  label: 'موعد ${snapshot.nextPrayer.label}',
                  value: PrayerFormatters.formatTime(
                    snapshot.targetTime,
                    timeFormat,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

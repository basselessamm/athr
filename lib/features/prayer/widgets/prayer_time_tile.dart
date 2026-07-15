import 'package:flutter/material.dart';

import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/features/prayer/domain/prayer_entry.dart';
import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/domain/prayer_formatters.dart';

class PrayerTimeTile extends StatelessWidget {
  final PrayerEntry entry;
  final PrayerTimeFormat timeFormat;
  final bool isActive;

  const PrayerTimeTile({
    super.key,
    required this.entry,
    required this.timeFormat,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = entry.isObligatory
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isActive
              ? Colors.transparent
              : accentColor.withValues(alpha: 0.12),
          width: isActive ? 0.0 : 1.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            entry.type.label,
            style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
              color: isActive ? theme.colorScheme.onPrimary : accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            PrayerFormatters.formatTime(entry.time, timeFormat),
            style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
              color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

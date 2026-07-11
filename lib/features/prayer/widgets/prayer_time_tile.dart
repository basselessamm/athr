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

  const PrayerTimeTile({
    super.key,
    required this.entry,
    required this.timeFormat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = entry.isObligatory
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 92, maxWidth: 132),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: accentColor.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.type.label,
              style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              PrayerFormatters.formatTime(entry.time, timeFormat),
              style: AppTypography.cairoTextTheme().titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

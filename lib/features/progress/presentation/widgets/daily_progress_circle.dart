import 'package:flutter/material.dart';
import 'package:athr/core/database/app_database.dart';
import 'dart:math' as math;

class DailyProgressCircle extends StatelessWidget {
  final ProgressRecord? record;

  const DailyProgressCircle({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    // Determine progress goals (could be configurable in the future)
    const goalMinutes = 30;
    const goalPages = 10;
    const goalAzkar = 50;

    final minutes = record != null ? record!.readingSeconds ~/ 60 : 0;
    final pages = record != null ? record!.pagesRead : 0;
    final azkar = record != null ? record!.azkarCount : 0;
    final hadiths = record != null ? record!.hadithCount : 0;

    double progress = 0;
    progress += math.min(1.0, minutes / goalMinutes) * 0.4; // 40% for time
    progress += math.min(1.0, pages / goalPages) * 0.3; // 30% for pages
    progress += math.min(1.0, azkar / goalAzkar) * 0.3; // 30% for azkar

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'إنجاز اليوم',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: progress == 0
                        ? null
                        : progress, // null makes it indeterminate or empty if we prefer
                    strokeWidth: 12,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    color: Theme.of(context).colorScheme.primary,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                if (progress == 0)
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: CircularProgressIndicator(
                      value: 0.0,
                      strokeWidth: 12,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      'مكتمل',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.timer_outlined,
                value: '$minutes',
                label: 'دقيقة',
                context: context,
              ),
              _StatItem(
                icon: Icons.menu_book_outlined,
                value: '$pages',
                label: 'صفحة',
                context: context,
              ),
              _StatItem(
                icon: Icons.wb_twilight_outlined,
                value: '$azkar',
                label: 'ذكر',
                context: context,
              ),
              _StatItem(
                icon: Icons.library_books_outlined,
                value: '$hadiths',
                label: 'حديث',
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final BuildContext context;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

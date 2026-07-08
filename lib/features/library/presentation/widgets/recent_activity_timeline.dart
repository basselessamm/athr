import 'package:flutter/material.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_shadows.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:intl/intl.dart';

class RecentActivityTimeline extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'لا يوجد نشاط مسجل حتى الآن',
                style: AppTypography.cairoTextTheme().titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isLast = index == activities.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline connector
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(
                        top: 24,
                      ), // Center with the card content
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getTypeColor(context, activity.type),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getTypeColor(
                              context,
                              activity.type,
                            ).withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Theme.of(
                            context,
                          ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Activity Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.2),
                      ),
                      boxShadow: AppShadows.minimal,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getTypeColor(
                              context,
                              activity.type,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Icon(
                            _getTypeIcon(activity.type),
                            size: 20,
                            color: _getTypeColor(context, activity.type),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getTypeLabel(activity.type),
                                    style: AppTypography.cairoTextTheme()
                                        .labelMedium
                                        ?.copyWith(
                                          color: _getTypeColor(
                                            context,
                                            activity.type,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'hh:mm a',
                                    ).format(activity.timestamp),
                                    style: AppTypography.cairoTextTheme()
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                activity.title,
                                style: AppTypography.cairoTextTheme().titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                              ),
                              if (activity.subtitle != null &&
                                  activity.subtitle!.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  activity.subtitle!,
                                  style: AppTypography.cairoTextTheme()
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'quran':
        return 'تلاوة القرآن';
      case 'azkar':
        return 'الأذكار';
      case 'hadith':
        return 'الأحاديث';
      case 'muhasaba':
        return 'محاسبة النفس';
      default:
        return 'نشاط عام';
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'quran':
        return Icons.menu_book_rounded;
      case 'azkar':
        return Icons.wb_sunny_outlined;
      case 'hadith':
        return Icons.library_books_rounded;
      case 'muhasaba':
        return Icons.assignment_turned_in_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  Color _getTypeColor(BuildContext context, String type) {
    switch (type) {
      case 'quran':
        return const Color(0xFF3E6B5B);
      case 'azkar':
        return const Color(0xFF8C6D2D);
      case 'hadith':
        return const Color(0xFF7A6242);
      case 'muhasaba':
        return Theme.of(context).colorScheme.primary;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }
}

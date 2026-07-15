import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/widgets/athr_glass_card.dart';
import 'package:athr/features/library/modules/recent_activity/providers/recent_activity_providers.dart';

class ContinueReadingCard extends ConsumerWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(recentActivitiesProvider);

    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return const SizedBox.shrink();
        }

        final activity = activities.first;

        IconData icon;
        String headerText;
        Color accentColor;

        switch (activity.type) {
          case 'quran':
            icon = Icons.menu_book_rounded;
            headerText = 'متابعة القراءة';
            accentColor = theme.colorScheme.primary;
            break;
          case 'azkar':
            icon = Icons.wb_twilight_rounded;
            headerText = 'إكمال الأذكار';
            accentColor = const Color(0xFFC7A87D); // Golden
            break;
          case 'hadith':
            icon = Icons.library_books_rounded;
            headerText = 'متابعة الحديث';
            accentColor = const Color(0xFF5B7B6F); // Teal
            break;
          default:
            icon = Icons.history_rounded;
            headerText = 'استئناف';
            accentColor = theme.colorScheme.primary;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: AthrGlassCard(
            blur: 18,
            opacity: 0.10,
            padding: EdgeInsets.zero,
            border: Border.all(
              color: accentColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.push(activity.routePath);
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 16,
                                  color: accentColor,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  headerText,
                                  style: AppTypography.cairoTextTheme().labelMedium?.copyWith(
                                        color: accentColor,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              activity.title,
                              style: AppTypography.readingAmiriBold(
                                fontSize: 26,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            if (activity.subtitle != null)
                              Text(
                                activity.subtitle!,
                                style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.2),
                              blurRadius: 14,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

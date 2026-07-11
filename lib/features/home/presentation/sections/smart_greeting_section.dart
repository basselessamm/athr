import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/theme/app_radius.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/core/widgets/athr_glass_card.dart';

import 'package:athr/features/home/providers/dashboard_context_provider.dart';

class SmartGreetingSection extends ConsumerWidget {
  const SmartGreetingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardContext = ref.watch(dashboardContextProvider);
    final theme = Theme.of(context);
    final greeting = dashboardContext.greeting;
    final subGreeting = dashboardContext.subGreeting;
    final focusLabel = dashboardContext.focusLabel;
    final focusRoute = dashboardContext.focusRoute;
    final hour = DateTime.now().hour;

    // Time-based icon
    final IconData timeIcon;
    final Color iconGlowColor;
    if (hour >= 5 && hour < 12) {
      timeIcon = Icons.wb_sunny_rounded;
      iconGlowColor = const Color(0xFFFFA726);
    } else if (hour >= 12 && hour < 17) {
      timeIcon = Icons.wb_cloudy_rounded;
      iconGlowColor = const Color(0xFF42A5F5);
    } else if (hour >= 17 && hour < 20) {
      timeIcon = Icons.wb_twilight_rounded;
      iconGlowColor = const Color(0xFFEF5350);
    } else {
      timeIcon = Icons.nightlight_round;
      iconGlowColor = const Color(0xFF7E57C2);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: AthrGlassCard(
        blur: 22,
        opacity: 0.08,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Stack(
          children: [
            // ── Decorative circles behind content ──
            Positioned(
              top: -48,
              left: -12,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -64,
              right: -28,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconGlowColor.withValues(alpha: 0.06),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          _ContextPill(
                            icon: Icons.waving_hand_rounded,
                            label: 'السلام عليكم',
                            foregroundColor: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.surface.withValues(
                              alpha: 0.55,
                            ),
                          ),
                          _ContextPill(
                            icon: Icons.calendar_month_rounded,
                            label: _formatHijriDate(dashboardContext),
                            foregroundColor: theme.colorScheme.onSurface,
                            backgroundColor: theme.colorScheme.surface.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // ── Glowing time icon ──
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconGlowColor.withValues(alpha: 0.12),
                        boxShadow: [
                          BoxShadow(
                            color: iconGlowColor.withValues(alpha: 0.25),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        timeIcon,
                        color: iconGlowColor,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '$greeting، مرحباً بعودتك.',
                  style: AppTypography.cairoTextTheme().headlineMedium
                      ?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  dashboardContext.headline,
                  style: AppTypography.cairoTextTheme().bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.75,
                  ),
                ),
                if (subGreeting != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            subGreeting,
                            style: AppTypography.cairoTextTheme().titleSmall
                                ?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (focusLabel != null && focusRoute != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  AthrGlassCard(
                    blur: 12,
                    opacity: 0.06,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.14,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.flag_circle_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                focusLabel,
                                style: AppTypography.cairoTextTheme().titleSmall
                                    ?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (dashboardContext.focusReason != null) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  dashboardContext.focusReason!,
                                  style: AppTypography.cairoTextTheme()
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        FilledButton.tonal(
                          onPressed: () => context.push(focusRoute),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          child: const Text('افتح الآن'),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Text(
                  'رتّب يومك بهدوء، وابدأ بالأثر الأقرب لقلبك الآن.',
                  style: AppTypography.cairoTextTheme().bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContextPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  const _ContextPill({
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(
          color: foregroundColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.cairoTextTheme().labelLarge?.copyWith(
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatHijriDate(DashboardContext context) {
  const months = <int, String>{
    1: 'محرم',
    2: 'صفر',
    3: 'ربيع الأول',
    4: 'ربيع الآخر',
    5: 'جمادى الأولى',
    6: 'جمادى الآخرة',
    7: 'رجب',
    8: 'شعبان',
    9: 'رمضان',
    10: 'شوال',
    11: 'ذو القعدة',
    12: 'ذو الحجة',
  };

  final month = months[context.hijriDate.hMonth] ?? 'شهر هجري';
  return '${context.hijriDate.hDay} $month ${context.hijriDate.hYear}هـ';
}

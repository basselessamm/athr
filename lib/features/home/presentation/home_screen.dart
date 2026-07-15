import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:athr/core/widgets/athr_scaffold.dart';
import 'package:athr/core/widgets/main_navigation_bar.dart';
import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

import 'package:athr/features/home/presentation/sections/smart_greeting_section.dart';
import 'package:athr/features/home/presentation/sections/continue_reading_card.dart';
import 'package:athr/features/home/presentation/sections/today_goals_section.dart';
import 'package:athr/features/home/presentation/sections/quick_actions_grid.dart';
import 'package:athr/features/home/presentation/widgets/daily_goal_progress_card.dart';
import 'package:athr/features/prayer/presentation/sections/prayer_times_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final isDark = theme.brightness == Brightness.dark;
    final reduceMotion = ref.watch(reduceMotionProvider);

    // Dynamic gradient colours based on time of day
    final List<Color> bgColors;
    if (hour >= 5 && hour < 12) {
      // Morning — warm amber tones
      bgColors = isDark
          ? [
              const Color(0xFF2A1C10), // Richer amber/brown
              const Color(0xFF1B221E), // Deep earthy green
              theme.colorScheme.surface,
            ]
          : [
              const Color(0xFFFFF8E1).withValues(alpha: 0.8),
              const Color(0xFFF1F8F6).withValues(alpha: 0.5),
              theme.colorScheme.surface,
            ];
    } else if (hour >= 12 && hour < 17) {
      // Afternoon — neutral light teal
      bgColors = isDark
          ? [
              const Color(0xFF142926), // Deep rich teal
              const Color(0xFF101B1A), // Darker teal
              theme.colorScheme.surface,
            ]
          : [
              const Color(0xFFE0F2F1).withValues(alpha: 0.7),
              const Color(0xFFF1F8F6).withValues(alpha: 0.5),
              theme.colorScheme.surface,
            ];
    } else {
      // Evening & Night — deep emerald / indigo
      bgColors = isDark
          ? [
              const Color(0xFF132D42), // Rich twilight blue
              const Color(0xFF0F1B22), // Deep midnight blue
              theme.colorScheme.surface,
            ]
          : [
              const Color(0xFFE8F5E9).withValues(alpha: 0.7),
              const Color(0xFFE3F2FD).withValues(alpha: 0.5),
              theme.colorScheme.surface,
            ];
    }

    return AthrScaffold(
      title: 'أَثَر',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search'),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
        ),
      ],
      body: Stack(
        children: [
          // ── Dynamic gradient background ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: bgColors,
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),
          ),
          // ── Decorative glowing orbs ──
          if (!reduceMotion) ...[
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: isDark ? 0.28 : 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 220,
              left: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.tertiary.withValues(alpha: isDark ? 0.25 : 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.secondary.withValues(alpha: isDark ? 0.25 : 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
          // ── Main content ──
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.lg,
                    bottom: AppSpacing.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SmartGreetingSection(),
                      const SizedBox(height: AppSpacing.xl),
                      const PrayerTimesSection(),
                      const SizedBox(height: AppSpacing.xl),
                      const ContinueReadingCard(),
                      const SizedBox(height: AppSpacing.xl),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: DailyGoalProgressCard(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const TodayGoalsSection(),
                      const SizedBox(height: AppSpacing.xl),
                      const QuickActionsGrid(),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const MainNavigationBar(selectedIndex: 0),
    );
  }
}


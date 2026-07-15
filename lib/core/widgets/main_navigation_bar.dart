import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/theme/app_typography.dart';
import 'package:athr/core/widgets/athr_glass_card.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const MainNavigationBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navItems = [
      (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'الرئيسية', route: '/'),
      (icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book_rounded, label: 'القرآن', route: '/quran'),
      (icon: Icons.wb_twilight_outlined, activeIcon: Icons.wb_twilight_rounded, label: 'الأذكار', route: '/azkar'),
      (icon: Icons.library_books_outlined, activeIcon: Icons.library_books_rounded, label: 'الحديث', route: '/hadith'),
      (icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'مكتبتي', route: '/library'),
    ];

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      child: AthrGlassCard(
          blur: 24,
          opacity: isDark ? 0.25 : 0.75, // More opaque in light mode for readability
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.1),
            width: 1.5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final isSelected = selectedIndex == index;
              final item = navItems[index];

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (isSelected) return;
                    HapticFeedback.selectionClick();
                    context.go(item.route);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            key: ValueKey(isSelected),
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                            size: isSelected ? 26 : 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTypography.cairoTextTheme().labelSmall!.copyWith(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: isSelected ? 11 : 10,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:midrar/core/theme/app_colors.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const MainNavigationBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppColors.radiusXl),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : const Color(0xFF1C443B).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: NavigationBar(
          height: 68,
          selectedIndex: selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index) {
            if (index == selectedIndex) {
              return;
            }

            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/quran');
                break;
              case 2:
                context.go('/azkar');
                break;
              case 3:
                context.go('/hadith');
                break;
              case 4:
                context.go('/favorites');
                break;
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'القرآن',
            ),
            NavigationDestination(
              icon: Icon(Icons.spa_outlined),
              selectedIcon: Icon(Icons.spa_rounded),
              label: 'الأذكار',
            ),
            NavigationDestination(
              icon: Icon(Icons.import_contacts_outlined),
              selectedIcon: Icon(Icons.import_contacts_rounded),
              label: 'الحديث',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_added_outlined),
              selectedIcon: Icon(Icons.bookmark_added_rounded),
              label: 'المحفوظات',
            ),
          ],
        ),
      ),
    );
  }
}

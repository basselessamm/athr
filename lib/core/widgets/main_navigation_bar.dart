import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const MainNavigationBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: NavigationBar(
        height: 68,
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
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
              context.go('/library');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'القرآن',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_twilight_outlined),
            selectedIcon: Icon(Icons.wb_twilight),
            label: 'الأذكار',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'الحديث',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'مكتبتي',
          ),
        ],
      ),
    );
  }
}

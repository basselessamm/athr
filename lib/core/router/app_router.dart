import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/features/splash/splash_screen.dart';
import 'package:athr/features/home/presentation/home_screen.dart';
import 'package:athr/features/quran/presentation/quran_list_screen.dart';
import 'package:athr/features/quran/presentation/quran_reading_screen.dart';
import 'package:athr/features/azkar/presentation/azkar_categories_screen.dart';
import 'package:athr/features/azkar/presentation/azkar_reading_screen.dart';
import 'package:athr/features/hadith/presentation/hadith_books_screen.dart';
import 'package:athr/features/hadith/presentation/hadith_reading_screen.dart';
import 'package:athr/features/settings/presentation/settings_screen.dart';
import 'package:athr/features/situations/presentation/situations_grid_screen.dart';
import 'package:athr/features/situations/presentation/situations_detail_screen.dart';
import 'package:athr/features/challenges/presentation/challenges_list_screen.dart';
import 'package:athr/features/favorites/presentation/favorites_screen.dart';
import 'package:athr/features/muhasaba/presentation/muhasaba_screen.dart';
import 'package:athr/features/progress/presentation/progress_screen.dart';
import 'package:athr/features/progress/presentation/goal_setting_screen.dart';
import 'package:athr/features/library/presentation/library_screen.dart';
import 'package:athr/features/search/presentation/global_search_screen.dart';
import 'package:athr/core/router/error_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/quran',
        builder: (context, state) => const QuranListScreen(),
      ),
      GoRoute(
        path: '/quran/:surahId',
        builder: (context, state) {
          final surahId =
              int.tryParse(state.pathParameters['surahId'] ?? '1') ?? 1;
          final pageParam = state.uri.queryParameters['page'];
          final ayahParam = state.uri.queryParameters['ayah'];
          final initialPage = pageParam != null
              ? int.tryParse(pageParam)
              : null;
          final highlightAyah = ayahParam != null
              ? int.tryParse(ayahParam)
              : null;
          return QuranReadingScreen(
            surahNumber: surahId,
            initialPage: initialPage,
            highlightAyah: highlightAyah,
          );
        },
      ),
      GoRoute(
        path: '/azkar',
        builder: (context, state) => const AzkarCategoriesScreen(),
      ),
      GoRoute(
        name: 'azkarReading',
        path: '/azkar/:category',
        builder: (context, state) {
          final category = state.pathParameters['category'] ?? '';
          return AzkarReadingScreen(category: category);
        },
      ),
      GoRoute(
        path: '/hadith',
        builder: (context, state) => const HadithBooksScreen(),
      ),
      GoRoute(
        name: 'hadithReading',
        path: '/hadith/:bookName',
        builder: (context, state) {
          final bookName = state.pathParameters['bookName'] ?? '';
          return HadithReadingScreen(bookName: bookName);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/goal_setting',
        builder: (context, state) => const GoalSettingScreen(),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/muhasaba',
        builder: (context, state) => const MuhasabaScreen(),
      ),
      GoRoute(
        path: '/situations',
        builder: (context, state) => const SituationsGridScreen(),
      ),
      GoRoute(
        path: '/situations/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SituationDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/challenges',
        builder: (context, state) => const ChallengesListScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const GlobalSearchScreen(),
      ),
    ],
  );
});

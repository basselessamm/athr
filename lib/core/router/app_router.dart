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
import 'package:athr/features/search/presentation/search_screen.dart';
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
          final surahId = int.parse(state.pathParameters['surahId']!);
          return QuranReadingScreen(surahNumber: surahId);
        },
      ),
      GoRoute(
        path: '/azkar',
        builder: (context, state) => const AzkarCategoriesScreen(),
      ),
      GoRoute(
        path: '/azkar/:category',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          return AzkarReadingScreen(category: category);
        },
      ),
      GoRoute(
        path: '/hadith',
        builder: (context, state) => const HadithBooksScreen(),
      ),
      GoRoute(
        path: '/hadith/:bookName',
        builder: (context, state) {
          final bookName = state.pathParameters['bookName'] ?? '';
          return HadithReadingScreen(bookName: Uri.decodeComponent(bookName));
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
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
});

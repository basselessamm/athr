import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:midrar/features/splash/splash_screen.dart';
import 'package:midrar/features/home/presentation/home_screen.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';
import 'package:midrar/features/prayer/presentation/prayer_times_screen.dart';
import 'package:midrar/features/quran/presentation/quran_list_screen.dart';
import 'package:midrar/features/quran/presentation/quran_reading_screen.dart';
import 'package:midrar/features/azkar/presentation/azkar_categories_screen.dart';
import 'package:midrar/features/azkar/presentation/azkar_reading_screen.dart';
import 'package:midrar/features/hadith/presentation/hadith_books_screen.dart';
import 'package:midrar/features/hadith/presentation/hadith_chapters_screen.dart';
import 'package:midrar/features/hadith/presentation/hadith_reading_screen.dart';
import 'package:midrar/features/settings/presentation/settings_screen.dart';
import 'package:midrar/features/situations/presentation/situations_grid_screen.dart';
import 'package:midrar/features/situations/presentation/situations_detail_screen.dart';
import 'package:midrar/features/favorites/presentation/favorites_screen.dart';
import 'package:midrar/features/muhasaba/presentation/muhasaba_screen.dart';
import 'package:midrar/features/memory_return/presentation/thread_detail_screen.dart';
import 'package:midrar/features/search/presentation/search_screen.dart';
import 'package:midrar/core/router/error_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Android LaunchTheme covers native process startup. Going directly to Home
    // prevents a second Flutter splash animation from delaying first use.
    initialLocation: '/',
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/prayer',
        builder: (context, state) {
          final requested = state.uri.queryParameters['prayer'];
          PrayerName? highlightedPrayer;
          for (final prayer in PrayerName.values) {
            if (prayer.name == requested) {
              highlightedPrayer = prayer;
              break;
            }
          }
          return PrayerTimesScreen(highlightedPrayer: highlightedPrayer);
        },
      ),
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
          final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
          return QuranReadingScreen(surahNumber: surahId, focusAyah: ayah);
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
          final itemId = int.tryParse(
            state.uri.queryParameters['itemId'] ?? '',
          );
          return AzkarReadingScreen(category: category, focusItemId: itemId);
        },
      ),
      GoRoute(
        path: '/hadith',
        builder: (context, state) => const HadithBooksScreen(),
      ),
      GoRoute(
        name: 'hadithChapters',
        path: '/hadith/:bookName/chapters',
        builder: (context, state) {
          final bookName = state.pathParameters['bookName'] ?? '';
          return HadithChaptersScreen(bookName: bookName);
        },
      ),
      GoRoute(
        name: 'hadithReading',
        path: '/hadith/:bookName',
        builder: (context, state) {
          final bookName = state.pathParameters['bookName'] ?? '';
          final hadithId = int.tryParse(
            state.uri.queryParameters['hadithId'] ?? '',
          );
          final chapter = state.uri.queryParameters['chapter'];
          return HadithReadingScreen(
            bookName: bookName,
            focusHadithId: hadithId,
            initialChapter: chapter,
          );
        },
      ),
      GoRoute(
        path: '/memory/:threadId',
        builder: (context, state) {
          return ThreadDetailScreen(
            threadId: state.pathParameters['threadId']!,
          );
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
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
});

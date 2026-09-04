import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midrar/vendor/quran_core/quran.dart';
import 'package:midrar/core/database/app_database.dart';
import 'package:midrar/core/database/database_providers.dart';
import 'package:midrar/core/utils/arabic_normalization.dart';

class QuranSearchResult {
  final int surah;
  final int ayah;
  final String text;

  QuranSearchResult({
    required this.surah,
    required this.ayah,
    required this.text,
  });
}

class SearchState {
  final String query;
  final bool isLoading;
  final String? error;
  final List<QuranSearchResult> quranResults;
  final List<Hadith> hadithResults;
  final List<Zikr> azkarResults;

  SearchState({
    this.query = '',
    this.isLoading = false,
    this.error,
    this.quranResults = const [],
    this.hadithResults = const [],
    this.azkarResults = const [],
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<QuranSearchResult>? quranResults,
    List<Hadith>? hadithResults,
    List<Zikr>? azkarResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      quranResults: quranResults ?? this.quranResults,
      hadithResults: hadithResults ?? this.hadithResults,
      azkarResults: azkarResults ?? this.azkarResults,
    );
  }
}

class NormalizedQuranVerse {
  final int surah;
  final int ayah;
  final String text;
  final String normalizedText;

  const NormalizedQuranVerse({
    required this.surah,
    required this.ayah,
    required this.text,
    required this.normalizedText,
  });
}

List<NormalizedQuranVerse>? _cachedQuranVerses;

Future<List<NormalizedQuranVerse>> getOrCreateQuranVerseCache() async {
  final existing = _cachedQuranVerses;
  if (existing != null) return existing;

  await Quran.initialize();

  final verses = <NormalizedQuranVerse>[];
  for (int surah = 1; surah <= 114; surah++) {
    final count = Quran.getTotalVersesInSurah(surah);
    for (int ayah = 1; ayah <= count; ayah++) {
      final verse = Quran.getVerse(surahNumber: surah, verseNumber: ayah);
      verses.add(
        NormalizedQuranVerse(
          surah: surah,
          ayah: ayah,
          text: verse.text,
          normalizedText: normalizeArabic(verse.text),
        ),
      );
    }
  }
  _cachedQuranVerses = verses;
  return verses;
}

void clearQuranVerseCacheForTest() {
  _cachedQuranVerses = null;
}

class SearchNotifier extends StateNotifier<SearchState> {
  final AppDatabase db;
  Timer? _debounce;
  int _generation = 0;

  SearchNotifier(this.db) : super(SearchState());

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void updateQuery(String newQuery) {
    state = state.copyWith(query: newQuery);

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (newQuery.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        quranResults: [],
        hadithResults: [],
        azkarResults: [],
      );
      return;
    }

    state = state.copyWith(isLoading: true);
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(newQuery.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    final generation = ++_generation;
    try {
      // 1. Search Database (Hadith & Azkar) — normalization happens inside
      // the data layer against precomputed normalized columns.
      final hadithResults = await db.searchHadith(query);
      final azkarResults = await db.searchAzkar(query);

      // 2. Search Quran using the in-memory pre-normalized verses cache.
      // Eliminates calling normalizeArabic() 6,236 times per keystroke.
      final normalizedQuery = normalizeArabic(query);
      final quranResults = <QuranSearchResult>[];
      if (normalizedQuery.isNotEmpty) {
        final allVerses = await getOrCreateQuranVerseCache();
        for (final verse in allVerses) {
          if (verse.normalizedText.contains(normalizedQuery)) {
            quranResults.add(
              QuranSearchResult(
                surah: verse.surah,
                ayah: verse.ayah,
                text: verse.text,
              ),
            );
            if (quranResults.length >= 100) {
              break; // Limit to 100 to avoid UI freeze on common words
            }
          }
        }
      }

      // Discard stale responses when a newer query superseded this one.
      if (generation != _generation) return;

      state = state.copyWith(
        isLoading: false,
        hadithResults: hadithResults,
        azkarResults: azkarResults,
        quranResults: quranResults,
      );
    } catch (e) {
      if (_generation == generation) {
        // Surface a visible error instead of silently showing empty state.
        state = state.copyWith(
          isLoading: false,
          error: 'تعذر البحث الآن. حاول مرة أخرى.',
        );
      }
    }
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return SearchNotifier(db);
});

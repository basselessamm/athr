import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_flutter/quran.dart';
import 'package:athr/core/database/app_database.dart';
import 'package:athr/core/database/database_providers.dart';

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
  final List<QuranSearchResult> quranResults;
  final List<Hadith> hadithResults;
  final List<Dua> azkarResults;

  SearchState({
    this.query = '',
    this.isLoading = false,
    this.quranResults = const [],
    this.hadithResults = const [],
    this.azkarResults = const [],
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    List<QuranSearchResult>? quranResults,
    List<Hadith>? hadithResults,
    List<Dua>? azkarResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      quranResults: quranResults ?? this.quranResults,
      hadithResults: hadithResults ?? this.hadithResults,
      azkarResults: azkarResults ?? this.azkarResults,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final AppDatabase db;
  Timer? _debounce;

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

  String _normalizeArabic(String text) {
    var normalized = text.replaceAll(
      RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670]'),
      '',
    );
    normalized = normalized.replaceAll(RegExp(r'[إأآاٱ]'), 'ا');
    normalized = normalized.replaceAll('ة', 'ه');
    normalized = normalized.replaceAll('ى', 'ي');
    normalized = normalized.replaceAll('ؤ', 'و');
    normalized = normalized.replaceAll('ئ', 'ي');
    return normalized;
  }

  Future<void> _performSearch(String query) async {
    try {
      final normalizedQuery = _normalizeArabic(query);

      // 1. Search Database (Hadith & Azkar)
      // Note: SQLite LIKE doesn't ignore diacritics natively, but we pass the original query
      // as well to match exact words if they exist in DB.
      final hadithResults = await db.searchHadith(query);
      final azkarResults = await db.searchAzkar(query);

      // 2. Search Quran in memory
      final quranResults = <QuranSearchResult>[];
      for (int surah = 1; surah <= 114; surah++) {
        final count = Quran.getTotalVersesInSurah(surah);
        for (int ayah = 1; ayah <= count; ayah++) {
          final verse = Quran.getVerse(surahNumber: surah, verseNumber: ayah);
          final normalizedVerse = _normalizeArabic(verse.text);
          if (normalizedVerse.contains(normalizedQuery)) {
            quranResults.add(
              QuranSearchResult(surah: surah, ayah: ayah, text: verse.text),
            );
            if (quranResults.length >= 100)
              break; // Limit to 100 to avoid UI freeze on common words
          }
        }
        if (quranResults.length >= 100) break;
      }

      state = state.copyWith(
        isLoading: false,
        hadithResults: hadithResults,
        azkarResults: azkarResults,
        quranResults: quranResults,
      );
    } catch (e) {
      // Return empty results on error
      state = state.copyWith(
        isLoading: false,
        quranResults: [],
        hadithResults: [],
        azkarResults: [],
      );
    }
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return SearchNotifier(db);
});

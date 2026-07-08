import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

class QuranBookmark {
  final int surah;
  final double scrollOffset;

  const QuranBookmark({required this.surah, required this.scrollOffset});
}

class BookmarkNotifier extends StateNotifier<QuranBookmark?> {
  final SharedPreferences _prefs;
  static const _surahKey = 'quran_bookmark_surah';
  static const _offsetKey = 'quran_bookmark_offset';

  BookmarkNotifier(this._prefs) : super(null) {
    _loadBookmark();
  }

  void _loadBookmark() {
    final surah = _prefs.getInt(_surahKey);
    final offset = _prefs.getDouble(_offsetKey);

    if (surah != null) {
      state = QuranBookmark(surah: surah, scrollOffset: offset ?? 0.0);
    }
  }

  Future<void> saveBookmark(int surah, double offset) async {
    await _prefs.setInt(_surahKey, surah);
    await _prefs.setDouble(_offsetKey, offset);
    state = QuranBookmark(surah: surah, scrollOffset: offset);
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, QuranBookmark?>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return BookmarkNotifier(prefs);
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athr/features/settings/providers/settings_providers.dart';

/// A persisted, reopenable Quran reading anchor.
///
/// Earlier releases stored only a surah and an unused scroll offset. The
/// fallback below preserves that bookmark as ayah 1 rather than dropping it.
class QuranBookmark {
  const QuranBookmark({
    required this.surah,
    required this.ayah,
    this.pageNumber,
  });

  final int surah;
  final int ayah;
  final int? pageNumber;
}

class BookmarkNotifier extends StateNotifier<QuranBookmark?> {
  BookmarkNotifier(this._prefs) : super(null) {
    _loadBookmark();
  }

  final SharedPreferences _prefs;

  static const _surahKey = 'quran_bookmark_surah';
  static const _ayahKey = 'quran_bookmark_ayah';
  static const _pageKey = 'quran_bookmark_page';

  void _loadBookmark() {
    final surah = _prefs.getInt(_surahKey);
    if (surah == null) return;

    // Safe legacy fallback: historical records had a surah only.
    final ayah = _prefs.getInt(_ayahKey) ?? 1;
    final pageNumber = _prefs.getInt(_pageKey);
    state = QuranBookmark(surah: surah, ayah: ayah, pageNumber: pageNumber);
  }

  Future<void> saveBookmark({
    required int surah,
    required int ayah,
    int? pageNumber,
  }) async {
    await Future.wait([
      _prefs.setInt(_surahKey, surah),
      _prefs.setInt(_ayahKey, ayah),
      if (pageNumber != null) _prefs.setInt(_pageKey, pageNumber),
    ]);

    state = QuranBookmark(surah: surah, ayah: ayah, pageNumber: pageNumber);
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, QuranBookmark?>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return BookmarkNotifier(prefs);
    });

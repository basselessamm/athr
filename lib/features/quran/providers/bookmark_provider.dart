import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:midrar/features/settings/providers/settings_providers.dart';

/// A persisted Quran position: either an explicit user bookmark or an
/// automatic last-read anchor.
///
/// These are two INDEPENDENT concepts with separate storage. Automatic
/// progress must never overwrite a deliberate bookmark — browsing the mushaf
/// silently updates [lastRead], while only explicit actions update
/// [bookmark].
class QuranPosition {
  const QuranPosition({
    required this.surah,
    required this.ayah,
    this.pageNumber,
    required this.updatedAt,
  });

  final int surah;
  final int ayah;
  final int? pageNumber;
  final DateTime updatedAt;
}

class _PositionStore {
  _PositionStore(this._prefs);

  final SharedPreferences _prefs;

  static const _surahKey = 'quran_bookmark_surah';
  static const _ayahKey = 'quran_bookmark_ayah';
  static const _pageKey = 'quran_bookmark_page';

  static const _lastSurahKey = 'quran_last_read_surah';
  static const _lastAyahKey = 'quran_last_read_ayah';
  static const _lastPageKey = 'quran_last_read_page';
  static const _lastAtKey = 'quran_last_read_at';

  /// Legacy fallback: before last-read existed, the bookmark key doubled as
  /// reading position, so seed last-read from it once.
  QuranPosition? loadLastRead() {
    var surah = _prefs.getInt(_lastSurahKey);
    if (surah == null) {
      surah = _prefs.getInt(_surahKey);
      if (surah == null) return null;
      return QuranPosition(
        surah: surah,
        ayah: _prefs.getInt(_ayahKey) ?? 1,
        pageNumber: _prefs.getInt(_pageKey),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );
    }
    return QuranPosition(
      surah: surah,
      ayah: _prefs.getInt(_lastAyahKey) ?? 1,
      pageNumber: _prefs.getInt(_lastPageKey),
      updatedAt:
          DateTime.tryParse(_prefs.getString(_lastAtKey) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Future<void> saveLastRead(QuranPosition position) async {
    await Future.wait([
      _prefs.setInt(_lastSurahKey, position.surah),
      _prefs.setInt(_lastAyahKey, position.ayah),
      if (position.pageNumber != null)
        _prefs.setInt(_lastPageKey, position.pageNumber!),
      _prefs.setString(_lastAtKey, position.updatedAt.toIso8601String()),
    ]);
  }

  QuranPosition? loadBookmark() {
    final surah = _prefs.getInt(_surahKey);
    if (surah == null) return null;
    return QuranPosition(
      surah: surah,
      ayah: _prefs.getInt(_ayahKey) ?? 1,
      pageNumber: _prefs.getInt(_pageKey),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Future<void> saveBookmark(QuranPosition position) async {
    await Future.wait([
      _prefs.setInt(_surahKey, position.surah),
      _prefs.setInt(_ayahKey, position.ayah),
      if (position.pageNumber != null)
        _prefs.setInt(_pageKey, position.pageNumber!),
    ]);
  }
}

/// Explicit user bookmark ("علّمة هذا الموضع"). Only updated by deliberate
/// user actions.
class BookmarkNotifier extends StateNotifier<QuranPosition?> {
  BookmarkNotifier(SharedPreferences prefs)
      : _store = _PositionStore(prefs),
        super(null) {
    state = _store.loadBookmark();
  }

  final _PositionStore _store;

  Future<void> saveBookmark({
    required int surah,
    required int ayah,
    int? pageNumber,
  }) async {
    final position = QuranPosition(
      surah: surah,
      ayah: ayah,
      pageNumber: pageNumber,
      updatedAt: DateTime.now(),
    );
    await _store.saveBookmark(position);
    state = position;
  }
}

/// Automatic reading progress. Written on every page change; never touches
/// the explicit bookmark.
class LastReadNotifier extends StateNotifier<QuranPosition?> {
  LastReadNotifier(SharedPreferences prefs)
      : _store = _PositionStore(prefs),
        super(null) {
    state = _store.loadLastRead();
  }

  final _PositionStore _store;

  Future<void> recordProgress({
    required int surah,
    required int ayah,
    int? pageNumber,
  }) async {
    final position = QuranPosition(
      surah: surah,
      ayah: ayah,
      pageNumber: pageNumber,
      updatedAt: DateTime.now(),
    );
    state = position;
    await _store.saveLastRead(position);
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, QuranPosition?>((ref) {
      return BookmarkNotifier(ref.watch(sharedPreferencesProvider));
    });

final lastReadProvider =
    StateNotifierProvider<LastReadNotifier, QuranPosition?>((ref) {
      return LastReadNotifier(ref.watch(sharedPreferencesProvider));
    });

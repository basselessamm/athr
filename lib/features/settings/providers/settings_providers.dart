import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  );
});

// Font Size Providers
class BaseFontSizeNotifier extends StateNotifier<double> {
  final SharedPreferences _prefs;
  final String _key;

  BaseFontSizeNotifier(this._prefs, this._key, double defaultSize)
    : super(_prefs.getDouble(_key) ?? defaultSize);

  void setFontSize(double size) {
    state = size;
    _prefs.setDouble(_key, size);
  }
}

final quranFontSizeProvider =
    StateNotifierProvider<BaseFontSizeNotifier, double>((ref) {
      return BaseFontSizeNotifier(
        ref.watch(sharedPreferencesProvider),
        'quran_font_size',
        28.0,
      );
    });

final hadithFontSizeProvider =
    StateNotifierProvider<BaseFontSizeNotifier, double>((ref) {
      return BaseFontSizeNotifier(
        ref.watch(sharedPreferencesProvider),
        'hadith_font_size',
        22.0,
      );
    });

final azkarFontSizeProvider =
    StateNotifierProvider<BaseFontSizeNotifier, double>((ref) {
      return BaseFontSizeNotifier(
        ref.watch(sharedPreferencesProvider),
        'azkar_font_size',
        20.0,
      );
    });

// Reading Mode Enum
enum ReadingMode { light, dark }

// Reading Mode Provider
class ReadingModeNotifier extends StateNotifier<ReadingMode> {
  final SharedPreferences _prefs;
  static const _key = 'reading_mode_v2';

  ReadingModeNotifier(this._prefs) : super(_loadMode(_prefs));

  static ReadingMode _loadMode(SharedPreferences prefs) {
    final modeStr = prefs.getString(_key);
    return ReadingMode.values.firstWhere(
      (m) => m.name == modeStr,
      orElse: () => ReadingMode.dark, // Default to dark mode
    );
  }

  void setMode(ReadingMode mode) {
    state = mode;
    _prefs.setString(_key, mode.name);
  }
}

final readingModeProvider =
    StateNotifierProvider<ReadingModeNotifier, ReadingMode>((ref) {
      return ReadingModeNotifier(ref.watch(sharedPreferencesProvider));
    });

// Reduce Motion Provider
class ReduceMotionNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'reduce_motion';

  ReduceMotionNotifier(this._prefs) : super(_prefs.getBool(_key) ?? false);

  void setMotion(bool reduce) {
    state = reduce;
    _prefs.setBool(_key, reduce);
  }
}

final reduceMotionProvider = StateNotifierProvider<ReduceMotionNotifier, bool>((
  ref,
) {
  return ReduceMotionNotifier(ref.watch(sharedPreferencesProvider));
});

// Notifications Enabled StateNotifier
class NotificationsEnabledNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'notifications_enabled';

  NotificationsEnabledNotifier(this._prefs)
    : super(_prefs.getBool(_key) ?? false);

  void setEnabled(bool enabled) {
    state = enabled;
    _prefs.setBool(_key, enabled);
  }
}

final notificationsEnabledProvider =
    StateNotifierProvider<NotificationsEnabledNotifier, bool>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return NotificationsEnabledNotifier(prefs);
    });

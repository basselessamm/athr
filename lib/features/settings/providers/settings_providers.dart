import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  );
});

// Font Size StateNotifier
class FontSizeNotifier extends StateNotifier<double> {
  final SharedPreferences _prefs;
  static const _key = 'quran_font_size';

  FontSizeNotifier(this._prefs) : super(_prefs.getDouble(_key) ?? 24.0);

  void setFontSize(double size) {
    state = size;
    _prefs.setDouble(_key, size);
  }
}

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FontSizeNotifier(prefs);
});

// Theme Mode StateNotifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _key = 'theme_mode';

  ThemeModeNotifier(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final modeStr = prefs.getString(_key);
    switch (modeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _prefs.setString(_key, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
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

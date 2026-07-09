import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athr/core/notifications/notification_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart'; // To get sharedPreferencesProvider

class SettingsState {
  final bool morningAzkarEnabled;
  final TimeOfDay morningAzkarTime;
  
  final bool eveningAzkarEnabled;
  final TimeOfDay eveningAzkarTime;
  
  final bool quranRemindersEnabled;
  
  final bool athrMessageEnabled;

  const SettingsState({
    required this.morningAzkarEnabled,
    required this.morningAzkarTime,
    required this.eveningAzkarEnabled,
    required this.eveningAzkarTime,
    required this.quranRemindersEnabled,
    required this.athrMessageEnabled,
  });

  SettingsState copyWith({
    bool? morningAzkarEnabled,
    TimeOfDay? morningAzkarTime,
    bool? eveningAzkarEnabled,
    TimeOfDay? eveningAzkarTime,
    bool? quranRemindersEnabled,
    bool? athrMessageEnabled,
  }) {
    return SettingsState(
      morningAzkarEnabled: morningAzkarEnabled ?? this.morningAzkarEnabled,
      morningAzkarTime: morningAzkarTime ?? this.morningAzkarTime,
      eveningAzkarEnabled: eveningAzkarEnabled ?? this.eveningAzkarEnabled,
      eveningAzkarTime: eveningAzkarTime ?? this.eveningAzkarTime,
      quranRemindersEnabled: quranRemindersEnabled ?? this.quranRemindersEnabled,
      athrMessageEnabled: athrMessageEnabled ?? this.athrMessageEnabled,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    
    return SettingsState(
      morningAzkarEnabled: _prefs.getBool('morningAzkarEnabled') ?? true,
      morningAzkarTime: _loadTime('morningAzkarTime', const TimeOfDay(hour: 7, minute: 0)),
      
      eveningAzkarEnabled: _prefs.getBool('eveningAzkarEnabled') ?? true,
      eveningAzkarTime: _loadTime('eveningAzkarTime', const TimeOfDay(hour: 20, minute: 0)), // 8 PM
      
      quranRemindersEnabled: _prefs.getBool('quranRemindersEnabled') ?? true,
      athrMessageEnabled: _prefs.getBool('athrMessageEnabled') ?? true,
    );
  }

  TimeOfDay _loadTime(String key, TimeOfDay defaultTime) {
    final str = _prefs.getString(key);
    if (str != null) {
      final parts = str.split(':');
      if (parts.length == 2) {
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
    return defaultTime;
  }

  void _saveTime(String key, TimeOfDay time) {
    _prefs.setString(key, '${time.hour}:${time.minute}');
  }

  void updateMorningAzkar(bool enabled, [TimeOfDay? time]) {
    state = state.copyWith(morningAzkarEnabled: enabled, morningAzkarTime: time);
    _prefs.setBool('morningAzkarEnabled', enabled);
    if (time != null) _saveTime('morningAzkarTime', time);
    rescheduleAll();
  }

  void updateEveningAzkar(bool enabled, [TimeOfDay? time]) {
    state = state.copyWith(eveningAzkarEnabled: enabled, eveningAzkarTime: time);
    _prefs.setBool('eveningAzkarEnabled', enabled);
    if (time != null) _saveTime('eveningAzkarTime', time);
    rescheduleAll();
  }

  void updateQuranReminders(bool enabled) {
    state = state.copyWith(quranRemindersEnabled: enabled);
    _prefs.setBool('quranRemindersEnabled', enabled);
    rescheduleAll();
  }

  void updateAthrMessage(bool enabled) {
    state = state.copyWith(athrMessageEnabled: enabled);
    _prefs.setBool('athrMessageEnabled', enabled);
    rescheduleAll();
  }

  Future<void> rescheduleAll() async {
    final service = ref.read(notificationServiceProvider);
    
    await service.requestPermissions();
    
    await service.scheduleMorningAzkar(state.morningAzkarTime, enabled: state.morningAzkarEnabled);
    await service.scheduleEveningAzkar(state.eveningAzkarTime, enabled: state.eveningAzkarEnabled);
    await service.scheduleQuranReminders(enabled: state.quranRemindersEnabled);
    await service.scheduleAthrMessage(enabled: state.athrMessageEnabled);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

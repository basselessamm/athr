import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:midrar/core/services/notification_service.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';

class AzkarWirdSettings {
  const AzkarWirdSettings({
    this.morningEnabled = true,
    this.morningHour = 7,
    this.morningMinute = 0,
    this.eveningEnabled = true,
    this.eveningHour = 17,
    this.eveningMinute = 0,
    this.sleepEnabled = true,
    this.sleepHour = 22,
    this.sleepMinute = 30,
    this.wirdEnabled = true,
    this.wirdHour = 21,
    this.wirdMinute = 0,
  });

  final bool morningEnabled;
  final int morningHour;
  final int morningMinute;

  final bool eveningEnabled;
  final int eveningHour;
  final int eveningMinute;

  final bool sleepEnabled;
  final int sleepHour;
  final int sleepMinute;

  final bool wirdEnabled;
  final int wirdHour;
  final int wirdMinute;

  AzkarWirdSettings copyWith({
    bool? morningEnabled,
    int? morningHour,
    int? morningMinute,
    bool? eveningEnabled,
    int? eveningHour,
    int? eveningMinute,
    bool? sleepEnabled,
    int? sleepHour,
    int? sleepMinute,
    bool? wirdEnabled,
    int? wirdHour,
    int? wirdMinute,
  }) {
    return AzkarWirdSettings(
      morningEnabled: morningEnabled ?? this.morningEnabled,
      morningHour: morningHour ?? this.morningHour,
      morningMinute: morningMinute ?? this.morningMinute,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      eveningHour: eveningHour ?? this.eveningHour,
      eveningMinute: eveningMinute ?? this.eveningMinute,
      sleepEnabled: sleepEnabled ?? this.sleepEnabled,
      sleepHour: sleepHour ?? this.sleepHour,
      sleepMinute: sleepMinute ?? this.sleepMinute,
      wirdEnabled: wirdEnabled ?? this.wirdEnabled,
      wirdHour: wirdHour ?? this.wirdHour,
      wirdMinute: wirdMinute ?? this.wirdMinute,
    );
  }
}

class AzkarWirdSettingsNotifier extends StateNotifier<AzkarWirdSettings> {
  AzkarWirdSettingsNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static const _morningEnabledKey = 'notif_morning_azkar_enabled';
  static const _morningHourKey = 'notif_morning_azkar_hour';
  static const _morningMinuteKey = 'notif_morning_azkar_minute';

  static const _eveningEnabledKey = 'notif_evening_azkar_enabled';
  static const _eveningHourKey = 'notif_evening_azkar_hour';
  static const _eveningMinuteKey = 'notif_evening_azkar_minute';

  static const _sleepEnabledKey = 'notif_sleep_azkar_enabled';
  static const _sleepHourKey = 'notif_sleep_azkar_hour';
  static const _sleepMinuteKey = 'notif_sleep_azkar_minute';

  static const _wirdEnabledKey = 'notif_quran_wird_enabled';
  static const _wirdHourKey = 'notif_quran_wird_hour';
  static const _wirdMinuteKey = 'notif_quran_wird_minute';

  static AzkarWirdSettings _load(SharedPreferences prefs) {
    return AzkarWirdSettings(
      morningEnabled: prefs.getBool(_morningEnabledKey) ?? true,
      morningHour: prefs.getInt(_morningHourKey) ?? 7,
      morningMinute: prefs.getInt(_morningMinuteKey) ?? 0,
      eveningEnabled: prefs.getBool(_eveningEnabledKey) ?? true,
      eveningHour: prefs.getInt(_eveningHourKey) ?? 17,
      eveningMinute: prefs.getInt(_eveningMinuteKey) ?? 0,
      sleepEnabled: prefs.getBool(_sleepEnabledKey) ?? true,
      sleepHour: prefs.getInt(_sleepHourKey) ?? 22,
      sleepMinute: prefs.getInt(_sleepMinuteKey) ?? 30,
      wirdEnabled: prefs.getBool(_wirdEnabledKey) ?? true,
      wirdHour: prefs.getInt(_wirdHourKey) ?? 21,
      wirdMinute: prefs.getInt(_wirdMinuteKey) ?? 0,
    );
  }

  Future<void> setMorning({bool? enabled, int? hour, int? minute}) async {
    final next = state.copyWith(
      morningEnabled: enabled,
      morningHour: hour,
      morningMinute: minute,
    );
    state = next;
    if (enabled != null) await _prefs.setBool(_morningEnabledKey, enabled);
    if (hour != null) await _prefs.setInt(_morningHourKey, hour);
    if (minute != null) await _prefs.setInt(_morningMinuteKey, minute);
  }

  Future<void> setEvening({bool? enabled, int? hour, int? minute}) async {
    final next = state.copyWith(
      eveningEnabled: enabled,
      eveningHour: hour,
      eveningMinute: minute,
    );
    state = next;
    if (enabled != null) await _prefs.setBool(_eveningEnabledKey, enabled);
    if (hour != null) await _prefs.setInt(_eveningHourKey, hour);
    if (minute != null) await _prefs.setInt(_eveningMinuteKey, minute);
  }

  Future<void> setSleep({bool? enabled, int? hour, int? minute}) async {
    final next = state.copyWith(
      sleepEnabled: enabled,
      sleepHour: hour,
      sleepMinute: minute,
    );
    state = next;
    if (enabled != null) await _prefs.setBool(_sleepEnabledKey, enabled);
    if (hour != null) await _prefs.setInt(_sleepHourKey, hour);
    if (minute != null) await _prefs.setInt(_sleepMinuteKey, minute);
  }

  Future<void> setWird({bool? enabled, int? hour, int? minute}) async {
    final next = state.copyWith(
      wirdEnabled: enabled,
      wirdHour: hour,
      wirdMinute: minute,
    );
    state = next;
    if (enabled != null) await _prefs.setBool(_wirdEnabledKey, enabled);
    if (hour != null) await _prefs.setInt(_wirdHourKey, hour);
    if (minute != null) await _prefs.setInt(_wirdMinuteKey, minute);
  }
}

final azkarWirdSettingsProvider =
    StateNotifierProvider<AzkarWirdSettingsNotifier, AzkarWirdSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AzkarWirdSettingsNotifier(prefs);
});

final azkarWirdMaintenanceProvider = FutureProvider<void>((ref) async {
  final settings = ref.watch(azkarWirdSettingsProvider);
  final notifications = ref.read(notificationServiceProvider);
  try {
    await notifications.scheduleAzkarAndWirdNotifications(settings);
  } catch (error, stackTrace) {
    debugPrint('Azkar and Wird maintenance failed: $error\n$stackTrace');
  }
});

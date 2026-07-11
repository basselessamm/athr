import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athr/features/prayer/data/prayer_calculation_service.dart';
import 'package:athr/features/prayer/data/prayer_location_service.dart';
import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/data/prayer_repository_impl.dart';
import 'package:athr/features/prayer/domain/prayer_location.dart';
import 'package:athr/features/prayer/domain/prayer_notification_plan.dart';
import 'package:athr/features/prayer/domain/prayer_schedule.dart';
import 'package:athr/features/prayer/domain/prayer_settings.dart';
import 'package:athr/features/prayer/repositories/prayer_repository.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

final prayerLocationServiceProvider = Provider<PrayerLocationService>((ref) {
  return const PrayerLocationService();
});

final prayerCalculationServiceProvider = Provider<PrayerCalculationService>((ref) {
  return const PrayerCalculationService();
});

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  return PrayerRepositoryImpl(ref.watch(prayerCalculationServiceProvider));
});

class PrayerSettingsNotifier extends StateNotifier<PrayerSettings> {
  static const _key = 'prayer_settings_v1';

  final SharedPreferences _prefs;

  PrayerSettingsNotifier(this._prefs) : super(_load(_prefs));

  static PrayerSettings _load(SharedPreferences prefs) {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return PrayerSettings.defaults();
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return PrayerSettings.fromMap(decoded);
    } catch (_) {
      return PrayerSettings.defaults();
    }
  }

  void setCalculationMethod(PrayerCalculationMethod method) {
    state = state.copyWith(calculationMethod: method);
    _persist();
  }

  void setMadhab(PrayerMadhab madhab) {
    state = state.copyWith(madhab: madhab);
    _persist();
  }

  void setLocationMode(PrayerLocationMode mode) {
    state = state.copyWith(locationMode: mode);
    _persist();
  }

  void setTimeFormat(PrayerTimeFormat format) {
    state = state.copyWith(timeFormat: format);
    _persist();
  }

  void setShowSunrise(bool value) {
    state = state.copyWith(showSunrise: value);
    _persist();
  }

  void setShowHijriDate(bool value) {
    state = state.copyWith(showHijriDate: value);
    _persist();
  }

  void cacheAutoLocation(PrayerLocation location) {
    state = state.copyWith(
      locationMode: state.locationMode,
      cachedAutoLocation: location,
    );
    _persist();
  }

  void saveManualLocation(PrayerLocation location) {
    state = state.copyWith(
      locationMode: state.locationMode,
      manualLocation: location,
    );
    _persist();
  }

  void _persist() {
    _prefs.setString(_key, jsonEncode(state.toMap()));
  }
}

final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsNotifier, PrayerSettings>((ref) {
      return PrayerSettingsNotifier(ref.watch(sharedPreferencesProvider));
    });

class PrayerLocationController extends AsyncNotifier<PrayerLocation?> {
  @override
  Future<PrayerLocation?> build() async {
    final settings = ref.watch(prayerSettingsProvider);
    if (settings.locationMode == PrayerLocationMode.manual) {
      return settings.manualLocation;
    }

    if (settings.cachedAutoLocation != null) {
      return settings.cachedAutoLocation;
    }

    try {
      final location = await ref
          .read(prayerLocationServiceProvider)
          .resolveCurrentLocation();
      ref.read(prayerSettingsProvider.notifier).cacheAutoLocation(location);
      return location;
    } catch (_) {
      return null;
    }
  }

  Future<PrayerLocation?> activateAutoLocation({bool forceRefresh = false}) async {
    ref.read(prayerSettingsProvider.notifier).setLocationMode(
          PrayerLocationMode.auto,
        );

    final settings = ref.read(prayerSettingsProvider);
    if (!forceRefresh && settings.cachedAutoLocation != null) {
      state = AsyncData(settings.cachedAutoLocation);
      return settings.cachedAutoLocation;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final location = await ref
          .read(prayerLocationServiceProvider)
          .resolveCurrentLocation();
      ref.read(prayerSettingsProvider.notifier).cacheAutoLocation(location);
      return location;
    });
    return state.valueOrNull;
  }

  Future<void> activateManualLocation(PrayerLocation location) async {
    ref.read(prayerSettingsProvider.notifier).setLocationMode(
          PrayerLocationMode.manual,
        );
    ref.read(prayerSettingsProvider.notifier).saveManualLocation(location);
    state = AsyncData(location);
  }
}

final prayerLocationControllerProvider =
    AsyncNotifierProvider<PrayerLocationController, PrayerLocation?>(
      PrayerLocationController.new,
    );

final prayerScheduleRefreshProvider =
    StreamProvider.autoDispose<DateTime>((ref) async* {
      yield DateTime.now();
      while (true) {
        await Future<void>.delayed(const Duration(minutes: 1));
        yield DateTime.now();
      }
    });

final prayerScheduleProvider = Provider<AsyncValue<PrayerSchedule?>>((ref) {
  final settings = ref.watch(prayerSettingsProvider);
  final locationAsync = ref.watch(prayerLocationControllerProvider);
  final repository = ref.watch(prayerRepositoryProvider);
  final refreshNow =
      ref.watch(prayerScheduleRefreshProvider).valueOrNull ?? DateTime.now();

  return locationAsync.whenData((location) {
    if (location == null) {
      return null;
    }
    return repository.buildDailySchedule(
      settings: settings,
      location: location,
      now: refreshNow,
    );
  });
});

final prayerNotificationPlanProvider = Provider<PrayerNotificationPlan?>((ref) {
  return ref.watch(prayerScheduleProvider).valueOrNull?.notificationPlan;
});

final prayerSecondTickerProvider = StreamProvider.autoDispose<DateTime>((ref) async* {
  yield DateTime.now();
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield DateTime.now();
  }
});

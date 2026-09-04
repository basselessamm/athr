import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:midrar/features/settings/providers/settings_providers.dart';
import 'astronomical_prayer_calculator.dart';

var _timeZonesInitialized = false;

void _ensureTimeZonesInitialized() {
  if (_timeZonesInitialized) return;
  tz_data.initializeTimeZones();
  _timeZonesInitialized = true;
}

const _prayerNames = <PrayerName>[
  PrayerName.fajr,
  PrayerName.dhuhr,
  PrayerName.asr,
  PrayerName.maghrib,
  PrayerName.isha,
];

enum PrayerName {
  fajr('Fajr', 'الفجر'),
  dhuhr('Dhuhr', 'الظهر'),
  asr('Asr', 'العصر'),
  maghrib('Maghrib', 'المغرب'),
  isha('Isha', 'العشاء');

  const PrayerName(this.apiKey, this.arabicLabel);

  final String apiKey;
  final String arabicLabel;
}

/// The Asr shadow factor is a matter of scholarly methodology (madhhab),
/// not a universal constant. Both positions are exposed and the active one
/// is always disclosed in the UI.
enum AsrSchool {
  shafii(0, 'الجمهور (شافعي وغيرهم)'),
  hanafi(1, 'حنفي');

  const AsrSchool(this.apiValue, this.arabicLabel);

  final int apiValue;
  final String arabicLabel;
}

class PrayerLocation {
  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  final double latitude;
  final double longitude;
  final double accuracy;
}

class PrayerMoment {
  const PrayerMoment({required this.name, required this.at});

  final PrayerName name;
  final tz.TZDateTime at;
}

class PrayerDay {
  const PrayerDay({
    required this.gregorianDate,
    required this.hijriDate,
    required this.hijriMonth,
    required this.timezone,
    required this.moments,
  });

  final DateTime gregorianDate;
  final String hijriDate;
  final String hijriMonth;
  final String timezone;
  final List<PrayerMoment> moments;

  PrayerMoment? get nextPrayer {
    final now = tz.TZDateTime.now(_safeLocation(timezone));
    for (final moment in moments) {
      if (moment.at.isAfter(now)) return moment;
    }
    return null;
  }

  PrayerMoment? get currentPrayer {
    final now = tz.TZDateTime.now(_safeLocation(timezone));
    PrayerMoment? latest;
    for (final moment in moments) {
      if (!moment.at.isAfter(now)) latest = moment;
    }
    return latest;
  }
}

class PrayerSchedule {
  const PrayerSchedule({
    required this.days,
    required this.location,
    required this.calculationMethod,
    required this.asrSchool,
  });

  final List<PrayerDay> days;
  final PrayerLocation location;
  final int calculationMethod;
  final AsrSchool asrSchool;

  PrayerDay? get today {
    final now = DateTime.now();
    for (final day in days) {
      if (day.gregorianDate.year == now.year &&
          day.gregorianDate.month == now.month &&
          day.gregorianDate.day == now.day) {
        return day;
      }
    }
    return null;
  }
}

class PrayerSettings {
  const PrayerSettings({
    required this.calculationMethod,
    required this.asrHanafi,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.enabledPrayers,
  });

  final int calculationMethod;
  final bool asrHanafi;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final Set<PrayerName> enabledPrayers;

  AsrSchool get asrSchool =>
      asrHanafi ? AsrSchool.hanafi : AsrSchool.shafii;

  PrayerSettings copyWith({
    int? calculationMethod,
    bool? asrHanafi,
    bool? notificationsEnabled,
    bool? soundEnabled,
    Set<PrayerName>? enabledPrayers,
  }) {
    return PrayerSettings(
      calculationMethod: calculationMethod ?? this.calculationMethod,
      asrHanafi: asrHanafi ?? this.asrHanafi,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      enabledPrayers: enabledPrayers ?? this.enabledPrayers,
    );
  }
}

class PrayerSettingsNotifier extends StateNotifier<PrayerSettings> {
  PrayerSettingsNotifier(this._prefs) : super(_load(_prefs));

  static const _methodKey = 'prayer_calculation_method';
  static const _asrHanafiKey = 'prayer_asr_hanafi';
  static const _notificationsKey = 'prayer_notifications_enabled';
  static const _soundKey = 'prayer_notifications_sound_enabled';
  static const _prayersKey = 'prayer_notifications_selected';
  final SharedPreferences _prefs;

  static PrayerSettings _load(SharedPreferences prefs) {
    final selected = prefs.getStringList(_prayersKey);
    final names = selected == null
        ? _prayerNames.toSet()
        : selected
              .map((value) {
                for (final name in PrayerName.values) {
                  if (name.name == value) return name;
                }
                return null;
              })
              .whereType<PrayerName>()
              .toSet();
    return PrayerSettings(
      calculationMethod: prefs.getInt(_methodKey) ?? 5,
      asrHanafi: prefs.getBool(_asrHanafiKey) ?? false,
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? false,
      soundEnabled: prefs.getBool(_soundKey) ?? true,
      enabledPrayers: names,
    );
  }

  Future<void> setMethod(int method) async {
    state = state.copyWith(calculationMethod: method);
    await _prefs.setInt(_methodKey, method);
  }

  Future<void> setAsrHanafi(bool hanafi) async {
    state = state.copyWith(asrHanafi: hanafi);
    await _prefs.setBool(_asrHanafiKey, hanafi);
  }

  Future<void> setNotifications(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _prefs.setBool(_notificationsKey, enabled);
  }

  Future<void> setSound(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _prefs.setBool(_soundKey, enabled);
  }

  Future<void> togglePrayer(PrayerName prayer, bool enabled) async {
    final next = {...state.enabledPrayers};
    if (enabled) {
      next.add(prayer);
    } else {
      next.remove(prayer);
    }
    state = state.copyWith(enabledPrayers: next);
    await _prefs.setStringList(
      _prayersKey,
      next.map((prayer) => prayer.name).toList(growable: false),
    );
  }
}

final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsNotifier, PrayerSettings>((ref) {
      return PrayerSettingsNotifier(ref.watch(sharedPreferencesProvider));
    });

class PrayerTimesRepository {
  PrayerTimesRepository(this._client, this._prefs);

  final http.Client _client;
  final SharedPreferences _prefs;

  static const _locationLatitudeKey = 'prayer_last_latitude';
  static const _locationLongitudeKey = 'prayer_last_longitude';
  static const _locationAccuracyKey = 'prayer_last_accuracy';

  PrayerLocation? cachedLocation() {
    final latitude = _prefs.getDouble(_locationLatitudeKey);
    final longitude = _prefs.getDouble(_locationLongitudeKey);
    final accuracy = _prefs.getDouble(_locationAccuracyKey);
    if (latitude == null || longitude == null || accuracy == null) return null;
    return PrayerLocation(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
    );
  }

  Future<void> _cacheLocation(PrayerLocation location) async {
    await Future.wait([
      _prefs.setDouble(_locationLatitudeKey, location.latitude),
      _prefs.setDouble(_locationLongitudeKey, location.longitude),
      _prefs.setDouble(_locationAccuracyKey, location.accuracy),
    ]);
  }

  Future<PrayerLocation> locate() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw StateError('خدمة الموقع غير مفعلة. فعّلها لعرض مواعيد الصلاة.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('يلزم السماح بالموقع لاحتساب مواعيد الصلاة بدقة.');
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 20),
      ),
    );
    final location = PrayerLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
    await _cacheLocation(location);
    return location;
  }

  Future<PrayerSchedule> fetchSchedule({
    required PrayerLocation location,
    required DateTime anchor,
    required int calculationMethod,
    AsrSchool asrSchool = AsrSchool.shafii,
  }) async {
    // This is intentionally initialized only when a real timetable is
    // requested, rather than during Home startup or notification bootstrap.
    _ensureTimeZonesInitialized();
    final days = <PrayerDay>[];
    // Three months guarantee full coverage of the 60-day scheduling window
    // regardless of where within a month the anchor falls.
    for (var offset = 0; offset < 3; offset++) {
      final month = DateTime(anchor.year, anchor.month + offset);
      final key = cacheKeyFor(location, month, calculationMethod, asrSchool);
      final cached = _prefs.getString(key);
      Map<String, dynamic>? payload;
      if (cached != null) {
        payload = jsonDecode(cached) as Map<String, dynamic>;
      } else {
        final uri = Uri.https(
          'api.aladhan.com',
          '/v1/calendar/${month.year}/${month.month}',
          {
            'latitude': location.latitude.toStringAsFixed(6),
            'longitude': location.longitude.toStringAsFixed(6),
            'method': '$calculationMethod',
            'school': '${asrSchool.apiValue}',
          },
        );
        try {
          final response = await _client
              .get(uri)
              .timeout(const Duration(seconds: 15));
          if (response.statusCode == 200) {
            payload = jsonDecode(response.body) as Map<String, dynamic>;
            await _prefs.setString(key, jsonEncode(payload));
          }
        } catch (_) {
          // Network offline / timeout
        }

        if (payload == null) {
          // Offline fallback: calculate astronomical prayer times mathematically
          // so user is never left stranded without a timetable.
          final fallbackDays = _generateAstronomicalMonth(
            month: month,
            location: location,
            calculationMethod: calculationMethod,
            asrSchool: asrSchool,
          );
          for (final day in fallbackDays) {
            if (!day.gregorianDate.isBefore(
                  DateTime(anchor.year, anchor.month, anchor.day),
                ) &&
                day.gregorianDate.isBefore(
                  DateTime(
                    anchor.year,
                    anchor.month,
                    anchor.day,
                  ).add(const Duration(days: 60)),
                )) {
              days.add(day);
            }
          }
          continue;
        }
      }
      final rows = payload['data'] as List<dynamic>? ?? const [];
      for (final row in rows.cast<Map<String, dynamic>>()) {
        final day = _parseDay(row);
        if (!day.gregorianDate.isBefore(
              DateTime(anchor.year, anchor.month, anchor.day),
            ) &&
            day.gregorianDate.isBefore(
              DateTime(
                anchor.year,
                anchor.month,
                anchor.day,
              ).add(const Duration(days: 60)),
            )) {
          days.add(day);
        }
      }
    }
    days.sort((a, b) => a.gregorianDate.compareTo(b.gregorianDate));
    return PrayerSchedule(
      days: days,
      location: location,
      calculationMethod: calculationMethod,
      asrSchool: asrSchool,
    );
  }

  List<PrayerDay> _generateAstronomicalMonth({
    required DateTime month,
    required PrayerLocation location,
    required int calculationMethod,
    required AsrSchool asrSchool,
  }) {
    const calculator = AstronomicalPrayerCalculator();
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final tzName = _prefs.getString('prayer_last_timezone') ?? 'UTC';

    final result = <PrayerDay>[];
    for (var dayNum = 1; dayNum <= daysInMonth; dayNum++) {
      final date = DateTime(month.year, month.month, dayNum);
      result.add(
        calculator.calculateDay(
          date: date,
          location: location,
          calculationMethod: calculationMethod,
          asrSchool: asrSchool,
          timezoneName: tzName,
        ),
      );
    }
    return result;
  }

  String cacheKeyFor(
    PrayerLocation location,
    DateTime month,
    int method,
    AsrSchool asrSchool,
  ) {
    return 'prayer-calendar-${month.year}-${month.month}-${location.latitude.toStringAsFixed(2)}-${location.longitude.toStringAsFixed(2)}-$method-${asrSchool.apiValue}';
  }

  @visibleForTesting
  PrayerDay parseDayForTest(Map<String, dynamic> row) => _parseDay(row);

  PrayerDay _parseDay(Map<String, dynamic> row) {
    final meta = row['meta'] as Map<String, dynamic>;
    final timezone = meta['timezone'] as String? ?? 'UTC';
    try {
      _prefs.setString('prayer_last_timezone', timezone);
    } catch (_) {}
    final gregorian =
        (row['date'] as Map<String, dynamic>)['gregorian']
            as Map<String, dynamic>;
    final hijri =
        (row['date'] as Map<String, dynamic>)['hijri'] as Map<String, dynamic>;
    final parts = (gregorian['date'] as String).split('-');
    final date = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
    final timingMap = row['timings'] as Map<String, dynamic>;
    final location = _safeLocation(timezone);
    final moments = _prayerNames
        .map((name) {
          final raw = timingMap[name.apiKey] as String;
          final clock = raw.substring(0, 5).split(':');
          return PrayerMoment(
            name: name,
            at: tz.TZDateTime(
              location,
              date.year,
              date.month,
              date.day,
              int.parse(clock[0]),
              int.parse(clock[1]),
            ),
          );
        })
        .toList(growable: false);
    final hijriMonth =
        (hijri['month'] as Map<String, dynamic>)['ar'] as String? ?? '';
    return PrayerDay(
      gregorianDate: date,
      hijriDate: hijri['date'] as String? ?? '',
      hijriMonth: hijriMonth,
      timezone: timezone,
      moments: moments,
    );
  }
}

tz.Location _safeLocation(String timezone) {
  _ensureTimeZonesInitialized();
  try {
    return tz.getLocation(timezone);
  } catch (_) {
    return tz.getLocation('UTC');
  }
}

final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>((ref) {
  return PrayerTimesRepository(
    http.Client(),
    ref.watch(sharedPreferencesProvider),
  );
});

/// Increments only when the user explicitly requests a fresh GPS lookup.
/// Home can therefore render cached times or an actionable state without
/// starting Android's location service during app startup.
final prayerLocationRefreshProvider = StateProvider<int>((ref) => 0);

final prayerLocationProvider = FutureProvider<PrayerLocation>((ref) async {
  final refreshToken = ref.watch(prayerLocationRefreshProvider);
  final repository = ref.watch(prayerTimesRepositoryProvider);
  final cached = repository.cachedLocation();
  if (cached != null && refreshToken == 0) return cached;
  if (cached == null && refreshToken == 0) {
    throw StateError('حدّد موقعك لعرض مواقيت الصلاة الدقيقة.');
  }
  return repository.locate();
});

final prayerScheduleProvider = FutureProvider<PrayerSchedule>((ref) async {
  final settings = ref.watch(prayerSettingsProvider);
  final location = await ref.watch(prayerLocationProvider.future);
  return ref
      .watch(prayerTimesRepositoryProvider)
      .fetchSchedule(
        location: location,
        anchor: DateTime.now(),
        calculationMethod: settings.calculationMethod,
        asrSchool: settings.asrSchool,
      );
});

/// Hijri dates shown in the app come from the timetable source (astronomical
/// Umm al-Qura based calculation). Local religious authorities may announce
/// dates by actual moon sighting; a user-facing offset exists for display
/// adjustment without implying any religious authority.
const String kHijriMethodDisclosure = 'حسب الحساب الفلكي (أم القرى) وقد يختلف عن الرؤية الشرعية المحلية';

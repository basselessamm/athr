import 'dart:convert';


import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midrar/features/prayer/application/prayer_notification_planner.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';

/// A real, unmodified single-day response captured live from
/// api.aladhan.com on 2026-08-25:
/// GET /v1/calendar/2026/8?latitude=51.5074&longitude=-0.1278&method=5&school=0
const _realAladhanDay = '''
{"timings": {"Fajr": "02:37 (BST)", "Sunrise": "05:24 (BST)", "Dhuhr": "13:07 (BST)", "Asr": "17:17 (BST)", "Sunset": "20:49 (BST)", "Maghrib": "20:49 (BST)", "Isha": "23:19 (BST)", "Imsak": "02:27 (BST)", "Midnight": "01:06 (BST)", "Firstthird": "23:41 (BST)", "Lastthird": "02:32 (BST)"}, "date": {"readable": "01 Aug 2026", "timestamp": "1785571261", "gregorian": {"date": "01-08-2026", "format": "DD-MM-YYYY", "day": "01", "weekday": {"en": "Saturday"}, "month": {"number": 8, "en": "August"}, "year": "2026", "designation": {"abbreviated": "AD", "expanded": "Anno Domini"}, "lunarSighting": false}, "hijri": {"date": "18-02-1448", "format": "DD-MM-YYYY", "day": "18", "weekday": {"en": "Al Sabt", "ar": "السبت"}, "month": {"number": 2, "en": "Ṣafar", "ar": "صَفَر", "days": 30}, "year": "1448", "designation": {"abbreviated": "AH", "expanded": "Anno Hegirae"}, "holidays": [], "adjustedHolidays": [], "method": "HJCoSA"}}, "meta": {"latitude": 51.5074, "longitude": -0.1278, "timezone": "Europe/London", "method": {"id": 5, "name": "Egyptian General Authority of Survey", "params": {"Fajr": 19.5, "Isha": 17.5}, "location": {"latitude": 30.0444196, "longitude": 31.2357116}}, "latitudeAdjustmentMethod": "ANGLE_BASED", "midnightMode": "STANDARD", "school": "STANDARD", "offset": {"Imsak": 0, "Fajr": 0, "Sunrise": 0, "Dhuhr": 0, "Asr": 0, "Maghrib": 0, "Sunset": 0, "Isha": 0, "Midnight": 0}}}
''';

PrayerDay _parseRealDay() {
  final repository = PrayerTimesRepository(
    _NoopClient(),
    _ThrowingPrefs(),
  );
  return repository.parseDayForTest(
    jsonDecode(_realAladhanDay) as Map<String, dynamic>,
  );
}

class _ThrowingPrefs implements SharedPreferences {
  @override
  Future<bool> setString(String key, String value) async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _NoopClient implements http.Client {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('Adhan scheduling chain (real API payload → parse → plan)', () {
    final day = _parseRealDay();

    test('parses all five prayers at the exact API minutes (Europe/London)', () {
      final london = tz.getLocation('Europe/London');
      tz.TZDateTime at(int h, int m) =>
          tz.TZDateTime(london, 2026, 8, 1, h, m);

      expect(day.timezone, 'Europe/London');
      final byName = {
        for (final moment in day.moments) moment.name: moment.at,
      };
      expect(byName[PrayerName.fajr], at(2, 37));
      expect(byName[PrayerName.dhuhr], at(13, 7));
      expect(byName[PrayerName.asr], at(17, 17));
      expect(byName[PrayerName.maghrib], at(20, 49));
      expect(byName[PrayerName.isha], at(23, 19));
    });

    test('plans exactly five future notifications at exact minutes', () {
      final london = tz.getLocation('Europe/London');
      final now = tz.TZDateTime(london, 2026, 8, 1, 0, 30); // before Fajr
      final settings = PrayerSettings(
        calculationMethod: 5,
        asrHanafi: false,
        notificationsEnabled: true,
        soundEnabled: true,
        enabledPrayers: PrayerName.values.toSet(),
      );

      final plans = planPrayerNotifications(
        schedule: PrayerSchedule(
          days: [day],
          location: const PrayerLocation(
            latitude: 51.5074,
            longitude: -0.1278,
            accuracy: 20,
          ),
          calculationMethod: 5,
          asrSchool: AsrSchool.shafii,
        ),
        settings: settings,
        now: now,
        idFor: prayerNotificationId,
      );

      expect(plans, hasLength(5));
      expect(plans[0].name, PrayerName.fajr);
      expect(plans[0].at.hour, 2);
      expect(plans[0].at.minute, 37);
      expect(plans[1].name, PrayerName.dhuhr);
      expect(plans[1].at.hour, 13);
      expect(plans[1].at.minute, 7);
      expect(plans[2].name, PrayerName.asr);
      expect(plans[2].at.hour, 17);
      expect(plans[2].at.minute, 17);
      expect(plans[3].name, PrayerName.maghrib);
      expect(plans[3].at.hour, 20);
      expect(plans[3].at.minute, 49);
      expect(plans[4].name, PrayerName.isha);
      expect(plans[4].at.hour, 23);
      expect(plans[4].at.minute, 19);
      // Sound-on channel naming.
      expect(plans[0].channelId, 'prayer_audio_fajr_v2');
      expect(plans[0].withSound, isTrue);
      // Deep link targets the prayer screen.
      expect(plans[0].payload, contains('/prayer'));
      expect(plans[0].payload, contains('prayer=fajr'));
    });

    test('past prayers are never scheduled', () {
      final london = tz.getLocation('Europe/London');
      final now = tz.TZDateTime(london, 2026, 8, 1, 18, 0); // after Asr
      final settings = PrayerSettings(
        calculationMethod: 5,
        asrHanafi: false,
        notificationsEnabled: true,
        soundEnabled: false,
        enabledPrayers: PrayerName.values.toSet(),
      );

      final plans = planPrayerNotifications(
        schedule: PrayerSchedule(
          days: [day],
          location: const PrayerLocation(
            latitude: 51.5074,
            longitude: -0.1278,
            accuracy: 20,
          ),
          calculationMethod: 5,
          asrSchool: AsrSchool.shafii,
        ),
        settings: settings,
        now: now,
        idFor: prayerNotificationId,
      );

      expect(
        plans.map((p) => p.name),
        [PrayerName.maghrib, PrayerName.isha],
      );
      // Silent channel naming.
      expect(plans.first.channelId, 'prayer_silent_maghrib_v2');
    });

    test('per-prayer toggles are respected', () {
      final london = tz.getLocation('Europe/London');
      final now = tz.TZDateTime(london, 2026, 8, 1, 0, 30);
      final settings = PrayerSettings(
        calculationMethod: 5,
        asrHanafi: false,
        notificationsEnabled: true,
        soundEnabled: true,
        enabledPrayers: {PrayerName.fajr},
      );

      final plans = planPrayerNotifications(
        schedule: PrayerSchedule(
          days: [day],
          location: const PrayerLocation(
            latitude: 51.5074,
            longitude: -0.1278,
            accuracy: 20,
          ),
          calculationMethod: 5,
          asrSchool: AsrSchool.shafii,
        ),
        settings: settings,
        now: now,
        idFor: prayerNotificationId,
      );

      expect(plans, hasLength(1));
      expect(plans.single.name, PrayerName.fajr);
    });

    test('notification ids are deterministic per (date, prayer)', () {
      final a = prayerNotificationId(DateTime(2026, 8, 1), PrayerName.fajr);
      final b = prayerNotificationId(DateTime(2026, 8, 1), PrayerName.fajr);
      final c = prayerNotificationId(DateTime(2026, 8, 2), PrayerName.fajr);
      final d = prayerNotificationId(DateTime(2026, 8, 1), PrayerName.isha);
      expect(a, b);
      expect(a, isNot(c));
      expect(a, isNot(d));
      // Five prayers across 60 days must not collide in practice.
      final ids = <int>{
        for (var dayNum = 1; dayNum <= 60; dayNum++)
          for (final name in PrayerName.values)
            prayerNotificationId(DateTime(2026, 8, dayNum), name),
      };
      expect(ids, hasLength(60 * 5));
    });
  });

  group('calculation settings change the timetable', () {
    test('madhhab and method change the request cache key', () {
      final repository = PrayerTimesRepository(_NoopClient(), _ThrowingPrefs());
      final location = const PrayerLocation(
        latitude: 51.5074,
        longitude: -0.1278,
        accuracy: 20,
      );
      final month = DateTime(2026, 8);

      final shafii = repository.cacheKeyFor(
        location,
        month,
        5,
        AsrSchool.shafii,
      );
      final hanafi = repository.cacheKeyFor(
        location,
        month,
        5,
        AsrSchool.hanafi,
      );
      final mwl = repository.cacheKeyFor(
        location,
        month,
        3,
        AsrSchool.shafii,
      );

      expect(shafii, isNot(hanafi), reason: 'madhhab change must refetch');
      expect(shafii, isNot(mwl), reason: 'method change must refetch');
    });

    test('Asr schools map to the documented aladhan API values', () {
      expect(AsrSchool.shafii.apiValue, 0);
      expect(AsrSchool.hanafi.apiValue, 1);
    });
  });
}

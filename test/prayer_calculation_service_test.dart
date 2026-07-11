import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

import 'package:athr/features/prayer/data/prayer_calculation_service.dart';
import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/domain/prayer_location.dart';
import 'package:athr/features/prayer/domain/prayer_settings.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('PrayerCalculationService', () {
    const service = PrayerCalculationService();
    const riyadh = PrayerLocation(
      latitude: 24.7136,
      longitude: 46.6753,
      timeZoneId: 'Asia/Riyadh',
      label: 'الرياض',
    );

    test('builds ordered daily schedule with tomorrow fajr', () {
      final settings = PrayerSettings.defaults();

      final schedule = service.buildDailySchedule(
        settings: settings,
        location: riyadh,
        now: DateTime.utc(2026, 7, 11, 9, 0),
      );

      expect(schedule.entries, hasLength(6));
      expect(
        schedule.entries.map((entry) => entry.type).toList(),
        [
          PrayerType.fajr,
          PrayerType.sunrise,
          PrayerType.dhuhr,
          PrayerType.asr,
          PrayerType.maghrib,
          PrayerType.isha,
        ],
      );

      for (var index = 0; index < schedule.entries.length - 1; index++) {
        expect(
          schedule.entries[index].time.isBefore(schedule.entries[index + 1].time),
          isTrue,
        );
      }

      expect(schedule.tomorrowFajr.time.isAfter(schedule.entries.last.time), isTrue);
      expect(schedule.notificationPlan.slots, hasLength(5));
    });

    test('resolves status against prayer timezone instead of device timezone', () {
      final settings = PrayerSettings.defaults().copyWith(
        calculationMethod: PrayerCalculationMethod.ummAlQura,
      );

      final schedule = service.buildDailySchedule(
        settings: settings,
        location: riyadh,
        now: DateTime.utc(2026, 7, 11, 9, 0),
      );

      final snapshot = service.resolveStatus(
        schedule: schedule,
        now: DateTime.utc(2026, 7, 11, 16, 30),
      );

      expect(snapshot.remaining.inSeconds, greaterThanOrEqualTo(0));
      expect(snapshot.targetTime.isAfter(DateTime.utc(2026, 7, 11, 16, 30)), isTrue);
      expect(snapshot.nextPrayer, isNot(PrayerType.sunrise));
    });
  });
}

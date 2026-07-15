import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:hijri/hijri_calendar.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:athr/features/prayer/domain/prayer_entry.dart';
import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/domain/prayer_location.dart';
import 'package:athr/features/prayer/domain/prayer_notification_plan.dart';
import 'package:athr/features/prayer/domain/prayer_schedule.dart';
import 'package:athr/features/prayer/domain/prayer_settings.dart';
import 'package:athr/features/prayer/domain/prayer_status_snapshot.dart';

class PrayerCalculationService {
  const PrayerCalculationService();

  static bool _timeZonesInitialized = false;

  PrayerSchedule buildDailySchedule({
    required PrayerSettings settings,
    required PrayerLocation location,
    required DateTime now,
  }) {
    _ensureTimeZonesInitialized();

    final timeZone = tz.getLocation(location.timeZoneId);
    // Use wall clock time from device to avoid DST/UTC mismatch if user manually changed clock
    final localNow = tz.TZDateTime(
      timeZone,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
    final today = tz.TZDateTime(
      timeZone,
      localNow.year,
      localNow.month,
      localNow.day,
    );
    final tomorrow = today.add(const Duration(days: 1));

    final coordinates = adhan.Coordinates(location.latitude, location.longitude);
    final parameters = _buildParameters(
      method: settings.calculationMethod,
      madhab: settings.madhab,
      coordinates: coordinates,
      isRamadan: HijriCalendar.fromDate(localNow).hMonth == 9,
    );

    final todayTimes = adhan.PrayerTimes(
      coordinates: coordinates,
      date: today,
      calculationParameters: parameters,
      precision: true,
    );

    final tomorrowTimes = adhan.PrayerTimes(
      coordinates: coordinates,
      date: tomorrow,
      calculationParameters: parameters,
      precision: true,
    );

    final entries = <PrayerEntry>[
      PrayerEntry(
        type: PrayerType.fajr,
        time: tz.TZDateTime.from(todayTimes.fajr, timeZone),
      ),
      PrayerEntry(
        type: PrayerType.sunrise,
        time: tz.TZDateTime.from(todayTimes.sunrise, timeZone),
      ),
      PrayerEntry(
        type: PrayerType.dhuhr,
        time: tz.TZDateTime.from(todayTimes.dhuhr, timeZone),
      ),
      PrayerEntry(
        type: PrayerType.asr,
        time: tz.TZDateTime.from(todayTimes.asr, timeZone),
      ),
      PrayerEntry(
        type: PrayerType.maghrib,
        time: tz.TZDateTime.from(todayTimes.maghrib, timeZone),
      ),
      PrayerEntry(
        type: PrayerType.isha,
        time: tz.TZDateTime.from(todayTimes.isha, timeZone),
      ),
    ];

    final tomorrowFajr = PrayerEntry(
      type: PrayerType.fajr,
      time: tz.TZDateTime.from(tomorrowTimes.fajr, timeZone),
    );

    return PrayerSchedule(
      location: location,
      method: settings.calculationMethod,
      madhab: settings.madhab,
      hijriDate: HijriCalendar.fromDate(localNow),
      entries: entries,
      tomorrowFajr: tomorrowFajr,
      notificationPlan: PrayerNotificationPlan(
        timeZoneId: location.timeZoneId,
        slots: entries
            .where((entry) => entry.isObligatory)
            .map(
              (entry) => PrayerNotificationSlot(
                prayer: entry.type,
                scheduledAt: entry.time,
                payload: 'prayer_${entry.type.name}',
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  PrayerStatusSnapshot resolveStatus({
    required PrayerSchedule schedule,
    required DateTime now,
  }) {
    _ensureTimeZonesInitialized();

    final timeZone = tz.getLocation(schedule.location.timeZoneId);
    // Use wall clock time from device to avoid DST/UTC mismatch
    final localNow = tz.TZDateTime(
      timeZone,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
    final requiredPrayers = schedule.entries
        .where((entry) => entry.isObligatory)
        .toList(growable: false);
    final fajr = requiredPrayers.first;

    if (localNow.isBefore(fajr.time)) {
      return PrayerStatusSnapshot(
        currentPrayer: PrayerType.isha,
        nextPrayer: fajr.type,
        targetTime: fajr.time,
        remaining: fajr.time.difference(localNow),
        headline: 'متبقٍ على ${fajr.type.label}',
        supportingText: 'آخر فرض كان العشاء، والاستعداد الآن للفجر.',
      );
    }

    for (var index = 0; index < requiredPrayers.length - 1; index++) {
      final current = requiredPrayers[index];
      final next = requiredPrayers[index + 1];
      if (localNow.isBefore(next.time)) {
        return PrayerStatusSnapshot(
          currentPrayer: current.type,
          nextPrayer: next.type,
          targetTime: next.time,
          remaining: next.time.difference(localNow),
          headline: 'متبقٍ على ${next.type.label}',
          supportingText: 'الفرض الحالي ${current.type.label}.',
        );
      }
    }

    return PrayerStatusSnapshot(
      currentPrayer: PrayerType.isha,
      nextPrayer: schedule.tomorrowFajr.type,
      targetTime: schedule.tomorrowFajr.time,
      remaining: schedule.tomorrowFajr.time.difference(localNow),
      headline: 'متبقٍ على ${schedule.tomorrowFajr.type.label}',
      supportingText: 'الفرض الحالي العشاء، والموعد التالي مع فجر اليوم الجديد.',
    );
  }

  adhan.CalculationParameters _buildParameters({
    required PrayerCalculationMethod method,
    required PrayerMadhab madhab,
    required adhan.Coordinates coordinates,
    required bool isRamadan,
  }) {
    final parameters = switch (method) {
      PrayerCalculationMethod.muslimWorldLeague =>
        adhan.CalculationMethodParameters.muslimWorldLeague(),
      PrayerCalculationMethod.egyptianGeneralAuthority =>
        adhan.CalculationMethodParameters.egyptian(),
      PrayerCalculationMethod.ummAlQura =>
        adhan.CalculationMethodParameters.ummAlQura(),
      PrayerCalculationMethod.isna =>
        adhan.CalculationMethodParameters.northAmerica(),
      PrayerCalculationMethod.karachi =>
        adhan.CalculationMethodParameters.karachi(),
      PrayerCalculationMethod.dubai =>
        adhan.CalculationMethodParameters.dubai(),
      PrayerCalculationMethod.qatar =>
        adhan.CalculationMethodParameters.qatar(),
      PrayerCalculationMethod.kuwait =>
        adhan.CalculationMethodParameters.kuwait(),
      PrayerCalculationMethod.moonsightingCommittee =>
        adhan.CalculationMethodParameters.moonsightingCommittee(),
    };

    parameters.madhab = madhab == PrayerMadhab.hanafi
        ? adhan.Madhab.hanafi
        : adhan.Madhab.shafi;
    parameters.highLatitudeRule = adhan.HighLatitudeRule.recommended(
      coordinates,
    );

    if (method == PrayerCalculationMethod.ummAlQura && isRamadan) {
      parameters.adjustments[adhan.Prayer.isha] = 30;
    }

    return parameters;
  }

  void _ensureTimeZonesInitialized() {
    if (_timeZonesInitialized) {
      return;
    }
    tz_data.initializeTimeZones();
    _timeZonesInitialized = true;
  }
}

import 'dart:math' as math;
import 'package:timezone/timezone.dart' as tz;
import 'prayer_times.dart';

/// Offline mathematical solar prayer times calculator based on astronomical
/// algorithms (Jean Meeus / Astronomical Algorithms and standard Islamic
/// calculation methodologies).
///
/// Ensures the application remains 100% functional offline even without
/// internet access or pre-existing AlAdhan API cache.
class AstronomicalPrayerCalculator {
  const AstronomicalPrayerCalculator();

  static const double _degToRad = math.pi / 180.0;
  static const double _radToDeg = 180.0 / math.pi;

  /// Calculates prayer moments for a single day using solar coordinates.
  PrayerDay calculateDay({
    required DateTime date,
    required PrayerLocation location,
    required int calculationMethod,
    required AsrSchool asrSchool,
    required String timezoneName,
  }) {
    final locationTz = _safeLocation(timezoneName);
    final tzNow = tz.TZDateTime(
      locationTz,
      date.year,
      date.month,
      date.day,
      12,
    );
    final tzOffsetHours = tzNow.timeZoneOffset.inMinutes / 60.0;

    // Julian Date at 0h UT
    final jd = _julianDate(date.year, date.month, date.day);
    // Approximate Julian day at solar noon
    final d0 = jd - 2451545.0 + (12.0 - location.longitude / 15.0) / 24.0;

    // Solar coordinates
    final solar = _sunCoordinates(d0);
    final declination = solar.declination;
    final equationOfTime = solar.equationOfTime; // in minutes

    // Solar noon (Dhuhr) in local hours
    final dhuhrHours =
        12.0 + tzOffsetHours - (location.longitude / 15.0) - (equationOfTime / 60.0);

    // Method-specific angles
    final angles = _methodAngles(calculationMethod);

    // Sun altitude at sunrise / sunset (accounting for refraction & solar radius)
    const double sunAltHorizon = -0.833;

    // Sunset hours (Maghrib)
    final sunsetHours =
        dhuhrHours + _hourAngle(location.latitude, declination, sunAltHorizon) / 15.0;

    // Fajr hours
    final fajrHours = dhuhrHours -
        _hourAngle(location.latitude, declination, -angles.fajrAngle) / 15.0;

    // Asr hours
    final shadowFactor = asrSchool == AsrSchool.hanafi ? 2.0 : 1.0;
    final asrAlt = _radToDeg *
        math.atan(
          1.0 /
              (shadowFactor +
                  math.tan((location.latitude - declination).abs() * _degToRad)),
        );
    final asrHours =
        dhuhrHours + _hourAngle(location.latitude, declination, asrAlt) / 15.0;

    // Maghrib hours (coincides with sunset)
    final maghribHours = sunsetHours;

    // Isha hours
    double ishaHours;
    if (angles.ishaIntervalMinutes != null) {
      ishaHours = maghribHours + (angles.ishaIntervalMinutes! / 60.0);
    } else {
      ishaHours = dhuhrHours +
          _hourAngle(location.latitude, declination, -angles.ishaAngle) / 15.0;
    }

    tz.TZDateTime toTzDateTime(double decimalHours) {
      final totalSeconds = (decimalHours * 3600.0).round();
      final hours = (totalSeconds ~/ 3600) % 24;
      final minutes = ((totalSeconds % 3600) ~/ 60) % 60;
      return tz.TZDateTime(
        locationTz,
        date.year,
        date.month,
        date.day,
        hours,
        minutes,
      );
    }

    final moments = [
      PrayerMoment(name: PrayerName.fajr, at: toTzDateTime(fajrHours)),
      PrayerMoment(name: PrayerName.dhuhr, at: toTzDateTime(dhuhrHours)),
      PrayerMoment(name: PrayerName.asr, at: toTzDateTime(asrHours)),
      PrayerMoment(name: PrayerName.maghrib, at: toTzDateTime(maghribHours)),
      PrayerMoment(name: PrayerName.isha, at: toTzDateTime(ishaHours)),
    ];

    return PrayerDay(
      gregorianDate: DateTime(date.year, date.month, date.day),
      hijriDate: '${date.day}',
      hijriMonth: 'تقريبي',
      timezone: timezoneName,
      moments: moments,
    );
  }

  static double _julianDate(int year, int month, int day) {
    var y = year;
    var m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        b -
        1524.5;
  }

  static ({double declination, double equationOfTime}) _sunCoordinates(
    double d,
  ) {
    // Mean anomaly of the sun
    final m = (357.529 + 0.98560028 * d) % 360.0;
    final mRad = m * _degToRad;

    // Mean longitude of the sun
    final l0 = (280.459 + 0.98564736 * d) % 360.0;

    // Ecliptic longitude of the sun
    final c = (1.915 * math.sin(mRad)) + (0.020 * math.sin(2 * mRad));
    final lambda = (l0 + c) % 360.0;
    final lambdaRad = lambda * _degToRad;

    // Obliquity of the ecliptic
    final epsilon = (23.439 - 0.00000036 * d) * _degToRad;

    // Declination of the sun
    final sinDecl = math.sin(epsilon) * math.sin(lambdaRad);
    final declination = math.asin(sinDecl) * _radToDeg;

    // Equation of time in minutes
    final y = math.pow(math.tan(epsilon / 2.0), 2);
    final eotRad = y * math.sin(2 * l0 * _degToRad) -
        2 * 0.0167 * math.sin(mRad) +
        4 * 0.0167 * y * math.sin(mRad) * math.cos(2 * l0 * _degToRad) -
        0.5 * y * y * math.sin(4 * l0 * _degToRad);
    final equationOfTime = eotRad * _radToDeg * 4.0;

    return (declination: declination, equationOfTime: equationOfTime);
  }

  static double _hourAngle(double lat, double decl, double alt) {
    final latRad = lat * _degToRad;
    final declRad = decl * _degToRad;
    final altRad = alt * _degToRad;

    final cosH = (math.sin(altRad) - (math.sin(latRad) * math.sin(declRad))) /
        (math.cos(latRad) * math.cos(declRad));

    if (cosH > 1.0) return 0.0; // Always below horizon
    if (cosH < -1.0) return 180.0; // Always above horizon

    return math.acos(cosH) * _radToDeg;
  }

  static ({double fajrAngle, double ishaAngle, double? ishaIntervalMinutes})
      _methodAngles(int method) {
    switch (method) {
      case 4: // Umm Al-Qura (Makkah)
        return (fajrAngle: 18.5, ishaAngle: 18.0, ishaIntervalMinutes: 90.0);
      case 5: // Egyptian General Authority of Survey
        return (fajrAngle: 19.5, ishaAngle: 17.5, ishaIntervalMinutes: null);
      case 3: // Muslim World League
        return (fajrAngle: 18.0, ishaAngle: 17.0, ishaIntervalMinutes: null);
      case 2: // Islamic Society of North America (ISNA)
        return (fajrAngle: 15.0, ishaAngle: 15.0, ishaIntervalMinutes: null);
      case 1: // University of Islamic Sciences, Karachi
        return (fajrAngle: 18.0, ishaAngle: 18.0, ishaIntervalMinutes: null);
      default:
        return (fajrAngle: 18.5, ishaAngle: 17.5, ishaIntervalMinutes: null);
    }
  }

  static tz.Location _safeLocation(String name) {
    try {
      return tz.getLocation(name);
    } catch (_) {
      return tz.local;
    }
  }
}

import 'package:hijri/hijri_calendar.dart';

import 'prayer_entry.dart';
import 'prayer_enums.dart';
import 'prayer_location.dart';
import 'prayer_notification_plan.dart';

class PrayerSchedule {
  final PrayerLocation location;
  final PrayerCalculationMethod method;
  final PrayerMadhab madhab;
  final HijriCalendar hijriDate;
  final List<PrayerEntry> entries;
  final PrayerEntry tomorrowFajr;
  final PrayerNotificationPlan notificationPlan;

  const PrayerSchedule({
    required this.location,
    required this.method,
    required this.madhab,
    required this.hijriDate,
    required this.entries,
    required this.tomorrowFajr,
    required this.notificationPlan,
  });
}

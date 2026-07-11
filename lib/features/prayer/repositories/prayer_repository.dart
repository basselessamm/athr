import 'package:athr/features/prayer/domain/prayer_location.dart';
import 'package:athr/features/prayer/domain/prayer_schedule.dart';
import 'package:athr/features/prayer/domain/prayer_settings.dart';
import 'package:athr/features/prayer/domain/prayer_status_snapshot.dart';

abstract class PrayerRepository {
  PrayerSchedule buildDailySchedule({
    required PrayerSettings settings,
    required PrayerLocation location,
    required DateTime now,
  });

  PrayerStatusSnapshot resolveStatus({
    required PrayerSchedule schedule,
    required DateTime now,
  });
}

import 'package:athr/features/prayer/data/prayer_calculation_service.dart';
import 'package:athr/features/prayer/domain/prayer_location.dart';
import 'package:athr/features/prayer/domain/prayer_schedule.dart';
import 'package:athr/features/prayer/domain/prayer_settings.dart';
import 'package:athr/features/prayer/domain/prayer_status_snapshot.dart';
import 'package:athr/features/prayer/repositories/prayer_repository.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerCalculationService _calculationService;

  const PrayerRepositoryImpl(this._calculationService);

  @override
  PrayerSchedule buildDailySchedule({
    required PrayerSettings settings,
    required PrayerLocation location,
    required DateTime now,
  }) {
    return _calculationService.buildDailySchedule(
      settings: settings,
      location: location,
      now: now,
    );
  }

  @override
  PrayerStatusSnapshot resolveStatus({
    required PrayerSchedule schedule,
    required DateTime now,
  }) {
    return _calculationService.resolveStatus(schedule: schedule, now: now);
  }
}

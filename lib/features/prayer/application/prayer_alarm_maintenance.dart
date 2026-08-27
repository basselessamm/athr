import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/services/notification_service.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';

/// Keeps Athan alarms alive across days, reboots, and app updates.
///
/// Scheduling covers a rolling window; without maintenance the window
/// silently expires. This provider:
///  1. reads persisted settings (no network required),
///  2. rebuilds the timetable from the cached month payloads when present,
///  3. cancels + reschedules every future prayer notification in the window.
///
/// It runs at app startup and on every resume (see MidrarApp lifecycle).
final prayerAlarmMaintenanceProvider = FutureProvider<void>((ref) async {
  final settings = ref.read(prayerSettingsProvider);
  final repository = ref.read(prayerTimesRepositoryProvider);
  final notifications = ref.read(notificationServiceProvider);

  if (!settings.notificationsEnabled) return;

  final location = repository.cachedLocation();
  if (location == null) {
    // The user has not configured a location yet; nothing to maintain.
    // First-time setup goes through the interactive prayer card instead.
    return;
  }

  try {
    final schedule = await repository.fetchSchedule(
      location: location,
      anchor: DateTime.now(),
      calculationMethod: settings.calculationMethod,
      asrSchool: settings.asrHanafi ? AsrSchool.hanafi : AsrSchool.shafii,
    );
    await notifications.schedulePrayerNotifications(
      schedule: schedule,
      settings: settings,
    );
  } catch (error, stackTrace) {
    // Maintenance is best-effort: cached months may be absent on first run,
    // or offline. The next successful fetch/resume repairs the window.
    debugPrint('Prayer alarm maintenance skipped: $error\n$stackTrace');
  }
});

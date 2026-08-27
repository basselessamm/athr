import 'package:timezone/timezone.dart' as tz;

import 'package:midrar/core/services/notification_service.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';

/// A single concrete Athan/prayer notification decision, fully resolved:
/// exact instant, identity, channel, and deep link. Pure data — no plugin
/// calls — so the scheduling chain (API → parse → plan → schedule) can be
/// verified end-to-end in tests.
class PlannedPrayerNotification {
  const PlannedPrayerNotification({
    required this.id,
    required this.moment,
    required this.title,
    required this.body,
    required this.channelId,
    required this.payload,
    required this.withSound,
  });

  final int id;
  final PrayerMoment moment;
  final String title;
  final String body;
  final String channelId;
  final String payload;
  final bool withSound;

  tz.TZDateTime get at => moment.at;
  PrayerName get name => moment.name;
}

/// Builds the exact notification plan from a timetable and user settings.
///
/// Guarantees (covered by tests):
///  * every enabled, still-future prayer appears exactly once per day,
///  * the scheduled instant equals the timetable minute exactly (no
///    rounding, no drift) — "Fajr 04:23 schedules at 04:23",
///  * past prayers are never scheduled,
///  * per-prayer toggles are respected,
///  * notification ids are deterministic per (date, prayer) so rescheduling
///    replaces rather than duplicates,
///  * the sound mode selects the correct channel.
List<PlannedPrayerNotification> planPrayerNotifications({
  required PrayerSchedule schedule,
  required PrayerSettings settings,
  required tz.TZDateTime now,
  required int Function(DateTime day, PrayerName name) idFor,
}) {
  final plans = <PlannedPrayerNotification>[];
  for (final day in schedule.days) {
    for (final moment in day.moments) {
      if (!settings.enabledPrayers.contains(moment.name)) continue;
      if (!moment.at.isAfter(now)) continue;
      final id = idFor(day.gregorianDate, moment.name);
      plans.add(
        PlannedPrayerNotification(
          id: id,
          moment: moment,
          title: 'حان وقت صلاة ${moment.name.arabicLabel}',
          body: 'موعد ${moment.name.arabicLabel} حسب إعدادات موقعك وطريقة الحساب.',
          channelId: _channelId(moment.name, withSound: settings.soundEnabled),
          payload: NotificationService.prayerDeepLink(moment.name),
          withSound: settings.soundEnabled,
        ),
      );
    }
  }
  plans.sort((a, b) => a.at.compareTo(b.at));
  return plans;
}

String _channelId(PrayerName name, {required bool withSound}) {
  final mode = withSound ? 'audio' : 'silent';
  return 'prayer_${mode}_${name.name}_v2';
}

/// Deterministic notification id for a (date, prayer) pair — shared by the
/// planner and the cancel path so rescheduling never duplicates alarms.
int prayerNotificationId(DateTime day, PrayerName name) {
  var hash = 17;
  final key = 'prayer-${day.year}-${day.month}-${day.day}-${name.name}';
  for (final codeUnit in key.codeUnits) {
    hash = (hash * 31 + codeUnit) & 0x7fffffff;
  }
  return 1000 + (hash % 1000000);
}

import 'prayer_enums.dart';

class PrayerNotificationSlot {
  final PrayerType prayer;
  final DateTime scheduledAt;
  final String payload;

  const PrayerNotificationSlot({
    required this.prayer,
    required this.scheduledAt,
    required this.payload,
  });
}

class PrayerNotificationPlan {
  final String timeZoneId;
  final List<PrayerNotificationSlot> slots;

  const PrayerNotificationPlan({
    required this.timeZoneId,
    required this.slots,
  });
}

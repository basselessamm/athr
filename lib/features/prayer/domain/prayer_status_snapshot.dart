import 'prayer_enums.dart';

class PrayerStatusSnapshot {
  final PrayerType currentPrayer;
  final PrayerType nextPrayer;
  final DateTime targetTime;
  final Duration remaining;
  final String headline;
  final String supportingText;

  const PrayerStatusSnapshot({
    required this.currentPrayer,
    required this.nextPrayer,
    required this.targetTime,
    required this.remaining,
    required this.headline,
    required this.supportingText,
  });
}

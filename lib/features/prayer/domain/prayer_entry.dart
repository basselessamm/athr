import 'prayer_enums.dart';

class PrayerEntry {
  final PrayerType type;
  final DateTime time;

  const PrayerEntry({required this.type, required this.time});

  bool get isObligatory => type != PrayerType.sunrise;
}

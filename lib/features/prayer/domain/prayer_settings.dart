import 'prayer_enums.dart';
import 'prayer_location.dart';

class PrayerSettings {
  final PrayerCalculationMethod calculationMethod;
  final PrayerMadhab madhab;
  final PrayerLocationMode locationMode;
  final PrayerTimeFormat timeFormat;
  final bool showSunrise;
  final bool showHijriDate;
  final PrayerLocation? manualLocation;
  final PrayerLocation? cachedAutoLocation;

  const PrayerSettings({
    required this.calculationMethod,
    required this.madhab,
    required this.locationMode,
    required this.timeFormat,
    required this.showSunrise,
    required this.showHijriDate,
    required this.manualLocation,
    required this.cachedAutoLocation,
  });

  factory PrayerSettings.defaults() {
    return const PrayerSettings(
      calculationMethod: PrayerCalculationMethod.ummAlQura,
      madhab: PrayerMadhab.shafi,
      locationMode: PrayerLocationMode.auto,
      timeFormat: PrayerTimeFormat.twelveHour,
      showSunrise: true,
      showHijriDate: true,
      manualLocation: null,
      cachedAutoLocation: null,
    );
  }

  PrayerSettings copyWith({
    PrayerCalculationMethod? calculationMethod,
    PrayerMadhab? madhab,
    PrayerLocationMode? locationMode,
    PrayerTimeFormat? timeFormat,
    bool? showSunrise,
    bool? showHijriDate,
    PrayerLocation? manualLocation,
    PrayerLocation? cachedAutoLocation,
  }) {
    return PrayerSettings(
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      locationMode: locationMode ?? this.locationMode,
      timeFormat: timeFormat ?? this.timeFormat,
      showSunrise: showSunrise ?? this.showSunrise,
      showHijriDate: showHijriDate ?? this.showHijriDate,
      manualLocation: manualLocation ?? this.manualLocation,
      cachedAutoLocation: cachedAutoLocation ?? this.cachedAutoLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calculationMethod': calculationMethod.name,
      'madhab': madhab.name,
      'locationMode': locationMode.name,
      'timeFormat': timeFormat.name,
      'showSunrise': showSunrise,
      'showHijriDate': showHijriDate,
      'manualLocation': manualLocation?.toMap(),
      'cachedAutoLocation': cachedAutoLocation?.toMap(),
    };
  }

  factory PrayerSettings.fromMap(Map<String, dynamic> map) {
    return PrayerSettings(
      calculationMethod: PrayerCalculationMethod.values.firstWhere(
        (value) => value.name == map['calculationMethod'],
        orElse: () => PrayerCalculationMethod.ummAlQura,
      ),
      madhab: PrayerMadhab.values.firstWhere(
        (value) => value.name == map['madhab'],
        orElse: () => PrayerMadhab.shafi,
      ),
      locationMode: PrayerLocationMode.values.firstWhere(
        (value) => value.name == map['locationMode'],
        orElse: () => PrayerLocationMode.auto,
      ),
      timeFormat: PrayerTimeFormat.values.firstWhere(
        (value) => value.name == map['timeFormat'],
        orElse: () => PrayerTimeFormat.twelveHour,
      ),
      showSunrise: map['showSunrise'] as bool? ?? true,
      showHijriDate: map['showHijriDate'] as bool? ?? true,
      manualLocation: map['manualLocation'] is Map<String, dynamic>
          ? PrayerLocation.fromMap(map['manualLocation'] as Map<String, dynamic>)
          : null,
      cachedAutoLocation: map['cachedAutoLocation'] is Map<String, dynamic>
          ? PrayerLocation.fromMap(
              map['cachedAutoLocation'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

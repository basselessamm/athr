enum PrayerCalculationMethod {
  muslimWorldLeague,
  egyptianGeneralAuthority,
  ummAlQura,
  isna,
  karachi,
  dubai,
  qatar,
  kuwait,
  moonsightingCommittee,
}

extension PrayerCalculationMethodX on PrayerCalculationMethod {
  String get label {
    switch (this) {
      case PrayerCalculationMethod.muslimWorldLeague:
        return 'رابطة العالم الإسلامي';
      case PrayerCalculationMethod.egyptianGeneralAuthority:
        return 'الهيئة المصرية العامة';
      case PrayerCalculationMethod.ummAlQura:
        return 'أم القرى';
      case PrayerCalculationMethod.isna:
        return 'ISNA';
      case PrayerCalculationMethod.karachi:
        return 'كراتشي';
      case PrayerCalculationMethod.dubai:
        return 'دبي';
      case PrayerCalculationMethod.qatar:
        return 'قطر';
      case PrayerCalculationMethod.kuwait:
        return 'الكويت';
      case PrayerCalculationMethod.moonsightingCommittee:
        return 'Moonsighting';
    }
  }
}

enum PrayerMadhab { shafi, hanafi }

extension PrayerMadhabX on PrayerMadhab {
  String get label {
    switch (this) {
      case PrayerMadhab.shafi:
        return 'شافعي';
      case PrayerMadhab.hanafi:
        return 'حنفي';
    }
  }
}

enum PrayerLocationMode { auto, manual }

extension PrayerLocationModeX on PrayerLocationMode {
  String get label {
    switch (this) {
      case PrayerLocationMode.auto:
        return 'تلقائي';
      case PrayerLocationMode.manual:
        return 'يدوي';
    }
  }
}

enum PrayerTimeFormat { twentyFourHour, twelveHour }

extension PrayerTimeFormatX on PrayerTimeFormat {
  String get label {
    switch (this) {
      case PrayerTimeFormat.twentyFourHour:
        return '24 ساعة';
      case PrayerTimeFormat.twelveHour:
        return '12 ساعة';
    }
  }
}

enum PrayerType { fajr, sunrise, dhuhr, asr, maghrib, isha }

extension PrayerTypeX on PrayerType {
  String get label {
    switch (this) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.sunrise:
        return 'الشروق';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
    }
  }
}

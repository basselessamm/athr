import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athr/features/prayer/domain/prayer_enums.dart';
import 'package:athr/features/prayer/domain/prayer_location.dart';
import 'package:athr/features/prayer/providers/prayer_providers.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

void main() {
  group('prayerSettingsProvider', () {
    test('persists calculation, format, and manual location settings', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(prayerSettingsProvider.notifier);

      notifier.setCalculationMethod(PrayerCalculationMethod.karachi);
      notifier.setMadhab(PrayerMadhab.hanafi);
      notifier.setTimeFormat(PrayerTimeFormat.twelveHour);
      notifier.saveManualLocation(
        const PrayerLocation(
          latitude: 51.5072,
          longitude: -0.1276,
          timeZoneId: 'Europe/London',
          label: 'لندن',
        ),
      );
      notifier.setLocationMode(PrayerLocationMode.manual);

      final reloadedContainer = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(reloadedContainer.dispose);

      final reloaded = reloadedContainer.read(prayerSettingsProvider);

      expect(reloaded.calculationMethod, PrayerCalculationMethod.karachi);
      expect(reloaded.madhab, PrayerMadhab.hanafi);
      expect(reloaded.timeFormat, PrayerTimeFormat.twelveHour);
      expect(reloaded.locationMode, PrayerLocationMode.manual);
      expect(reloaded.manualLocation, isNotNull);
      expect(reloaded.manualLocation!.timeZoneId, 'Europe/London');
      expect(reloaded.manualLocation!.displayLabel, 'لندن');
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athr/features/prayer/application/prayer_times.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

void main() {
  ProviderContainer containerFor(SharedPreferences preferences) {
    return ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
  }

  test(
    'uses cached prayer location without requiring a fresh GPS request',
    () async {
      SharedPreferences.setMockInitialValues({
        'prayer_last_latitude': 30.0444,
        'prayer_last_longitude': 31.2357,
        'prayer_last_accuracy': 42.0,
      });
      final preferences = await SharedPreferences.getInstance();
      final repository = PrayerTimesRepository(http.Client(), preferences);

      final location = repository.cachedLocation();

      expect(location?.latitude, 30.0444);
      expect(location?.longitude, 31.2357);
      expect(location?.accuracy, 42.0);
    },
  );

  test(
    'returns an actionable state before user requests GPS on a fresh install',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final container = containerFor(preferences);
      addTearDown(container.dispose);

      await expectLater(
        container.read(prayerLocationProvider.future),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            'حدّد موقعك لعرض مواقيت الصلاة الدقيقة.',
          ),
        ),
      );
    },
  );
}

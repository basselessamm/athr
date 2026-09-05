import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:midrar/features/quran/providers/bookmark_provider.dart';
import 'package:midrar/features/settings/providers/azkar_wird_settings_provider.dart';
import 'package:midrar/features/settings/providers/settings_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer containerFor(SharedPreferences preferences) {
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
  }

  group('Quran Bookmark & Last Read Synchronization', () {
    test('saving bookmark and recording progress updates both providers consistently', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final container = containerFor(preferences);
      addTearDown(container.dispose);

      // Initially null
      expect(container.read(bookmarkProvider), isNull);
      expect(container.read(lastReadProvider), isNull);

      // Save a bookmark for Surah Al-Baqarah (2), Ayah 255 (Ayat al-Kursi), Page 42
      await container.read(bookmarkProvider.notifier).saveBookmark(
            surah: 2,
            ayah: 255,
            pageNumber: 42,
          );
      await container.read(lastReadProvider.notifier).recordProgress(
            surah: 2,
            ayah: 255,
            pageNumber: 42,
          );

      final bookmark = container.read(bookmarkProvider);
      final lastRead = container.read(lastReadProvider);

      expect(bookmark?.surah, 2);
      expect(bookmark?.ayah, 255);
      expect(bookmark?.pageNumber, 42);

      expect(lastRead?.surah, 2);
      expect(lastRead?.ayah, 255);
      expect(lastRead?.pageNumber, 42);

      // Rehydrate in a new container to verify persistence
      final rehydrated = containerFor(preferences);
      addTearDown(rehydrated.dispose);

      expect(rehydrated.read(bookmarkProvider)?.surah, 2);
      expect(rehydrated.read(bookmarkProvider)?.ayah, 255);
      expect(rehydrated.read(lastReadProvider)?.surah, 2);
      expect(rehydrated.read(lastReadProvider)?.ayah, 255);
    });
  });

  group('Azkar and Wird Notification Settings', () {
    test('loads default values and persists customized times and states', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final container = containerFor(preferences);
      addTearDown(container.dispose);

      final defaults = container.read(azkarWirdSettingsProvider);
      expect(defaults.morningEnabled, isTrue);
      expect(defaults.morningHour, 7);
      expect(defaults.morningMinute, 0);

      expect(defaults.eveningEnabled, isTrue);
      expect(defaults.eveningHour, 17);
      expect(defaults.eveningMinute, 0);

      expect(defaults.sleepEnabled, isTrue);
      expect(defaults.sleepHour, 22);
      expect(defaults.sleepMinute, 30);

      expect(defaults.wirdEnabled, isTrue);
      expect(defaults.wirdHour, 21);
      expect(defaults.wirdMinute, 0);

      // Modify settings
      await container.read(azkarWirdSettingsProvider.notifier).setMorning(
            enabled: true,
            hour: 6,
            minute: 30,
          );
      await container.read(azkarWirdSettingsProvider.notifier).setWird(
            enabled: true,
            hour: 20,
            minute: 45,
          );

      final updated = container.read(azkarWirdSettingsProvider);
      expect(updated.morningHour, 6);
      expect(updated.morningMinute, 30);
      expect(updated.wirdHour, 20);
      expect(updated.wirdMinute, 45);

      // Rehydrate
      final rehydrated = containerFor(preferences);
      addTearDown(rehydrated.dispose);

      final persisted = rehydrated.read(azkarWirdSettingsProvider);
      expect(persisted.morningHour, 6);
      expect(persisted.morningMinute, 30);
      expect(persisted.wirdHour, 20);
      expect(persisted.wirdMinute, 45);
    });
  });
}

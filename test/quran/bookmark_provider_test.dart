import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athr/features/quran/providers/bookmark_provider.dart';
import 'package:athr/features/settings/providers/settings_providers.dart';

void main() {
  ProviderContainer containerFor(SharedPreferences preferences) {
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
  }

  test('upgrades a legacy surah-only bookmark to a safe first-ayah anchor', () async {
    SharedPreferences.setMockInitialValues({
      'quran_bookmark_surah': 36,
      'quran_bookmark_offset': 18.25,
    });
    final preferences = await SharedPreferences.getInstance();
    final container = containerFor(preferences);
    addTearDown(container.dispose);

    final bookmark = container.read(bookmarkProvider);
    expect(bookmark?.surah, 36);
    expect(bookmark?.ayah, 1);
    expect(bookmark?.pageNumber, isNull);
  });

  test('persists an exact Quran reading anchor and restores it', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final firstContainer = containerFor(preferences);
    addTearDown(firstContainer.dispose);

    await firstContainer
        .read(bookmarkProvider.notifier)
        .saveBookmark(surah: 67, ayah: 3, pageNumber: 562);

    expect(firstContainer.read(bookmarkProvider)?.surah, 67);
    expect(firstContainer.read(bookmarkProvider)?.ayah, 3);
    expect(firstContainer.read(bookmarkProvider)?.pageNumber, 562);

    final rehydratedContainer = containerFor(preferences);
    addTearDown(rehydratedContainer.dispose);
    final restored = rehydratedContainer.read(bookmarkProvider);

    expect(restored?.surah, 67);
    expect(restored?.ayah, 3);
    expect(restored?.pageNumber, 562);
  });
}

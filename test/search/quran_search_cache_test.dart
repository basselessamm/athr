import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/features/search/providers/search_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Quran Search Pre-normalized Cache', () {
    setUp(() {
      clearQuranVerseCacheForTest();
    });

    test('getOrCreateQuranVerseCache builds cache of 6236 verses with normalized text', () async {
      final cache = await getOrCreateQuranVerseCache();
      expect(cache, hasLength(6236));

      // Surah Al-Fatihah, Ayah 1 (Bismillah)
      expect(cache.first.surah, 1);
      expect(cache.first.ayah, 1);
      expect(cache.first.normalizedText, isNotEmpty);
      expect(cache.first.normalizedText, contains('بسم الله'));

      // Surah An-Nas, Ayah 6 (Last Ayah)
      expect(cache.last.surah, 114);
      expect(cache.last.ayah, 6);
      expect(cache.last.normalizedText, isNotEmpty);
    });

    test('Cache is persistent and reused on second call without re-allocating', () async {
      final firstCall = await getOrCreateQuranVerseCache();
      final secondCall = await getOrCreateQuranVerseCache();
      expect(identical(firstCall, secondCall), isTrue);
    });

    test('Search finds matches rapidly across cached verses', () async {
      final cache = await getOrCreateQuranVerseCache();
      final matches = cache.where(
        (v) => v.normalizedText.contains('اهدنا الصراط المستقيم'),
      );
      expect(matches, hasLength(1));
      expect(matches.first.surah, 1);
      expect(matches.first.ayah, 6);
    });
  });
}

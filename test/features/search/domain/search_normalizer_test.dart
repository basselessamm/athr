import 'package:flutter_test/flutter_test.dart';
import 'package:athr/features/search/domain/search_normalizer.dart';

void main() {
  group('SearchNormalizer Tests', () {
    test('Rule 1: Remove Tashkeel', () {
      expect(SearchNormalizer.normalize('بِسْمِ اللَّهِ'), 'بسم الله');
      expect(
        SearchNormalizer.normalize('الرَّحْمَٰنِ'),
        'الرحمن',
      ); // superscript alef removed
    });

    test('Rule 2: Remove Tatweel', () {
      expect(SearchNormalizer.normalize('بــــســــم'), 'بسم');
    });

    test('Rule 3: Remove Punctuation', () {
      expect(
        SearchNormalizer.normalize('قال: "مرحبا" يا صديقي!'),
        'قال مرحبا يا صديقي',
      );
      expect(SearchNormalizer.normalize('a.b,c?d!e;f:g'), 'a b c d e f g');
    });

    test('Rule 4: Normalize Alef variants', () {
      expect(
        SearchNormalizer.normalize('أحمد وإبراهيم آكلوا ٱلتفاح'),
        'احمد وابراهيم اكلوا التفاح',
      );
    });

    test('Rule 5: Normalize Hamza variants', () {
      expect(SearchNormalizer.normalize('مؤمن ومسائل'), 'مءمن ومساءل');
    });

    test('Rule 6: Normalize Yaa and Alif Maqsura', () {
      expect(
        SearchNormalizer.normalize('موسى وعيسى ويحيى'),
        'موسي وعيسي ويحيي',
      );
    });

    test('Rule 7: Normalize Taa Marbutah and Haa', () {
      expect(SearchNormalizer.normalize('مدرسة و مكتبة'), 'مدرسه و مكتبه');
    });

    test('Rule 8: Convert Arabic Numerals to English Numerals', () {
      expect(SearchNormalizer.normalize('١٢٣٤٥٦٧٨٩٠'), '1234567890');
    });

    test('Rule 9: Collapse Duplicated Spaces', () {
      expect(
        SearchNormalizer.normalize('هذا    نص   به   فراغات'),
        'هذا نص به فراغات',
      );
    });

    test('Comprehensive Query', () {
      final query = 'يَا أَيُّهَا الَّذِينَ آمَنُوا... ١٢٣';
      final expected = 'يا ايها الذين امنوا 123';
      expect(SearchNormalizer.normalize(query), expected);
    });
  });
}

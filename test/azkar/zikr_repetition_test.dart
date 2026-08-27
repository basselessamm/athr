import 'package:flutter_test/flutter_test.dart';

import 'package:midrar/features/azkar/application/zikr_repetition.dart';

void main() {
  group('explicit counts (real corpus annotations)', () {
    test('basic parenthesised counts', () {
      expect(parseZikrRepetition('سبحان الله ( ثلاث مرات )').target, 3);
      expect(parseZikrRepetition('الحمد لله ( اربع مرات )').target, 4);
      expect(parseZikrRepetition('الله أكبر ( سبع مرات )').target, 7);
      expect(parseZikrRepetition('لا إله إلا الله ( عشر مرات )').target, 10);
      expect(parseZikrRepetition('سبحان الله وبحمده ( مائة مرة )').target, 100);
      expect(parseZikrRepetition('سبحان الله ( 100 مرة )').target, 100);
    });

    test('diacritised annotations still parse', () {
      expect(
        parseZikrRepetition('سُبْحَانَ اللهِ ( مِائَةُ مَرَّةٍ )').target,
        100,
        reason: 'diacritics inside the annotation must not block the count',
      );
    });

    test('time-qualified annotations keep the count AND the raw label', () {
      final morning = parseZikrRepetition(
        'لا إله إلا الله وحده لا شريك له ( مائة مرة إذا أصبح )',
      );
      expect(morning.target, 100);
      expect(morning.marker, ZikrTimeMarker.morning);
      expect(morning.label, 'مائة مرة إذا أصبح');

      final evening = parseZikrRepetition(
        'أعوذ بكلمات الله التامات ( ثلاث مرات إذا أمسى )',
      );
      expect(evening.target, 3);
      expect(evening.marker, ZikrTimeMarker.evening);

      final daily = parseZikrRepetition('أستغفر الله ( مائة مرة في اليوم )');
      expect(daily.target, 100);
      expect(daily.marker, isNull, reason: 'في اليوم is valid at both times');
    });
  });

  group('conservative guarantees (never invent a count)', () {
    test('prose without annotation stays unspecified', () {
      final result = parseZikrRepetition('من قال هذا الكلام ثلاث مرات في يومه');
      expect(result.isExplicitInText, isFalse);
      expect(result.target, 1);
    });

    test('alternatives are not prescriptions', () {
      final result = parseZikrRepetition('( أو مرة واحدة عند الكسل )');
      expect(result.isExplicitInText, isFalse);
      expect(result.label, contains('مرة واحدة'));
    });

    test('non-count annotations do not create targets', () {
      expect(parseZikrRepetition('( عند النوم )').isExplicitInText, isFalse);
    });
  });

  group('time markers from body text', () {
    test('morning wording', () {
      final result = parseZikrRepetition('اللهم إني أصبحت أشهدك');
      expect(result.marker, ZikrTimeMarker.morning);
    });

    test('evening wording', () {
      final result = parseZikrRepetition('اللهم إني أمسيت أشهدك');
      expect(result.marker, ZikrTimeMarker.evening);
    });

    test('both times mentioned → no marker (valid at both)', () {
      expect(
        parseZikrRepetition('إذا أصبح قال كذا وإذا أمسى قال كذا').marker,
        isNull,
      );
    });

    test('annotation marker wins over nothing, body marker fills the gap', () {
      final result = parseZikrRepetition(
        'ذكرٌ عام ( ثلاث مرات إذا أصبح )',
      );
      expect(result.marker, ZikrTimeMarker.morning);
    });
  });
}

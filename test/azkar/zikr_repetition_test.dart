import 'package:flutter_test/flutter_test.dart';

import 'package:athr/features/azkar/application/zikr_repetition.dart';

void main() {
  test(
    'recognises an explicit parenthesised repetition count from stored text',
    () {
      final repetition = repetitionFromStoredText(
        'أسأل الله العظيم رب العرش العظيم أن يشفيك ( سبع مرات )',
      );

      expect(repetition.isExplicitInText, isTrue);
      expect(repetition.target, 7);
    },
  );

  test('does not infer a target from descriptive prose', () {
    final repetition = repetitionFromStoredText(
      'ذكر المصدر أن هذا الدعاء يقال ثلاث مرات في بعض المواضع.',
    );

    expect(repetition.isExplicitInText, isFalse);
    expect(repetition.target, 1);
  });

  test('normalises Arabic diacritics when checking explicit source text', () {
    final repetition = repetitionFromStoredText('الدعاء ( مِائَةُ مَرَّةٍ )');

    expect(repetition.isExplicitInText, isTrue);
    expect(repetition.target, 100);
  });
}

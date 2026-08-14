/// A conservative presentation helper for azkar whose data model has no
/// structured repetition field. It recognises only an explicitly parenthesised
/// count in the stored source text and otherwise returns no prescribed target.
///
/// This never changes the text or a source citation; it prevents the UI from
/// silently guessing a religious count from descriptive prose.
class ZikrRepetition {
  const ZikrRepetition.explicit(this.target) : isExplicitInText = true;

  const ZikrRepetition.unspecified() : target = 1, isExplicitInText = false;

  final int target;
  final bool isExplicitInText;
}

ZikrRepetition repetitionFromStoredText(String text) {
  final normalized = _normalize(text);
  final explicitPatterns = <RegExp, int>{
    RegExp(r'\(\s*ثلاث\s+مرات\s*\)'): 3,
    RegExp(r'\(\s*اربع\s+مرات\s*\)'): 4,
    RegExp(r'\(\s*سبع\s+مرات\s*\)'): 7,
    RegExp(r'\(\s*عشر\s+مرات\s*\)'): 10,
    RegExp(r'\(\s*مائة\s+مرة\s*\)'): 100,
    RegExp(r'\(\s*100\s+مرة\s*\)'): 100,
    RegExp(r'\(\s*10\s+مرات\s*\)'): 10,
    RegExp(r'\(\s*7\s+مرات\s*\)'): 7,
    RegExp(r'\(\s*4\s+مرات\s*\)'): 4,
    RegExp(r'\(\s*3\s+مرات\s*\)'): 3,
  };

  for (final entry in explicitPatterns.entries) {
    if (entry.key.hasMatch(normalized)) {
      return ZikrRepetition.explicit(entry.value);
    }
  }
  return const ZikrRepetition.unspecified();
}

String _normalize(String value) {
  return value
      .replaceAll(RegExp(r'[أإآ]'), 'ا')
      .replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

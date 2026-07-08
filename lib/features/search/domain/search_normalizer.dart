class SearchNormalizer {
  /// Normalizes Arabic text for robust search matching.
  ///
  /// Rules applied:
  /// 1. Remove Tashkeel (diacritics).
  /// 2. Remove Tatweel (Kashida).
  /// 3. Remove punctuation.
  /// 4. Normalize Alef variants to bare Alef (ا).
  /// 5. Normalize Hamza variants to bare Hamza (ء).
  /// 6. Normalize Yaa / Alif Maqsura to Yaa (ي).
  /// 7. Normalize Taa Marbutah / Haa to Haa (ه).
  /// 8. Convert Arabic numerals to English numerals.
  /// 9. Collapse duplicated spaces.
  static String normalize(String text) {
    if (text.isEmpty) return text;

    String normalized = text;

    // 1. Remove Tashkeel
    // \u064B-\u065F: standard diacritics
    // \u0670: superscript alef
    // \u0656: subscript alef
    // \u065C: vowel sign dot below
    normalized = normalized.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670\u0656\u065C]'),
      '',
    );

    // 2. Remove Tatweel (ـ)
    normalized = normalized.replaceAll('\u0640', '');

    // 3. Remove punctuation
    normalized = normalized.replaceAll(
      RegExp(r'[!@#\$%\^&\*\(\)_\+\-\=\[\]\{\};:"\\|,.<>\/?~`،؛؟«»]'),
      ' ',
    );

    // 4. Normalize Alef variants
    normalized = normalized.replaceAll(RegExp(r'[إأآٱ]'), 'ا');

    // 5. Normalize Hamza variants
    normalized = normalized.replaceAll(RegExp(r'[ؤئ]'), 'ء');

    // 6. Normalize Yaa and Alef Maqsura
    normalized = normalized.replaceAll(RegExp(r'[ىي]'), 'ي');

    // 7. Normalize Taa Marbutah and Haa
    normalized = normalized.replaceAll(RegExp(r'[ةه]'), 'ه');

    // 8. Convert Arabic numerals to English numerals
    const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < arabicNumerals.length; i++) {
      normalized = normalized.replaceAll(arabicNumerals[i], i.toString());
    }

    // 9. Collapse duplicated spaces and trim
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();

    return normalized.toLowerCase(); // Lowercase for English consistency
  }
}

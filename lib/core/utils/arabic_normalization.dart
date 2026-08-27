/// Shared Arabic text normalization used by search indexing and querying.
///
/// The normalizer is intentionally conservative: it removes diacritics and
/// unifies common orthographic variants so that fully-vocalized corpora
/// (hadith, azkar) can be searched with plain typed queries without
/// corrupting the original displayed text.
library;

const String _harakatPattern =
    '\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u08F0-\u08F3';

const String _punctuationPattern =
    r'[\u060C\u061B\u061F\u066A-\u066D\u06D4,;:!?.()\[\]{}"\-_%«»]';

String normalizeArabic(String input) {
  var out = input;
  // Strip harakat, small Quranic annotation marks, and elongation marks.
  out = out.replaceAll(RegExp('[$_harakatPattern]'), '');
  // Remove tatweel.
  out = out.replaceAll('\u0640', '');
  // Unify alef variants (bare alef, hamza forms, alef wasla).
  out = out.replaceAll(RegExp('[\u0623\u0625\u0622\u0713\u0714\u0671]'), '\u0627');
  // Unify teh marbuta with heh, and alef maksura with ya.
  out = out.replaceAll('\u0629', '\u0647');
  out = out.replaceAll('\u0649', '\u064A');
  // Unify hamza carriers used mid-word.
  out = out.replaceAll('\u0624', '\u0648');
  out = out.replaceAll('\u0626', '\u064A');
  // Persian/Urdu keyboard variants common among Muslim users.
  out = out.replaceAll('\u06CC', '\u064A'); // farsi yeh -> arabic yeh
  out = out.replaceAll('\u0643', '\u06A9'); // keep? no: unify keheh to kaf
  out = out.replaceAll('\u06A9', '\u0643'); // farsi keheh -> arabic kaf
  out = out.replaceAll('\u06AA', '\u0643');
  out = out.replaceAll('\u06C1', '\u0647'); // heh goal -> heh
  out = out.replaceAll('\u06D2', '\u064A'); // barree yeh -> yeh
  // Normalize Arabic comma/semicolon/question marks plus Latin punctuation
  // so partial phrases match across corpora.
  out = out.replaceAll(
    RegExp('[\u060C\u061B\u061F]'),
    ' ',
  );
  out = out.replaceAll(RegExp(_punctuationPattern), ' ');
  out = out.replaceAll(RegExp(r'\s+'), ' ').trim();
  return out;
}

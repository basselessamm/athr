import 'surah_verses.dart';

/// Model representing verses of a Surah within a Juz.
class JuzSurahVerses extends SurahVerses {
  JuzSurahVerses({
    required super.surahNumber,
    required super.startVerseNumber,
    required super.endVerseNumber,
    required super.verses,
    required super.verseCount,
  });
}

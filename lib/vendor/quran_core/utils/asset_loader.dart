import 'package:flutter/services.dart' show rootBundle;

import 'package:midrar/vendor/quran_core/models/verse.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

/// A class responsible for loading assets and parsing Quran text files.
///
/// Vendored from quran_flutter 1.0.3 (MIT, © Waqar Ali Siyal) — see
/// LICENSES/quran_flutter-MIT. Midrar changes: the multi-language translation
/// corpus was removed entirely (the app is Arabic-only); this both avoids
/// bundling ~12 MB of unused translation assets and eliminates an eager
/// ~40 MB text parse during [Quran.initialize].
class AssetLoader {
  /// Loads an asset file from the given [path].
  static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  /// Loads the Quran text (Uthmani rasm, Tanzil) from the bundled asset.
  /// Returns a map containing the verses of each Surah, where the key is the
  /// Surah number and the value is another map containing the verses of that
  /// Surah, where the key is the verse number and the value is a Verse object.
  static Future<Map<int, Map<int, Verse>>> loadQuranText() async {
    String fileContent = await loadAsset('assets/quran/quran.txt');

    // Split the file content into individual lines.
    List<String> lines = fileContent.split('\n');

    // Initialize a map to store the Quran text.
    Map<int, Map<int, Verse>> quranText = {};

    // Iterate through each line of the file.
    for (String line in lines) {
      // Split each line into parts: surah number, verse number, and verse text.
      List<String> parts = line.split('|');
      int surahNumber = int.parse(parts[0]);
      int verseNumber = int.parse(parts[1]);
      String verseText = parts[2];

      // Check if the surah already exists in the map.
      if (quranText.containsKey(surahNumber)) {
        // If the surah exists, add the verse to the existing map.
        quranText[surahNumber]![verseNumber] = Verse(
          surahNumber: surahNumber,
          verseNumber: verseNumber,
          text: verseText,
        );
      } else {
        // If the surah does not exist, create a new map for the surah and add
        // the verse.
        quranText[surahNumber] = {
          verseNumber: Verse(
            surahNumber: surahNumber,
            verseNumber: verseNumber,
            // Remove the Bismillah from the verse text if it's not the first
            // verse of Surah Al-Fatiha.
            text: surahNumber == 1
                ? verseText
                : verseText.replaceFirst(
                    Quran.bismillah,
                    '',
                  ),
          )
        };
      }
    }

    return quranText;
  }
}

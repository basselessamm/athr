import 'package:flutter_test/flutter_test.dart';
import 'package:quran_flutter/quran.dart';

import 'package:athr/features/quran/application/quran_audio.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exposes ten unique external Quran reciters', () {
    expect(quranReciters, hasLength(10));
    expect(quranReciters.map((reciter) => reciter.id).toSet(), hasLength(10));
    expect(
      quranReciters.every((reciter) => reciter.id.startsWith('ar.')),
      isTrue,
    );
  });

  test(
    'builds an external CDN URL for the selected reciter and global ayah',
    () {
      final repository = QuranAudioRepository();
      final reciter = quranReciters.firstWhere(
        (item) => item.id == 'ar.abdurrahmaansudais',
      );

      final uri = repository.ayahStream(reciter: reciter, globalAyah: 8);

      expect(uri.scheme, 'https');
      expect(uri.host, 'cdn.islamic.network');
      expect(uri.path, '/quran/audio/192/ar.abdurrahmaansudais/8.mp3');
    },
  );

  test(
    'calculates the global ayah number from a surah-relative ayah',
    () async {
      await Quran.initialize();
      final repository = QuranAudioRepository();

      expect(repository.globalAyahNumber(surah: 1, ayah: 1), 1);
      expect(repository.globalAyahNumber(surah: 2, ayah: 1), 8);
    },
  );
}

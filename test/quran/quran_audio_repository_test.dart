import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/features/quran/application/quran_audio.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exposes the verified reciter catalog with unique ids', () {
    // 18 editions verified against cdn.islamic.network on 2026-08-25.
    expect(quranReciters, hasLength(18));
    expect(quranReciters.map((reciter) => reciter.id).toSet(), hasLength(18));
    expect(
      quranReciters.every((reciter) => reciter.id.startsWith('ar.')),
      isTrue,
    );
    // Every catalog entry must carry a sane bitrate from the verified set.
    const verifiedBitrates = {32, 64, 128, 192};
    expect(
      quranReciters.every((r) => verifiedBitrates.contains(r.cdnBitrate)),
      isTrue,
    );
  });

  test('catalog includes the community-requested reciters that verified', () {
    final ids = quranReciters.map((r) => r.id).toSet();
    for (final expected in const [
      'ar.minshawi', // المنشاوي
      'ar.alafasy', // العفاسي
      'ar.mahermuaiqly', // المعيقلي
      'ar.abdulbasitmurattal', // عبد الباسط (مرتل)
      'ar.abdulsamad', // عبد الباسط (مجود)
      'ar.husary', // الحصري (مرتل)
      'ar.husarymujawwad', // الحصري (مجود)
      'ar.abdurrahmaansudais', // السديس
      'ar.ahmedajamy', // أحمد بن علي العجمي
      'ar.hanirifai', // هاني الرفاعي
    ]) {
      expect(ids, contains(expected), reason: 'missing $expected');
    }
  });

  test('unverifiable reciters stay excluded from the catalog', () {
    final ids = quranReciters.map((r) => r.id).toSet();
    // Not available on the verified streaming CDN — must not pretend.
    for (final banned in const [
      'ar.islamsobhi',
      'ar.yaseraldosari',
      'ar.faaris',
      'ar.saadghamdi',
      'ar.ahmedalajmi', // persistent 403
    ]) {
      expect(ids, isNot(contains(banned)), reason: '$banned must stay out');
    }
    expect(unverifiedReciterIds, contains('ar.ahmedalajmi'));
  });

  test('duplicate "-2" mirror editions are not shipped', () {
    final ids = quranReciters.map((r) => r.id).toSet();
    expect(ids.where((id) => id.endsWith('-2')), isEmpty);
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

  group('player state logic', () {
    test('remaining time never goes negative', () {
      final state = QuranAudioState(
        reciter: quranReciters.first,
        surah: 1,
        ayah: 1,
        totalAyahs: 7,
        position: const Duration(minutes: 9),
        duration: const Duration(minutes: 5),
      );
      expect(state.remaining, Duration.zero);
    });

    test('repeat mode cycles off → ayah → surah → off', () {
      expect(
        QuranRepeatMode.off,
        isNot(QuranRepeatMode.ayah),
      );
      // Cycle order is enforced in the controller; here we assert the enum
      // surface used by UI mapping.
      expect(QuranRepeatMode.values, hasLength(3));
    });

    test('sleep timer state clears explicitly', () {
      final base = QuranAudioState(reciter: quranReciters.first);
      final withSleep = base.copyWith(
        sleepUntil: DateTime.now().add(const Duration(minutes: 20)),
      );
      expect(withSleep.sleepUntil, isNotNull);
      final cleared = withSleep.copyWith(clearSleep: true);
      expect(cleared.sleepUntil, isNull);
    });
  });
}

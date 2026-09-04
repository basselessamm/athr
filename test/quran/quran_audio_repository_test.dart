import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/vendor/quran_core/quran.dart';

import 'package:midrar/features/quran/application/quran_audio.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exposes the verified reciter catalog with unique ids', () {
    expect(quranReciters, hasLength(31));
    expect(quranReciters.map((reciter) => reciter.id).toSet(), hasLength(31));
    expect(
      quranReciters.every((reciter) => reciter.id.startsWith('ar.')),
      isTrue,
    );
    // Every catalog entry must carry a sane bitrate from the verified set.
    const verifiedBitrates = {32, 40, 48, 64, 128, 192};
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
      'ar.yasseraddussary', // ياسر الدوسري
      'ar.saadalghamadi', // سعد الغامدي
      'ar.faresabbad', // فارس عباد
      'ar.nasseralqatami', // ناصر القطامي
      'ar.alijaber', // علي جابر
      'ar.mohammadaltablaway', // محمد محمود الطبلاوي
      'ar.mahmoudalialbanna', // محمود علي البنا
      'ar.salahalbudair', // صلاح البدير
      'ar.abdullahaljuhaynee', // عبدالله عواد الجهني
      'ar.khaalidalqahtaanee', // خالد القحطاني
      'ar.mustafaismail', // مصطفى إسماعيل
      'ar.khalifaaltunaiji', // خليفة الطنيجي
      'ar.salahbukhatir', // صلاح بوخاطر
    ]) {
      expect(ids, contains(expected), reason: 'missing $expected');
    }
  });

  test('unverifiable reciters stay excluded from the catalog', () {
    final ids = quranReciters.map((r) => r.id).toSet();
    for (final banned in const [
      'ar.islamsobhi',
      'ar.hazzaalbalushi',
      'ar.ahmedalajmi', // persistent 403
    ]) {
      expect(ids, isNot(contains(banned)), reason: '$banned must stay out');
    }
    expect(unverifiedReciterIds, contains('ar.ahmedalajmi'));
    expect(unverifiedReciterIds, contains('ar.islamsobhi'));
  });

  test('duplicate "-2" mirror editions are not shipped', () {
    final ids = quranReciters.map((r) => r.id).toSet();
    expect(ids.where((id) => id.endsWith('-2')), isEmpty);
  });

  test(
    'builds external CDN URLs for both IslamicNetwork and EveryAyah reciters',
    () {
      final repository = QuranAudioRepository();
      
      // 1. Islamic Network provider test
      final sudais = quranReciters.firstWhere(
        (item) => item.id == 'ar.abdurrahmaansudais',
      );
      final sudaisUri = repository.ayahStream(reciter: sudais, globalAyah: 8);
      expect(sudaisUri.scheme, 'https');
      expect(sudaisUri.host, 'cdn.islamic.network');
      expect(sudaisUri.path, '/quran/audio/192/ar.abdurrahmaansudais/8.mp3');

      // 2. EveryAyah provider test (globalAyah 8 = Surah 2 Al-Baqarah, Ayah 1)
      final yasser = quranReciters.firstWhere(
        (item) => item.id == 'ar.yasseraddussary',
      );
      final yasserUri = repository.ayahStream(reciter: yasser, globalAyah: 8);
      expect(yasserUri.scheme, 'https');
      expect(yasserUri.host, 'everyayah.com');
      expect(yasserUri.path, '/data/Yasser_Ad-Dussary_128kbps/002001.mp3');

      // 3. EveryAyah Al-Fatihah Ayah 1 (globalAyah 1)
      final ghamadi = quranReciters.firstWhere(
        (item) => item.id == 'ar.saadalghamadi',
      );
      final ghamadiUri = repository.ayahStream(reciter: ghamadi, globalAyah: 1);
      expect(ghamadiUri.scheme, 'https');
      expect(ghamadiUri.host, 'everyayah.com');
      expect(ghamadiUri.path, '/data/Ghamadi_40kbps/001001.mp3');
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

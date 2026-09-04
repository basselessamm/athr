/// Midrar's recitation catalog — PURE DART (no Flutter dependencies) so the
/// same source of truth powers the app and the `tool/verify_audio_catalog.dart`
/// health check.
///
/// Every entry was verified against cdn.islamic.network on 2026-08-25 with
/// HTTP Range probes across first/mid/last ayahs of the muṣḥaf
/// (see docs/AUDIO_VERIFICATION_REPORT.md). Audio is ALWAYS streamed through
/// the CDN; listened ayahs are transparently cached on device, never bundled
/// in the APK.
library;

enum ReciterProvider {
  islamicNetwork,
  everyAyah,
}

class QuranReciter {
  const QuranReciter({
    required this.id,
    required this.name,
    required this.cdnBitrate,
    this.style,
    this.provider = ReciterProvider.islamicNetwork,
    this.folderName,
  });

  final String id;
  final String name;
  final int cdnBitrate;

  /// Recitation style when the reciter has distinct murattal/mujawwad sets.
  final String? style;

  final ReciterProvider provider;
  final String? folderName;

  String get displayName => style == null ? name : '$name · $style';
}

const quranReciters = <QuranReciter>[
  QuranReciter(id: 'ar.alafasy', name: 'مشاري راشد العفاسي', cdnBitrate: 128),
  QuranReciter(
    id: 'ar.abdulbasitmurattal',
    name: 'عبد الباسط عبد الصمد',
    style: 'مرتل',
    cdnBitrate: 192,
  ),
  QuranReciter(
    id: 'ar.abdulsamad',
    name: 'عبد الباسط عبد الصمد',
    style: 'مجود',
    cdnBitrate: 64,
  ),
  QuranReciter(
    id: 'ar.minshawi',
    name: 'محمد صديق المنشاوي',
    style: 'مرتل',
    cdnBitrate: 128,
  ),
  QuranReciter(
    id: 'ar.husary',
    name: 'محمود خليل الحصري',
    style: 'مرتل',
    cdnBitrate: 128,
  ),
  QuranReciter(
    id: 'ar.husarymujawwad',
    name: 'محمود خليل الحصري',
    style: 'مجود',
    cdnBitrate: 128,
  ),
  QuranReciter(id: 'ar.mahermuaiqly', name: 'ماهر المعيقلي', cdnBitrate: 128),
  QuranReciter(id: 'ar.saoodshuraym', name: 'سعود الشريم', cdnBitrate: 64),
  QuranReciter(
    id: 'ar.abdurrahmaansudais',
    name: 'عبد الرحمن السديس',
    cdnBitrate: 192,
  ),
  QuranReciter(id: 'ar.shaatree', name: 'أبو بكر الشاطري', cdnBitrate: 128),
  QuranReciter(
    id: 'ar.ahmedajamy',
    name: 'أحمد بن علي العجمي',
    cdnBitrate: 128,
  ),
  QuranReciter(id: 'ar.hanirifai', name: 'هاني الرفاعي', cdnBitrate: 192),
  QuranReciter(
    id: 'ar.hudhaify',
    name: 'علي بن عبدالرحمن الحذيفي',
    cdnBitrate: 128,
  ),
  QuranReciter(id: 'ar.abdullahbasfar', name: 'عبد الله بصفر', cdnBitrate: 192),
  QuranReciter(id: 'ar.muhammadayyoub', name: 'محمد أيوب', cdnBitrate: 128),
  QuranReciter(id: 'ar.muhammadjibreel', name: 'محمد جبريل', cdnBitrate: 128),
  QuranReciter(id: 'ar.aymanswoaid', name: 'أيمن سويد', cdnBitrate: 64),
  QuranReciter(id: 'ar.ibrahimakhbar', name: 'إبراهيم الأخضر', cdnBitrate: 32),
  QuranReciter(
    id: 'ar.yasseraddussary',
    name: 'ياسر الدوسري',
    cdnBitrate: 128,
    provider: ReciterProvider.everyAyah,
    folderName: 'Yasser_Ad-Dussary_128kbps',
  ),
  QuranReciter(
    id: 'ar.saadalghamadi',
    name: 'سعد الغامدي',
    cdnBitrate: 40,
    provider: ReciterProvider.everyAyah,
    folderName: 'Ghamadi_40kbps',
  ),
  QuranReciter(
    id: 'ar.faresabbad',
    name: 'فارس عباد',
    cdnBitrate: 64,
    provider: ReciterProvider.everyAyah,
    folderName: 'Fares_Abbad_64kbps',
  ),
  QuranReciter(
    id: 'ar.nasseralqatami',
    name: 'ناصر القطامي',
    cdnBitrate: 128,
    provider: ReciterProvider.everyAyah,
    folderName: 'Nasser_Alqatami_128kbps',
  ),
  QuranReciter(
    id: 'ar.alijaber',
    name: 'علي جابر',
    cdnBitrate: 64,
    provider: ReciterProvider.everyAyah,
    folderName: 'Ali_Jaber_64kbps',
  ),
  QuranReciter(
    id: 'ar.mohammadaltablaway',
    name: 'محمد محمود الطبلاوي',
    cdnBitrate: 128,
    provider: ReciterProvider.everyAyah,
    folderName: 'Mohammad_al_Tablaway_128kbps',
  ),
  QuranReciter(
    id: 'ar.mahmoudalialbanna',
    name: 'محمود علي البنا',
    style: 'مرتل',
    cdnBitrate: 32,
    provider: ReciterProvider.everyAyah,
    folderName: 'mahmoud_ali_al_banna_32kbps',
  ),
  QuranReciter(
    id: 'ar.salahalbudair',
    name: 'صلاح البدير',
    cdnBitrate: 128,
    provider: ReciterProvider.everyAyah,
    folderName: 'Salah_Al_Budair_128kbps',
  ),
  QuranReciter(
    id: 'ar.abdullahaljuhaynee',
    name: 'عبدالله عواد الجهني',
    cdnBitrate: 128,
    provider: ReciterProvider.everyAyah,
    folderName: 'Abdullaah_3awwaad_Al-Juhaynee_128kbps',
  ),
  QuranReciter(
    id: 'ar.khaalidalqahtaanee',
    name: 'خالد القحطاني',
    cdnBitrate: 192,
    provider: ReciterProvider.everyAyah,
    folderName: 'Khaalid_Abdullaah_al-Qahtaanee_192kbps',
  ),
  QuranReciter(
    id: 'ar.mustafaismail',
    name: 'مصطفى إسماعيل',
    style: 'مجود',
    cdnBitrate: 48,
    provider: ReciterProvider.everyAyah,
    folderName: 'Mustafa_Ismail_48kbps',
  ),
  QuranReciter(
    id: 'ar.khalifaaltunaiji',
    name: 'خليفة الطنيجي',
    cdnBitrate: 64,
    provider: ReciterProvider.everyAyah,
    folderName: 'khalefa_al_tunaiji_64kbps',
  ),
  QuranReciter(
    id: 'ar.salahbukhatir',
    name: 'صلاح بوخاطر',
    cdnBitrate: 128,
    provider: ReciterProvider.everyAyah,
    folderName: 'Salaah_AbdulRahman_Bukhatir_128kbps',
  ),
];

const unverifiedReciterIds = <String>[
  'ar.ahmedalajmi', // persistent 403 at 128 on Islamic Network (ar.ahmedajamy is included instead)
  'ar.islamsobhi', // Surah-by-surah only; incomplete verse-by-verse
  'ar.hazzaalbalushi', // Selected surahs only
];

QuranReciter reciterById(String id) {
  for (final reciter in quranReciters) {
    if (reciter.id == id) return reciter;
  }
  return quranReciters.first;
}

(int, int) _surahAndAyahFromGlobal(int globalAyah) {
  const surahVerseCounts = [
    7, 286, 200, 176, 120, 165, 206, 75, 129, 109,
    123, 111, 43, 52, 99, 128, 111, 110, 98, 135,
    112, 78, 118, 64, 77, 227, 93, 88, 69, 60,
    34, 30, 73, 54, 45, 83, 182, 88, 75, 85,
    54, 53, 89, 59, 37, 35, 38, 29, 18, 45,
    60, 49, 62, 55, 78, 96, 29, 22, 24, 13,
    14, 11, 11, 18, 12, 12, 30, 52, 52, 44,
    28, 28, 20, 56, 40, 31, 50, 40, 46, 42,
    29, 19, 36, 25, 22, 17, 19, 26, 30, 20,
    15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
    11, 8, 3, 9, 5, 4, 7, 3, 6, 3,
    5, 4, 5, 6
  ];
  var accumulated = 0;
  for (var s = 0; s < 114; s++) {
    final count = surahVerseCounts[s];
    if (accumulated + count >= globalAyah) {
      return (s + 1, globalAyah - accumulated);
    }
    accumulated += count;
  }
  return (1, 1);
}

/// Verified CDN URL layout:
/// - Islamic Network: /quran/audio/{bitrate}/{edition}/{globalAyah}.mp3
/// - EveryAyah: /data/{folderName}/{surah3}{ayah3}.mp3
Uri ayahStreamUri({
  required QuranReciter reciter,
  required int globalAyah,
}) {
  if (reciter.provider == ReciterProvider.everyAyah) {
    final (surah, ayah) = _surahAndAyahFromGlobal(globalAyah);
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');
    final folder = reciter.folderName ?? reciter.id;
    return Uri.https('everyayah.com', '/data/$folder/$s$a.mp3');
  }

  final bitrate = reciter.cdnBitrate;
  final id = reciter.id;
  return Uri.https('cdn.islamic.network', '/quran/audio/$bitrate/$id/$globalAyah.mp3');
}

const Map<String, String> _everyAyahFolderMap = {
  'ar.alafasy': 'Alafasy_128kbps',
  'ar.abdulbasitmurattal': 'Abdul_Basit_Murattal_192kbps',
  'ar.abdulsamad': 'AbdulSamad_64kbps_QuranExplorer.Com',
  'ar.minshawi': 'Minshawy_Murattal_128kbps',
  'ar.husary': 'Husary_128kbps',
  'ar.husarymujawwad': 'Husary_128kbps_Mujawwad',
  'ar.mahermuaiqly': 'MaherAlMuaiqly128kbps',
  'ar.saoodshuraym': 'Saood_ash-Shuraym_128kbps',
  'ar.abdurrahmaansudais': 'Abdurrahmaan_As-Sudais_192kbps',
  'ar.shaatree': 'Abu_Bakr_Ash-Shaatree_128kbps',
  'ar.ahmedajamy': 'Ahmed_ibn_Ali_al-Ajamy_128kbps_ketaballah.net',
  'ar.hanirifai': 'Hani_Rifai_192kbps',
  'ar.hudhaify': 'Hudhaify_128kbps',
  'ar.abdullahbasfar': 'Abdullah_Basfar_192kbps',
  'ar.muhammadayyoub': 'Muhammad_Ayyoub_128kbps',
  'ar.muhammadjibreel': 'Muhammad_Jibreel_128kbps',
  'ar.aymanswoaid': 'Ayman_Sowaid_64kbps',
  'ar.ibrahimakhbar': 'Ibrahim_Akhdar_32kbps',
  'ar.yasseraddussary': 'Yasser_Ad-Dussary_128kbps',
  'ar.saadalghamadi': 'Ghamadi_40kbps',
  'ar.faresabbad': 'Fares_Abbad_64kbps',
  'ar.nasseralqatami': 'Nasser_Alqatami_128kbps',
  'ar.alijaber': 'Ali_Jaber_64kbps',
  'ar.mohammadaltablaway': 'Mohammad_al_Tablaway_128kbps',
  'ar.mahmoudalialbanna': 'mahmoud_ali_al_banna_32kbps',
  'ar.salahalbudair': 'Salah_Al_Budair_128kbps',
  'ar.abdullahaljuhaynee': 'Abdullaah_3awwaad_Al-Juhaynee_128kbps',
  'ar.khaalidalqahtaanee': 'Khaalid_Al-Qahtaanee_192kbps',
  'ar.mustafaismail': 'Mustafa_Ismail_48kbps',
  'ar.khalifaaltunaiji': 'Khalefa_Al-Tunaiji_64kbps',
  'ar.salahbukhatir': 'Salah_Bukhatir_128kbps',
};

/// Resilient fallback URI on EveryAyah CDN when primary stream is slow or unreachable.
Uri? ayahFallbackStreamUri({
  required QuranReciter reciter,
  required int globalAyah,
}) {
  final folder = reciter.folderName ?? _everyAyahFolderMap[reciter.id];
  if (folder == null) return null;
  final (surah, ayah) = _surahAndAyahFromGlobal(globalAyah);
  final s = surah.toString().padLeft(3, '0');
  final a = ayah.toString().padLeft(3, '0');
  final uri = Uri.https('everyayah.com', '/data/$folder/$s$a.mp3');
  return uri;
}


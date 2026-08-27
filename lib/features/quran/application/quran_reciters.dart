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

class QuranReciter {
  const QuranReciter({
    required this.id,
    required this.name,
    required this.cdnBitrate,
    this.style,
  });

  final String id;
  final String name;
  final int cdnBitrate;

  /// Recitation style when the reciter has distinct murattal/mujawwad sets.
  final String? style;

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
];

/// Reciters requested by the community that could NOT be verified on the
/// streaming CDN (no edition exists / persistent 403). Never pretend.
/// Re-verify before adding: إسلام صبحي، ياسر الدوسري، فارس عباد، سعد الغامدي.
const unverifiedReciterIds = <String>[
  'ar.ahmedalajmi', // persistent 403 at 128
];

QuranReciter reciterById(String id) {
  for (final reciter in quranReciters) {
    if (reciter.id == id) return reciter;
  }
  return quranReciters.first;
}

/// Verified CDN URL layout: /quran/audio/{bitrate}/{edition}/{globalAyah}.mp3
Uri ayahStreamUri({
  required QuranReciter reciter,
  required int globalAyah,
}) {
  final bitrate = reciter.cdnBitrate;
  final id = reciter.id;
  return Uri.https('cdn.islamic.network', '/quran/audio/$bitrate/$id/$globalAyah.mp3');
}

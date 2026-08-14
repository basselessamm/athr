import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_flutter/quran.dart';

class QuranReciter {
  const QuranReciter({
    required this.id,
    required this.name,
    required this.cdnBitrate,
  });

  final String id;
  final String name;
  final int cdnBitrate;
}

const quranReciters = <QuranReciter>[
  QuranReciter(id: 'ar.alafasy', name: 'مشاري العفاسي', cdnBitrate: 128),
  QuranReciter(
    id: 'ar.abdurrahmaansudais',
    name: 'عبد الرحمن السديس',
    cdnBitrate: 192,
  ),
  QuranReciter(
    id: 'ar.abdulbasitmurattal',
    name: 'عبد الباسط عبد الصمد',
    cdnBitrate: 192,
  ),
  QuranReciter(id: 'ar.minshawi', name: 'محمد صديق المنشاوي', cdnBitrate: 128),
  QuranReciter(id: 'ar.husary', name: 'محمود خليل الحصري', cdnBitrate: 128),
  QuranReciter(id: 'ar.mahermuaiqly', name: 'ماهر المعيقلي', cdnBitrate: 128),
  QuranReciter(id: 'ar.saoodshuraym', name: 'سعود الشريم', cdnBitrate: 128),
  QuranReciter(id: 'ar.muhammadayyoub', name: 'محمد أيوب', cdnBitrate: 128),
  QuranReciter(id: 'ar.muhammadjibreel', name: 'محمد جبريل', cdnBitrate: 128),
  QuranReciter(id: 'ar.ahmedalajmi', name: 'أحمد العجمي', cdnBitrate: 128),
];

class QuranAudioRepository {
  Uri ayahStream({required QuranReciter reciter, required int globalAyah}) {
    return Uri.https(
      'cdn.islamic.network',
      '/quran/audio/${reciter.cdnBitrate}/${reciter.id}/$globalAyah.mp3',
    );
  }

  int globalAyahNumber({required int surah, required int ayah}) {
    var total = ayah;
    for (var index = 1; index < surah; index++) {
      total += Quran.getTotalVersesInSurah(index);
    }
    return total;
  }
}

class QuranAudioState {
  const QuranAudioState({
    required this.reciter,
    this.surah,
    this.ayah,
    this.totalAyahs,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.error,
  });

  final QuranReciter reciter;
  final int? surah;
  final int? ayah;
  final int? totalAyahs;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final String? error;

  bool get hasSelection => surah != null && ayah != null && totalAyahs != null;

  QuranAudioState copyWith({
    QuranReciter? reciter,
    int? surah,
    int? ayah,
    int? totalAyahs,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    String? error,
    bool clearError = false,
  }) {
    return QuranAudioState(
      reciter: reciter ?? this.reciter,
      surah: surah ?? this.surah,
      ayah: ayah ?? this.ayah,
      totalAyahs: totalAyahs ?? this.totalAyahs,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class QuranAudioController extends StateNotifier<QuranAudioState> {
  QuranAudioController(this._repository)
    : _player = AudioPlayer(),
      super(QuranAudioState(reciter: quranReciters.first)) {
    _positionSubscription = _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });
    _durationSubscription = _player.durationStream.listen((duration) {
      state = state.copyWith(duration: duration ?? Duration.zero);
    });
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState.playing,
        isLoading:
            playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering,
      );
      if (playerState.processingState == ProcessingState.completed) {
        unawaited(next());
      }
    });
    _errorSubscription = _player.playbackEventStream.listen(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isLoading: false,
          isPlaying: false,
          error: 'تعذر تشغيل الصوت. تحقق من اتصال الإنترنت وحاول مرة أخرى.',
        );
      },
    );
  }

  final QuranAudioRepository _repository;
  final AudioPlayer _player;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<PlaybackEvent> _errorSubscription;

  Future<void> selectReciter(QuranReciter reciter) async {
    final hadSelection = state.hasSelection;
    final wasPlaying = state.isPlaying;
    state = state.copyWith(reciter: reciter, clearError: true);
    if (hadSelection) {
      await playAyah(
        surah: state.surah!,
        ayah: state.ayah!,
        totalAyahs: state.totalAyahs!,
        autoplay: wasPlaying,
      );
    }
  }

  Future<void> playAyah({
    required int surah,
    required int ayah,
    required int totalAyahs,
    bool autoplay = true,
  }) async {
    final globalAyah = _repository.globalAyahNumber(surah: surah, ayah: ayah);
    state = state.copyWith(
      surah: surah,
      ayah: ayah,
      totalAyahs: totalAyahs,
      isLoading: true,
      position: Duration.zero,
      duration: Duration.zero,
      clearError: true,
    );
    try {
      final source = AudioSource.uri(
        _repository.ayahStream(reciter: state.reciter, globalAyah: globalAyah),
        tag: 'quran:$surah:$ayah:${state.reciter.id}',
      );
      await _player.setAudioSource(source).timeout(const Duration(seconds: 12));
      if (autoplay) await _player.play();
    } on PlayerException {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        error: 'تعذر تشغيل هذه الآية من المصدر الصوتي الآن.',
      );
    } on PlayerInterruptedException {
      state = state.copyWith(isLoading: false, isPlaying: false);
    } on TimeoutException {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        error:
            'استغرق تحميل التلاوة وقتًا أطول من المتوقع. تحقق من الاتصال ثم أعد المحاولة.',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        error: 'تعذر تحميل الصوت. تحقق من الاتصال ثم أعد المحاولة.',
      );
    }
  }

  Future<void> toggle() async {
    if (!state.hasSelection) return;
    if (state.isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> next() async {
    if (!state.hasSelection) return;
    final ayah = state.ayah!;
    if (ayah >= state.totalAyahs!) {
      await _player.pause();
      return;
    }
    await playAyah(
      surah: state.surah!,
      ayah: ayah + 1,
      totalAyahs: state.totalAyahs!,
    );
  }

  Future<void> previous() async {
    if (!state.hasSelection) return;
    final ayah = state.ayah!;
    if (ayah <= 1) {
      await _player.seek(Duration.zero);
      return;
    }
    await playAyah(
      surah: state.surah!,
      ayah: ayah - 1,
      totalAyahs: state.totalAyahs!,
    );
  }

  Future<void> seek(Duration value) => _player.seek(value);

  @override
  void dispose() {
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playerStateSubscription.cancel();
    _errorSubscription.cancel();
    _player.dispose();
    super.dispose();
  }
}

final quranAudioRepositoryProvider = Provider<QuranAudioRepository>((ref) {
  return QuranAudioRepository();
});

final quranAudioControllerProvider =
    StateNotifierProvider.autoDispose<QuranAudioController, QuranAudioState>((
      ref,
    ) {
      return QuranAudioController(ref.watch(quranAudioRepositoryProvider));
    });

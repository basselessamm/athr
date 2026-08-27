import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:midrar/vendor/quran_core/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:midrar/features/settings/providers/settings_providers.dart';

import 'package:midrar/features/quran/application/quran_reciters.dart';

export 'quran_reciters.dart' show QuranReciter, quranReciters, unverifiedReciterIds;

// ---------------------------------------------------------------------------
// Smart cache: only ayahs the user actually listens to are stored.
// ---------------------------------------------------------------------------

class QuranAudioCache {
  QuranAudioCache._();
  static const _dirName = 'recitation_cache';

  static Future<Directory> _directory() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(p.join(base.path, _dirName));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  static Future<File> fileFor({
    required QuranReciter reciter,
    required int globalAyah,
  }) async {
    final dir = await _directory();
    return File(
      p.join(dir.path, '${reciter.id}_${reciter.cdnBitrate}_$globalAyah.mp3'),
    );
  }

  static Future<int> totalSizeBytes() async {
    try {
      final dir = await _directory();
      var total = 0;
      await for (final entity in dir.list()) {
        if (entity is File) total += entity.lengthSync();
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  static Future<void> clear() async {
    try {
      final dir = await _directory();
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    } catch (_) {
      // Clearing is best-effort; next cache write recreates the directory.
    }
  }
}



// ---------------------------------------------------------------------------
// Stream URL construction (verified CDN layout)
// ---------------------------------------------------------------------------

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
// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum QuranRepeatMode { off, ayah, surah }

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
    this.repeatMode = QuranRepeatMode.off,
    this.speed = 1.0,
    this.sleepUntil,
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
  final QuranRepeatMode repeatMode;
  final double speed;

  /// When the sleep timer fires (wall clock), or null when off.
  final DateTime? sleepUntil;

  final String? error;

  bool get hasSelection => surah != null && ayah != null && totalAyahs != null;

  Duration get remaining {
    final left = duration - position;
    return left.isNegative ? Duration.zero : left;
  }

  QuranAudioState copyWith({
    QuranReciter? reciter,
    int? surah,
    int? ayah,
    int? totalAyahs,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    QuranRepeatMode? repeatMode,
    double? speed,
    DateTime? sleepUntil,
    bool clearSleep = false,
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
      repeatMode: repeatMode ?? this.repeatMode,
      speed: speed ?? this.speed,
      sleepUntil: clearSleep ? null : (sleepUntil ?? this.sleepUntil),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

class QuranAudioController extends StateNotifier<QuranAudioState> {
  QuranAudioController(this._repository, {QuranReciter? savedReciter})
    : _player = AudioPlayer(),
      super(QuranAudioState(reciter: savedReciter ?? quranReciters.first)) {
    _configureAudioSession();
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
        unawaited(_onAyahCompleted());
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
  Timer? _sleepTimer;

  // Experimental just_audio API — the official streaming-cache primitive;
  // acceptable instability for a best-effort cache layer.
  AudioSource _cachingSource(Uri uri, File cacheFile, {required String tag}) {
    // ignore: experimental_member_use
    return LockCachingAudioSource(uri, cacheFile: cacheFile, tag: tag);
  }

  /// Declares the app's audio contract with the OS: recitation pauses for
  /// phone calls and yields politely to other media.
  Future<void> _configureAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
    } catch (_) {
      // Audio focus configuration is best-effort; playback still works.
    }
  }

  /// Completion routing: repeat modes first, then sequential advance.
  Future<void> _onAyahCompleted() async {
    switch (state.repeatMode) {
      case QuranRepeatMode.ayah:
        await playAyah(
          surah: state.surah!,
          ayah: state.ayah!,
          totalAyahs: state.totalAyahs!,
        );
        return;
      case QuranRepeatMode.surah:
        await playAyah(surah: state.surah!, ayah: 1, totalAyahs: state.totalAyahs!);
        return;
      case QuranRepeatMode.off:
        await next(autoAdvance: true);
        return;
    }
  }

  Future<void> selectReciter(QuranReciter reciter) async {
    final hadSelection = state.hasSelection;
    final wasPlaying = state.isPlaying;
    state = state.copyWith(reciter: reciter, clearError: true);
    unawaited(_persistReciter(reciter));
    if (hadSelection) {
      await playAyah(
        surah: state.surah!,
        ayah: state.ayah!,
        totalAyahs: state.totalAyahs!,
        autoplay: wasPlaying,
      );
    }
  }

  Future<void> _persistReciter(QuranReciter reciter) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_reciterPrefKey, reciter.id);
    } catch (_) {
      // Selection persistence is best-effort.
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
      final uri = _repository.ayahStream(
        reciter: state.reciter,
        globalAyah: globalAyah,
      );
      // Stream-first with transparent per-ayah caching of what the user
      // actually listens to. Never pre-downloads the whole Quran.
      AudioSource source;
      try {
        final cacheFile = await QuranAudioCache.fileFor(
          reciter: state.reciter,
          globalAyah: globalAyah,
        );
        // Experimental just_audio API — the official streaming-cache
        // primitive; acceptable instability for a best-effort cache.
        source = _cachingSource(uri, cacheFile,
            tag: 'quran:$surah:$ayah:${state.reciter.id}');
      } catch (_) {
        source = AudioSource.uri(
          uri,
          tag: 'quran:$surah:$ayah:${state.reciter.id}',
        );
      }
      await _player.setAudioSource(source).timeout(const Duration(seconds: 12));
      await _player.setSpeed(state.speed);
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

  Future<void> next({bool autoAdvance = false}) async {
    if (!state.hasSelection) return;
    final ayah = state.ayah!;
    if (ayah >= state.totalAyahs!) {
      // Surah finished: stop politely instead of playing into the void.
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
    // Standard player behavior: restart current ayah if mid-playback.
    if (ayah <= 1 || state.position > const Duration(seconds: 3)) {
      await _player.seek(Duration.zero);
      return;
    }
    await playAyah(
      surah: state.surah!,
      ayah: ayah - 1,
      totalAyahs: state.totalAyahs!,
    );
  }

  Future<void> nextSurah() async {
    final surah = state.surah;
    if (surah == null || surah >= 114) return;
    await playAyah(
      surah: surah + 1,
      ayah: 1,
      totalAyahs: Quran.getTotalVersesInSurah(surah + 1),
    );
  }

  Future<void> previousSurah() async {
    final surah = state.surah;
    if (surah == null || surah <= 1) return;
    await playAyah(
      surah: surah - 1,
      ayah: 1,
      totalAyahs: Quran.getTotalVersesInSurah(surah - 1),
    );
  }

  Future<void> seek(Duration value) => _player.seek(value);

  Future<void> cycleRepeatMode() async {
    final nextMode = switch (state.repeatMode) {
      QuranRepeatMode.off => QuranRepeatMode.ayah,
      QuranRepeatMode.ayah => QuranRepeatMode.surah,
      QuranRepeatMode.surah => QuranRepeatMode.off,
    };
    state = state.copyWith(repeatMode: nextMode);
  }

  Future<void> setSpeed(double speed) async {
    final clamped = speed.clamp(0.5, 2.0);
    state = state.copyWith(speed: clamped);
    try {
      await _player.setSpeed(clamped);
    } catch (_) {
      // Speed application is best-effort mid-load.
    }
  }

  void setSleepTimer(Duration? duration) {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    if (duration == null) {
      state = state.copyWith(clearSleep: true);
      return;
    }
    final endsAt = DateTime.now().add(duration);
    state = state.copyWith(sleepUntil: endsAt);
    _sleepTimer = Timer(duration, () async {
      try {
        await _player.pause();
      } catch (_) {}
      state = state.copyWith(isPlaying: false, clearSleep: true);
    });
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playerStateSubscription.cancel();
    _errorSubscription.cancel();
    _player.dispose();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final quranAudioRepositoryProvider = Provider<QuranAudioRepository>((ref) {
  return QuranAudioRepository();
});

/// Lives for the whole app session (not autoDispose) so recitation keeps
/// playing while the user navigates between screens.
final quranAudioControllerProvider =
    StateNotifierProvider<QuranAudioController, QuranAudioState>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      final savedId = prefs.getString(_reciterPrefKey);
      return QuranAudioController(
        ref.watch(quranAudioRepositoryProvider),
        savedReciter: savedId == null ? null : reciterById(savedId),
      );
    });

const _reciterPrefKey = 'quran_reciter_id';

final quranCacheSizeProvider = FutureProvider<int>((ref) async {
  return QuranAudioCache.totalSizeBytes();
});

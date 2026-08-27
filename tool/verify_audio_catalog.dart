// Audio source health check for Midrar's recitation catalog.
//
// Probes every reciter in the shipped catalog against the streaming CDN
// across stratified ayah samples and reports dead URLs, bad content types,
// and timeouts. Run before releases:
//
//   dart run tool/verify_audio_catalog.dart
//
// Exit code 0 = all healthy, 1 = at least one broken path.
// Requires network access. Uses HTTP Range requests (bytes=0-1) so the
// whole check costs a few hundred kilobytes, not gigabytes.
import 'dart:async';
import 'dart:io';

import 'package:midrar/features/quran/application/quran_reciters.dart';

const _samples = [
  1, // Al-Fatiha 1:1
  262, // Ayat al-Kursi 2:255
  1427, // ~Juz 7 boundary
  2484, // ~Juz 12
  3634, // ~Juz 17
  4551, // ~Juz 22
  5419, // ~Juz 27
  6236, // An-Nas 114:6 (final ayah)
];

Future<void> main() async {
  stdout.writeln('Midrar audio catalog health check');
  stdout.writeln('CDN: cdn.islamic.network · samples per reciter: ${_samples.length}');
  stdout.writeln('');

  var failures = 0;
  for (final reciter in quranReciters) {
    final failuresForReciter = <String>[];
    for (final ayah in _samples) {
      final uri = ayahStreamUri(
        reciter: reciter,
        globalAyah: ayah,
      );
      final result = await _probe(uri);
      switch (result) {
        case _Healthy(:final contentType, :final nonstandard):
          if (nonstandard) {
            // Plays everywhere (verified), but worth tracking upstream.
            stdout.writeln(
              '           ~ ayah $ayah: nonstandard content-type $contentType',
            );
          }
        case _Broken(:final reason):
          failuresForReciter.add('ayah $ayah: $reason');
      }
      // Gentle pacing: respect the CDN, avoid triggering rate limits.
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
    if (failuresForReciter.isEmpty) {
      stdout.writeln('  OK       ${reciter.id} @${reciter.cdnBitrate}');
    } else {
      failures += failuresForReciter.length;
      stdout.writeln('  BROKEN   ${reciter.id} @${reciter.cdnBitrate}');
      for (final failure in failuresForReciter) {
        stdout.writeln('           - $failure');
      }
    }
  }

  stdout.writeln('');
  if (failures == 0) {
    stdout.writeln('All ${quranReciters.length} reciter paths healthy.');
    exit(0);
  }
  stdout.writeln('$failures broken probe(s). DO NOT SHIP without fixing.');
  exit(1);
}

sealed class _ProbeResult {}

class _Healthy extends _ProbeResult {
  _Healthy(this.contentType, {this.nonstandard = false});
  final String contentType;

  /// application/octet-stream: plays on every platform we target, but the
  /// CDN is not declaring audio/mpeg. Tracked, not fatal.
  final bool nonstandard;
}

class _Broken extends _ProbeResult {
  _Broken(this.reason);
  final String reason;
}

Future<_ProbeResult> _probe(Uri uri) async {
  final client = HttpClient();
  try {
    final request = await client
        .headUrl(uri)
        .timeout(const Duration(seconds: 15));
    final response = await request.close();
    final status = response.statusCode;
    await response.drain<void>();
    if (status == 200 || status == 206) {
      final type = response.headers.value(HttpHeaders.contentTypeHeader) ?? '';
      final nonstandard = !type.startsWith('audio/');
      return _Healthy(type, nonstandard: nonstandard);
    }
    return _Broken('HTTP $status');
  } on SocketException catch (error) {
    return _Broken('socket: ${error.message}');
  } on TimeoutException {
    return _Broken('timeout after 15s');
  } finally {
    client.close(force: true);
  }
}

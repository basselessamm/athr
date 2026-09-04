import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';

void main() {
  group('iOS Darwin Prayer Audio Configuration', () {
    test('All 5 prayer WAV audio files exist in ios/Runner root bundle', () {
      for (final prayer in PrayerName.values) {
        final fileName = 'prayer_${prayer.name}.wav';
        final file = File('ios/Runner/$fileName');
        expect(
          file.existsSync(),
          isTrue,
          reason: 'ios/Runner/$fileName must exist for Darwin local notifications',
        );
        expect(
          file.lengthSync(),
          greaterThan(1000),
          reason: 'ios/Runner/$fileName must not be empty',
        );
      }
    });

    test('Audio file names match the Darwin sound convention exactly', () {
      for (final prayer in PrayerName.values) {
        final expectedName = 'prayer_${prayer.name}.wav';
        expect(expectedName, isIn([
          'prayer_fajr.wav',
          'prayer_dhuhr.wav',
          'prayer_asr.wav',
          'prayer_maghrib.wav',
          'prayer_isha.wav',
        ]));
      }
    });
  });
}

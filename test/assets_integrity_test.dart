import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('assets integrity: brand logo exists and loads from bundle', () async {
    final bytes = await rootBundle.load('assets/brand/logo_primary_1024.png');
    expect(bytes.lengthInBytes, greaterThan(0));
  });

  test('assets integrity: prayer audio wav files exist in bundle', () async {
    final prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    for (final p in prayers) {
      final bytes = await rootBundle.load('assets/prayer_audio/prayer_$p.wav');
      expect(bytes.lengthInBytes, greaterThan(0));
    }
  });
}

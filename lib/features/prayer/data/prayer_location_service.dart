import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:athr/features/prayer/domain/prayer_location.dart';

class PrayerLocationException implements Exception {
  final String message;

  const PrayerLocationException(this.message);

  @override
  String toString() => message;
}

class PrayerLocationService {
  const PrayerLocationService();

  static bool _timeZonesInitialized = false;

  Future<PrayerLocation> resolveCurrentLocation() async {
    _ensureTimeZonesInitialized();

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const PrayerLocationException('خدمة الموقع متوقفة على الجهاز.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const PrayerLocationException('تم رفض إذن الموقع.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PrayerLocationException(
        'إذن الموقع مرفوض نهائياً. افتح إعدادات النظام لتعديله.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 12),
      ),
    );

    final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final timeZoneId = _validatedTimeZoneId(timeZoneInfo.identifier);
    final localizedName = timeZoneInfo.localizedName?.name;

    return PrayerLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      timeZoneId: timeZoneId,
      label: localizedName ?? timeZoneId,
    );
  }

  String _validatedTimeZoneId(String identifier) {
    try {
      tz.getLocation(identifier);
      return identifier;
    } catch (_) {
      return 'UTC';
    }
  }

  void _ensureTimeZonesInitialized() {
    if (_timeZonesInitialized) {
      return;
    }
    tz_data.initializeTimeZones();
    _timeZonesInitialized = true;
  }
}

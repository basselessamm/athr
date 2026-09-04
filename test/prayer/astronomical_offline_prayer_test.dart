import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:midrar/features/prayer/application/astronomical_prayer_calculator.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';

class _FailingHttpClient implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    throw http.ClientException('Offline: No route to host');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('Astronomical Offline Prayer Calculator', () {
    const calculator = AstronomicalPrayerCalculator();
    const makkahLocation = PrayerLocation(
      latitude: 21.4225,
      longitude: 39.8262,
      accuracy: 10,
    );

    test('calculates all 5 prayer moments in chronological order', () {
      final day = calculator.calculateDay(
        date: DateTime(2026, 4, 15),
        location: makkahLocation,
        calculationMethod: 4, // Umm Al-Qura
        asrSchool: AsrSchool.shafii,
        timezoneName: 'Asia/Riyadh',
      );

      expect(day.moments, hasLength(5));
      final fajr = day.moments.firstWhere((m) => m.name == PrayerName.fajr);
      final dhuhr = day.moments.firstWhere((m) => m.name == PrayerName.dhuhr);
      final asr = day.moments.firstWhere((m) => m.name == PrayerName.asr);
      final maghrib = day.moments.firstWhere((m) => m.name == PrayerName.maghrib);
      final isha = day.moments.firstWhere((m) => m.name == PrayerName.isha);

      expect(fajr.at.isBefore(dhuhr.at), isTrue);
      expect(dhuhr.at.isBefore(asr.at), isTrue);
      expect(asr.at.isBefore(maghrib.at), isTrue);
      expect(maghrib.at.isBefore(isha.at), isTrue);
    });

    test('Hanafi Asr shadow calculation gives later time than Shafii', () {
      final shafiiDay = calculator.calculateDay(
        date: DateTime(2026, 6, 21),
        location: makkahLocation,
        calculationMethod: 4,
        asrSchool: AsrSchool.shafii,
        timezoneName: 'Asia/Riyadh',
      );

      final hanafiDay = calculator.calculateDay(
        date: DateTime(2026, 6, 21),
        location: makkahLocation,
        calculationMethod: 4,
        asrSchool: AsrSchool.hanafi,
        timezoneName: 'Asia/Riyadh',
      );

      final shafiiAsr = shafiiDay.moments.firstWhere((m) => m.name == PrayerName.asr);
      final hanafiAsr = hanafiDay.moments.firstWhere((m) => m.name == PrayerName.asr);

      expect(hanafiAsr.at.isAfter(shafiiAsr.at), isTrue);
    });

    test('PrayerTimesRepository falls back to astronomical calculation when offline',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = PrayerTimesRepository(_FailingHttpClient(), prefs);

      final schedule = await repository.fetchSchedule(
        location: makkahLocation,
        anchor: DateTime(2026, 8, 1),
        calculationMethod: 4,
        asrSchool: AsrSchool.shafii,
      );

      expect(schedule.days, isNotEmpty);
      expect(schedule.days.length, greaterThanOrEqualTo(50));
      expect(schedule.days.first.moments, hasLength(5));
      expect(schedule.days.first.moments.first.name, PrayerName.fajr);
    });
  });
}

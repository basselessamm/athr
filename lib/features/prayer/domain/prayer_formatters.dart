import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import 'prayer_enums.dart';

class PrayerFormatters {
  static String formatTime(DateTime time, PrayerTimeFormat format) {
    if (format == PrayerTimeFormat.twentyFourHour) {
      return DateFormat('HH:mm', 'ar').format(time);
    }
    return DateFormat('h:mm a', 'ar').format(time);
  }

  static String formatCountdown(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final hours = safe.inHours.toString().padLeft(2, '0');
    final minutes = (safe.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (safe.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  static String formatHijriDate(HijriCalendar date) {
    const months = <int, String>{
      1: 'محرم',
      2: 'صفر',
      3: 'ربيع الأول',
      4: 'ربيع الآخر',
      5: 'جمادى الأولى',
      6: 'جمادى الآخرة',
      7: 'رجب',
      8: 'شعبان',
      9: 'رمضان',
      10: 'شوال',
      11: 'ذو القعدة',
      12: 'ذو الحجة',
    };

    final month = months[date.hMonth] ?? 'شهر هجري';
    return '${date.hDay} $month ${date.hYear}هـ';
  }
}

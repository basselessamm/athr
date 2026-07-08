import 'package:hijri/hijri_calendar.dart';

class DashboardRuleInput {
  final DateTime now;
  final HijriCalendar hijri;
  final bool hasLastRead;
  final bool hasMuhasabaToday;

  const DashboardRuleInput({
    required this.now,
    required this.hijri,
    required this.hasLastRead,
    required this.hasMuhasabaToday,
  });
}

class DashboardPayload {
  final String greeting;
  final String headline;
  final String? subGreeting;
  final String? focusLabel;
  final String? focusRoute;
  final String? focusReason;

  const DashboardPayload({
    required this.greeting,
    required this.headline,
    this.subGreeting,
    this.focusLabel,
    this.focusRoute,
    this.focusReason,
  });
}

abstract class DashboardRule {
  int get priority;
  bool matches(DashboardRuleInput input);
  DashboardPayload transform(
    DashboardPayload current,
    DashboardRuleInput input,
  );
}

class TimeOfDayRule implements DashboardRule {
  @override
  int get priority => 10;

  @override
  bool matches(DashboardRuleInput input) => true;

  @override
  DashboardPayload transform(
    DashboardPayload current,
    DashboardRuleInput input,
  ) {
    final hour = input.now.hour;
    if (hour >= 5 && hour < 12) {
      return DashboardPayload(
        greeting: 'صباح الخير',
        headline: 'ابدأ يومك بخطوة ثابتة ولو كانت صغيرة.',
        subGreeting: current.subGreeting,
        focusLabel: current.focusLabel,
        focusRoute: current.focusRoute,
        focusReason: current.focusReason,
      );
    }
    if (hour >= 12 && hour < 17) {
      return DashboardPayload(
        greeting: 'طاب يومك',
        headline: 'منتصف اليوم وقت ممتاز لاستعادة الاتجاه.',
        subGreeting: current.subGreeting,
        focusLabel: current.focusLabel,
        focusRoute: current.focusRoute,
        focusReason: current.focusReason,
      );
    }
    if (hour >= 17 && hour < 21) {
      return DashboardPayload(
        greeting: 'مساء الخير',
        headline: 'اختم يومك بما يثبت أثره في القلب.',
        subGreeting: current.subGreeting,
        focusLabel: current.focusLabel,
        focusRoute: current.focusRoute,
        focusReason: current.focusReason,
      );
    }
    return DashboardPayload(
      greeting: 'طابت ليلتك',
      headline: 'هذا وقت هادئ للمراجعة والمحاسبة.',
      subGreeting: current.subGreeting,
      focusLabel: current.focusLabel,
      focusRoute: current.focusRoute,
      focusReason: current.focusReason,
    );
  }
}

class FridayRule implements DashboardRule {
  @override
  int get priority => 50;

  @override
  bool matches(DashboardRuleInput input) =>
      input.now.weekday == DateTime.friday;

  @override
  DashboardPayload transform(
    DashboardPayload current,
    DashboardRuleInput input,
  ) {
    return DashboardPayload(
      greeting: current.greeting,
      headline: current.headline,
      subGreeting: 'جمعة مباركة، لا تنس سورة الكهف والصلاة على النبي ﷺ',
      focusLabel: current.focusLabel ?? 'العودة إلى القرآن',
      focusRoute: current.focusRoute ?? '/quran',
      focusReason: current.focusReason ?? 'اليوم يحمل إيقاعًا تعبديًا خاصًا.',
    );
  }
}

class RamadanRule implements DashboardRule {
  @override
  int get priority => 100;

  @override
  bool matches(DashboardRuleInput input) => input.hijri.hMonth == 9;

  @override
  DashboardPayload transform(
    DashboardPayload current,
    DashboardRuleInput input,
  ) {
    return DashboardPayload(
      greeting: current.greeting,
      headline: 'رمضان موسم تكثيف الأثر لا مجرد كثرة المحاولات.',
      subGreeting: 'اختر عملاً واحدًا تداوم عليه اليوم قبل أن تبحث عن المزيد.',
      focusLabel: 'ورد القرآن',
      focusRoute: '/quran',
      focusReason: 'أقرب باب الآن هو القرآن والاستمرار الهادئ.',
    );
  }
}

class MuhasabaRule implements DashboardRule {
  @override
  int get priority => 80;

  @override
  bool matches(DashboardRuleInput input) =>
      input.now.hour >= 20 && !input.hasMuhasabaToday;

  @override
  DashboardPayload transform(
    DashboardPayload current,
    DashboardRuleInput input,
  ) {
    return DashboardPayload(
      greeting: current.greeting,
      headline: current.headline,
      subGreeting:
          current.subGreeting ?? 'قبل نهاية اليوم، خصص دقيقة صادقة للمحاسبة.',
      focusLabel: 'المحاسبة اليومية',
      focusRoute: '/muhasaba',
      focusReason: 'الليل هو أفضل وقت لتثبيت مراجعة اليوم قبل أن يضيع أثره.',
    );
  }
}

class ContinueReadingRule implements DashboardRule {
  @override
  int get priority => 40;

  @override
  bool matches(DashboardRuleInput input) => input.hasLastRead;

  @override
  DashboardPayload transform(
    DashboardPayload current,
    DashboardRuleInput input,
  ) {
    return DashboardPayload(
      greeting: current.greeting,
      headline: current.headline,
      subGreeting: current.subGreeting,
      focusLabel: current.focusLabel ?? 'متابعة القراءة',
      focusRoute: current.focusRoute ?? '/library',
      focusReason:
          current.focusReason ??
          'أقصر طريق للثبات هو الرجوع لما بدأتَه بالفعل.',
    );
  }
}

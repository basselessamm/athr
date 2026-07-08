import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:athr/features/home/domain/rules/dashboard_rule_engine.dart';
import 'package:athr/features/home/domain/rules/dashboard_rules.dart';
import 'package:athr/features/home/providers/home_providers.dart';
import 'package:athr/features/library/modules/recent_activity/providers/recent_activity_providers.dart';

class DashboardContext {
  final String greeting;
  final String headline;
  final String? subGreeting;
  final String? focusLabel;
  final String? focusRoute;
  final String? focusReason;
  final HijriCalendar hijriDate;

  const DashboardContext({
    required this.greeting,
    required this.headline,
    this.subGreeting,
    this.focusLabel,
    this.focusRoute,
    this.focusReason,
    required this.hijriDate,
  });
}

final dashboardRuleEngineProvider = Provider<DashboardRuleEngine>((ref) {
  return DashboardRuleEngine([
    TimeOfDayRule(),
    ContinueReadingRule(),
    FridayRule(),
    MuhasabaRule(),
    RamadanRule(),
  ]);
});

final dashboardNowProvider = Provider<DateTime>((ref) => DateTime.now());

final dashboardContextProvider = Provider<DashboardContext>((ref) {
  final now = ref.watch(dashboardNowProvider);
  final hijri = HijriCalendar.fromDate(now);
  final engine = ref.watch(dashboardRuleEngineProvider);
  final lastRead = ref.watch(lastQuranReadProvider).valueOrNull;
  final muhasaba = ref.watch(todayMuhasabaProvider).valueOrNull;

  final payload = engine.evaluate(
    DashboardRuleInput(
      now: now,
      hijri: hijri,
      hasLastRead: lastRead != null,
      hasMuhasabaToday: muhasaba != null,
    ),
  );

  return DashboardContext(
    greeting: payload.greeting,
    headline: payload.headline,
    subGreeting: payload.subGreeting,
    focusLabel: payload.focusLabel,
    focusRoute: payload.focusRoute,
    focusReason: payload.focusReason,
    hijriDate: hijri,
  );
});

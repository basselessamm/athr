import 'dashboard_rules.dart';

class DashboardRuleEngine {
  const DashboardRuleEngine(this.rules);

  final List<DashboardRule> rules;

  DashboardPayload evaluate(DashboardRuleInput input) {
    final sortedRules = [...rules]
      ..sort((a, b) => a.priority.compareTo(b.priority));

    var payload = const DashboardPayload(
      greeting: 'مرحباً',
      headline: 'ابدأ من الخطوة التالية مباشرة.',
    );

    for (final rule in sortedRules) {
      if (rule.matches(input)) {
        payload = rule.transform(payload, input);
      }
    }

    return payload;
  }
}

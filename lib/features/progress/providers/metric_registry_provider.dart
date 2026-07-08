import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/progress/providers/progress_providers.dart';

typedef MetricValueResolver = int Function(Ref ref);

class MetricRegistry {
  final Map<String, MetricValueResolver> _resolvers = {};

  void register(String metricId, MetricValueResolver resolver) {
    _resolvers[metricId] = resolver;
  }

  int resolve(String metricId, Ref ref) {
    final resolver = _resolvers[metricId];
    if (resolver != null) {
      return resolver(ref);
    }
    return 0;
  }
}

final metricRegistryProvider = Provider<MetricRegistry>((ref) {
  final registry = MetricRegistry();

  // Register default progress metrics
  registry.register('quran_pages', (r) {
    final record = r.watch(dailyProgressProvider).value;
    return record?.pagesRead ?? 0;
  });

  registry.register('quran_minutes', (r) {
    final record = r.watch(dailyProgressProvider).value;
    return (record?.readingSeconds ?? 0) ~/ 60;
  });

  registry.register('azkar_count', (r) {
    final record = r.watch(dailyProgressProvider).value;
    return record?.azkarCount ?? 0;
  });

  registry.register('hadith_count', (r) {
    final record = r.watch(dailyProgressProvider).value;
    return record?.hadithCount ?? 0;
  });

  registry.register('muhasaba_done', (r) {
    final record = r.watch(dailyProgressProvider).value;
    return (record?.isMuhasabaDone ?? false) ? 1 : 0;
  });

  return registry;
});

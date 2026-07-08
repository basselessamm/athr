import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athr/features/progress/providers/metric_registry_provider.dart';

// Dummy implementation of Ref for testing basic registry operations
class DummyRef implements Ref {
  @override
  T watch<T>(ProviderListenable<T> provider) => throw UnimplementedError();
  @override
  T read<T>(ProviderListenable<T> provider) => throw UnimplementedError();
  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T?, T) listener, {
    bool fireImmediately = false,
    void Function(Object, StackTrace)? onError,
  }) => throw UnimplementedError();
  @override
  void invalidate(ProviderOrFamily provider) {}
  @override
  void invalidateSelf() {}
  @override
  KeepAliveLink keepAlive() => throw UnimplementedError();
  @override
  void notifyListeners() {}
  @override
  void listenSelf(
    void Function(Object?, Object) listener, {
    void Function(Object, StackTrace)? onError,
  }) {}
  @override
  void onCancel(void Function() cb) {}
  @override
  void onDispose(void Function() cb) {}
  @override
  void onResume(void Function() cb) {}
  @override
  T refresh<T>(Refreshable<T> provider) => throw UnimplementedError();
  @override
  ProviderContainer get container => throw UnimplementedError();
  @override
  bool exists(ProviderBase<Object?> provider) => throw UnimplementedError();
  @override
  void onRemoveListener(void Function() cb) {}
  @override
  void onAddListener(void Function() cb) {}
}

void main() {
  group('MetricRegistry Tests', () {
    test('Should return 0 for unknown metric', () {
      final registry = MetricRegistry();
      final dummyRef = DummyRef();

      final value = registry.resolve('unknown_metric', dummyRef);

      expect(value, 0);
    });

    test('Should resolve registered metric correctly', () {
      final registry = MetricRegistry();
      final dummyRef = DummyRef();

      registry.register('mock_metric', (ref) => 42);

      final value = registry.resolve('mock_metric', dummyRef);

      expect(value, 42);
    });
  });
}

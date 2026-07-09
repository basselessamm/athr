import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationInitializationProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  await service.init();
});

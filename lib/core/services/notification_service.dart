import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:athr/core/memory/domain/memory_contracts.dart';
import 'package:athr/core/memory/domain/reminder_intent.dart';
import 'package:athr/features/prayer/application/prayer_times.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  final Map<PrayerName, String> _prayerAudioUris = {};
  String? _pendingDeepLink;
  void Function(String deepLink)? _deepLinkHandler;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    await _loadPrayerAudioUris();

    final launchDetails = await _notificationsPlugin
        .getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      handleDeepLinkPayload(launchDetails?.notificationResponse?.payload);
    }

    _isInitialized = true;
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    handleDeepLinkPayload(response.payload);
  }

  Future<void> _loadPrayerAudioUris() async {
    if (!Platform.isAndroid) return;
    const channel = MethodChannel('athr/prayer_audio');
    for (final prayer in PrayerName.values) {
      try {
        final uri = await channel.invokeMethod<String>('prayerAudioUri', {
          'prayer': prayer.name,
        });
        if (uri != null && uri.isNotEmpty) {
          _prayerAudioUris[prayer] = uri;
        }
      } on PlatformException {
        // The notification will retain its text even if local audio is absent.
      }
    }
  }

  /// Builds an exact source route that also carries the owning MemoryThread.
  /// The extra query fields are removed before router navigation.
  static String threadSourceDeepLink({
    required String sourceRoute,
    required String threadId,
  }) {
    final uri = Uri.parse(sourceRoute);
    return uri
        .replace(
          queryParameters: {
            ...uri.queryParameters,
            'memoryThreadId': threadId,
            'returnOrigin': 'reminder',
          },
        )
        .toString();
  }

  static String prayerDeepLink(
    PrayerName prayer, {
    Map<String, String> extraQuery = const {},
  }) {
    return Uri(
      path: '/prayer',
      queryParameters: {'prayer': prayer.name, ...extraQuery},
    ).toString();
  }

  static NotificationThreadRoute? parseThreadSourceDeepLink(String deepLink) {
    final uri = Uri.tryParse(deepLink);
    final threadId = uri?.queryParameters['memoryThreadId'];
    if (uri == null || threadId == null || threadId.isEmpty) return null;

    final query = Map<String, String>.from(uri.queryParameters)
      ..remove('memoryThreadId')
      ..remove('returnOrigin');
    return NotificationThreadRoute(
      threadId: threadId,
      sourceRoute: uri.replace(queryParameters: query).toString(),
    );
  }

  void handleDeepLinkPayload(String? deepLink) {
    if (deepLink == null || deepLink.isEmpty) return;
    final handler = _deepLinkHandler;
    if (handler == null) {
      _pendingDeepLink = deepLink;
    } else {
      handler(deepLink);
    }
  }

  void setDeepLinkHandler(void Function(String deepLink) handler) {
    _deepLinkHandler = handler;
    final pending = _pendingDeepLink;
    _pendingDeepLink = null;
    if (pending != null) handler(pending);
  }

  int _notificationId(String value) {
    var hash = 17;
    for (final codeUnit in value.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return 1000 + (hash % 1000000);
  }

  Future<void> scheduleReminderIntent({
    required ReminderIntent intent,
    required MemoryThread thread,
    required String deepLink,
  }) async {
    if (intent.threadId != thread.id) {
      throw ArgumentError('ReminderIntent must belong to its MemoryThread');
    }
    if (!intent.enabled) {
      await cancelReminderIntent(intent);
      return;
    }
    if (intent.scheduledAt.isBefore(DateTime.now())) {
      throw ArgumentError('ReminderIntent scheduledAt must be in the future');
    }
    await init();
    final scheduledDate = tz.TZDateTime.from(intent.scheduledAt, tz.local);
    const androidDetails = AndroidNotificationDetails(
      'memory_thread_reminders',
      'تذكيرات خيوط العودة',
      channelDescription: 'تذكيرات اختارها المستخدم لخيوط الذاكرة فقط',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    await _notificationsPlugin.zonedSchedule(
      id: _notificationId(intent.id),
      title: 'عودة إلى خيطك',
      body: thread.source.sourceLabel,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: deepLink,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelReminderIntent(ReminderIntent intent) async {
    await init();
    await _notificationsPlugin.cancel(id: _notificationId(intent.id));
  }

  /// Schedules the upcoming user-selected prayers from an actual dated
  /// timetable. This is a utility notification, not a completion prompt or an
  /// engagement reminder.
  Future<void> schedulePrayerNotifications({
    required PrayerSchedule schedule,
    required PrayerSettings settings,
  }) async {
    await init();
    if (!settings.notificationsEnabled) {
      await cancelPrayerNotifications(schedule.days);
      return;
    }
    final granted = await requestPermission();
    if (!granted) {
      throw StateError('يلزم السماح بالإشعارات لتفعيل تنبيهات الصلاة.');
    }

    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final exactAllowed = await android?.canScheduleExactNotifications();
    if (exactAllowed == false) {
      await android?.requestExactAlarmsPermission();
    }

    for (final day in schedule.days) {
      for (final moment in day.moments) {
        final id = _prayerNotificationId(day.gregorianDate, moment.name);
        await _notificationsPlugin.cancel(id: id);
        if (!settings.enabledPrayers.contains(moment.name) ||
            !moment.at.isAfter(tz.TZDateTime.now(moment.at.location))) {
          continue;
        }
        final androidDetails = AndroidNotificationDetails(
          _prayerChannelId(moment.name, withAudio: settings.soundEnabled),
          'تنبيه صلاة ${moment.name.arabicLabel}',
          channelDescription: settings.soundEnabled
              ? 'يذكر اسم صلاة ${moment.name.arabicLabel} بصوت محلي عند الموعد.'
              : 'تنبيه صامت لصلاة ${moment.name.arabicLabel}.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: settings.soundEnabled,
          sound: settings.soundEnabled ? _prayerAudioSound(moment.name) : null,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          enableVibration: settings.soundEnabled,
        );
        await _notificationsPlugin.zonedSchedule(
          id: id,
          title: 'حان وقت صلاة ${moment.name.arabicLabel}',
          body:
              'موعد ${moment.name.arabicLabel} حسب إعدادات موقعك وطريقة الحساب.',
          scheduledDate: moment.at,
          notificationDetails: NotificationDetails(android: androidDetails),
          payload: prayerDeepLink(moment.name),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  Future<void> schedulePrayerAudioTest(PrayerName prayer) async {
    await init();
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 15));
    final androidDetails = AndroidNotificationDetails(
      _prayerChannelId(prayer, withAudio: true),
      'اختبار خلفية صوت صلاة ${prayer.arabicLabel}',
      channelDescription:
          'اختبار مجدول للصوت المحلي بعد خروج التطبيق من الواجهة.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: _prayerAudioSound(prayer),
      audioAttributesUsage: AudioAttributesUsage.alarm,
      enableVibration: true,
    );
    await _notificationsPlugin.zonedSchedule(
      id: _notificationId('prayer-audio-background-test-${prayer.name}'),
      title: 'اختبار خلفية: حان وقت صلاة ${prayer.arabicLabel}',
      body: 'هذا اختبار محلي مجدول؛ سيُنطق اسم الصلاة حتى بعد مغادرة التطبيق.',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(android: androidDetails),
      payload: prayerDeepLink(
        prayer,
        extraQuery: const {'audioBackgroundTest': 'true'},
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showPrayerAudioTest(PrayerName prayer) async {
    await init();
    final androidDetails = AndroidNotificationDetails(
      _prayerChannelId(prayer, withAudio: true),
      'اختبار صوت صلاة ${prayer.arabicLabel}',
      channelDescription: 'اختبار فوري للصوت المحلي الذي يذكر اسم الصلاة.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: _prayerAudioSound(prayer),
      audioAttributesUsage: AudioAttributesUsage.alarm,
      enableVibration: true,
    );
    await _notificationsPlugin.show(
      id: _notificationId('prayer-audio-test-${prayer.name}'),
      title: 'اختبار صوت صلاة ${prayer.arabicLabel}',
      body: 'إذا سمعت «حان وقت صلاة ${prayer.arabicLabel}» فالصوت المحلي يعمل.',
      notificationDetails: NotificationDetails(android: androidDetails),
      payload: prayerDeepLink(prayer, extraQuery: const {'audioTest': 'true'}),
    );
  }

  Future<void> cancelPrayerNotifications(List<PrayerDay> days) async {
    await init();
    for (final day in days) {
      for (final name in PrayerName.values) {
        await _notificationsPlugin.cancel(
          id: _prayerNotificationId(day.gregorianDate, name),
        );
      }
    }
  }

  String _prayerChannelId(PrayerName name, {required bool withAudio}) {
    final mode = withAudio ? 'audio' : 'silent';
    return 'prayer_${mode}_${name.name}_v2';
  }

  AndroidNotificationSound _prayerAudioSound(PrayerName name) {
    return UriAndroidNotificationSound(
      _prayerAudioUris[name] ??
          'android.resource://com.athr.athr/raw/prayer_${name.name}',
    );
  }

  int _prayerNotificationId(DateTime day, PrayerName name) {
    return _notificationId(
      'prayer-${day.year}-${day.month}-${day.day}-${name.name}',
    );
  }

  Future<bool> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      // Android versions before API 33 do not expose a runtime notification
      // permission. The plugin therefore returns null even though posting a
      // user-selected local reminder is allowed by the platform.
      return await androidImplementation.requestNotificationsPermission() ??
          true;
    }

    return false;
  }
}

class NotificationThreadRoute {
  final String threadId;
  final String sourceRoute;

  const NotificationThreadRoute({
    required this.threadId,
    required this.sourceRoute,
  });
}

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:midrar/core/memory/domain/memory_contracts.dart';
import 'package:midrar/core/memory/domain/reminder_intent.dart';
import 'package:midrar/features/prayer/application/prayer_times.dart';
import 'package:midrar/features/prayer/application/prayer_notification_planner.dart';
import 'package:midrar/features/settings/providers/azkar_wird_settings_provider.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool _prayerAudioLoaded = false;
  final Map<PrayerName, String> _prayerAudioUris = {};
  String? _pendingDeepLink;
  void Function(String deepLink)? _deepLinkHandler;

  /// Initializes the plugin, timezone database, and pending deep-link
  /// delivery. Must be called before [runApp] so cold-start notification
  /// taps are never lost; subsequent calls are no-ops.
  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

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

  /// Resolves native prayer-audio resource URIs once per process. Kept out
  /// of [init] so cold-start delivery stays minimal; invoked by the first
  /// scheduling path that needs sounds.
  Future<void> ensurePrayerAudioLoaded() async {
    if (_prayerAudioLoaded) return;
    _prayerAudioLoaded = true;
    await _loadPrayerAudioUris();
  }

  Future<void> _loadPrayerAudioUris() async {
    if (!Platform.isAndroid) return;
    const channel = MethodChannel('midrar/prayer_audio');
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

    // Exact alarms on Android 14+ require the SCHEDULE_EXACT_ALARM grant;
    // request it for user-chosen reminders just like prayer notifications so
    // reminders never silently degrade to inexact delivery.
    if (Platform.isAndroid) {
      final android = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final exactAllowed = await android?.canScheduleExactNotifications();
      if (exactAllowed == false) {
        await android?.requestExactAlarmsPermission();
      }
    }

    const androidDetails = AndroidNotificationDetails(
      'memory_thread_reminders',
      'تذكيرات خيوط العودة',
      channelDescription: 'تذكيرات اختارها المستخدم لخيوط الذاكرة فقط',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const darwinReminderDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _notificationsPlugin.zonedSchedule(
      id: _notificationId(intent.id),
      title: 'عودة إلى خيطك',
      body: thread.source.sourceLabel,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: darwinReminderDetails,
        macOS: darwinReminderDetails,
      ),
      payload: deepLink,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelReminderIntent(ReminderIntent intent) async {
    await init();
    await _notificationsPlugin.cancel(id: _notificationId(intent.id));
  }

  /// Schedules the upcoming user-selected prayers from an actual dated
  /// timetable. The decision logic lives in [planPrayerNotifications] (pure,
  /// test-verified); this method only executes it against the OS.
  Future<void> schedulePrayerNotifications({
    required PrayerSchedule schedule,
    required PrayerSettings settings,
  }) async {
    await init();
    await ensurePrayerAudioLoaded();
    if (!settings.notificationsEnabled) {
      await cancelPrayerNotifications(schedule.days);
      return;
    }
    final granted = await requestPermission();
    if (!granted) {
      throw StateError('يلزم السماح بالإشعارات لتفعيل تنبيهات الصلاة.');
    }

    if (Platform.isAndroid) {
      final android = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final exactAllowed = await android?.canScheduleExactNotifications();
      if (exactAllowed == false) {
        await android?.requestExactAlarmsPermission();
      }
    }

    final now = tz.TZDateTime.now(_safeLocal());
    final plans = planPrayerNotifications(
      schedule: schedule,
      settings: settings,
      now: now,
      idFor: prayerNotificationId,
    );

    // Cancel everything in the window first so stale alarms from previous
    // settings (method/madhhab/location changes) never linger.
    await cancelPrayerNotifications(schedule.days);

    for (final plan in plans) {
      final channelId = _prayerChannelId(plan.name, withAudio: plan.withSound);
      final androidDetails = AndroidNotificationDetails(
        channelId,
        'أذان صلاة ${plan.name.arabicLabel}',
        channelDescription: plan.withSound
            ? 'يشغل صوت الأذان الشرعي عند موعد صلاة ${plan.name.arabicLabel}.'
            : 'تنبيه صامت لصلاة ${plan.name.arabicLabel}.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: plan.withSound,
        sound: plan.withSound ? _prayerAudioSound(plan.name) : null,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        enableVibration: plan.withSound,
      );
      final darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: plan.withSound,
        sound: plan.withSound
            ? (plan.name == PrayerName.fajr ? 'adhan_fajr.wav' : 'adhan.wav')
            : null,
      );
      await _notificationsPlugin.zonedSchedule(
        id: plan.id,
        title: plan.title,
        body: plan.body,
        scheduledDate: plan.at,
        notificationDetails: NotificationDetails(
          android: androidDetails,
          iOS: darwinDetails,
          macOS: darwinDetails,
        ),
        payload: plan.payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  tz.Location _safeLocal() {
    try {
      return tz.getLocation('UTC');
    } catch (_) {
      return tz.UTC;
    }
  }

  Future<void> schedulePrayerAudioTest(PrayerName prayer) async {
    await init();
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 15));
    final androidDetails = AndroidNotificationDetails(
      _prayerChannelId(prayer, withAudio: true),
      'اختبار أذان صلاة ${prayer.arabicLabel}',
      channelDescription:
          'اختبار مجدول لصوت الأذان الشرعي بعد خروج التطبيق من الواجهة.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: _prayerAudioSound(prayer),
      audioAttributesUsage: AudioAttributesUsage.alarm,
      enableVibration: true,
    );
    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: prayer == PrayerName.fajr ? 'adhan_fajr.wav' : 'adhan.wav',
    );
    await _notificationsPlugin.zonedSchedule(
      id: _notificationId('prayer-adhan-background-test-${prayer.name}'),
      title: 'حان وقت صلاة ${prayer.arabicLabel}',
      body: '«اللهُ أَكْبَرُ، اللهُ أَكْبَرُ» · هذا اختبار لصوت الأذان الشرعي.',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      ),
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
      'اختبار أذان صلاة ${prayer.arabicLabel}',
      channelDescription: 'اختبار فوري لصوت الأذان الشرعي.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: _prayerAudioSound(prayer),
      audioAttributesUsage: AudioAttributesUsage.alarm,
      enableVibration: true,
    );
    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: prayer == PrayerName.fajr ? 'adhan_fajr.wav' : 'adhan.wav',
    );
    await _notificationsPlugin.show(
      id: _notificationId('prayer-adhan-test-${prayer.name}'),
      title: 'صوت الأذان: صلاة ${prayer.arabicLabel}',
      body: '«اللهُ أَكْبَرُ، اللهُ أَكْبَرُ» · حان الآن موعد صلاة ${prayer.arabicLabel}.',
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      ),
      payload: prayerDeepLink(prayer, extraQuery: const {'audioTest': 'true'}),
    );
  }

  static const int azkarMorningId = 2001;
  static const int azkarEveningId = 2002;
  static const int azkarSleepId = 2003;
  static const int quranWirdId = 2004;

  Future<void> scheduleAzkarAndWirdNotifications(
    AzkarWirdSettings settings,
  ) async {
    await init();
    final granted = await requestPermission();
    if (!granted) return;

    if (Platform.isAndroid) {
      final android = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final exactAllowed = await android?.canScheduleExactNotifications();
      if (exactAllowed == false) {
        await android?.requestExactAlarmsPermission();
      }
    }

    await cancelAzkarAndWirdNotifications();

    const androidDetails = AndroidNotificationDetails(
      'azkar_and_wird_reminders_v1',
      'أذكار وورد القرآن اليومي',
      channelDescription:
          'تنبيهات يومية لأذكار الصباح والمساء والنوم والورد القرآني بصوت واضح.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final now = tz.TZDateTime.now(tz.local);

    if (settings.morningEnabled) {
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        settings.morningHour,
        settings.morningMinute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _notificationsPlugin.zonedSchedule(
        id: azkarMorningId,
        title: 'أذكار الصباح',
        body: '«أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ» · ابدأ يومك بذكر الله وحصنك اليومي.',
        scheduledDate: scheduled,
        notificationDetails: details,
        payload: '/azkar/أذكار الصباح والمساء',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    if (settings.eveningEnabled) {
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        settings.eveningHour,
        settings.eveningMinute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _notificationsPlugin.zonedSchedule(
        id: azkarEveningId,
        title: 'أذكار المساء',
        body: '«أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ» · حصّن نفسك واختم نهارك بالذكر الطيب.',
        scheduledDate: scheduled,
        notificationDetails: details,
        payload: '/azkar/أذكار الصباح والمساء',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    if (settings.sleepEnabled) {
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        settings.sleepHour,
        settings.sleepMinute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _notificationsPlugin.zonedSchedule(
        id: azkarSleepId,
        title: 'أذكار النوم',
        body: '«بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي» · استودع نفسك وأهلك في حفظ الله قبل المنام.',
        scheduledDate: scheduled,
        notificationDetails: details,
        payload: '/azkar/أذكار النوم',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    if (settings.wirdEnabled) {
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        settings.wirdHour,
        settings.wirdMinute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _notificationsPlugin.zonedSchedule(
        id: quranWirdId,
        title: 'وردك القرآني اليومي',
        body: '«وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا» · موعد وردك اليومي، واصل القراءة من حيث توقفت.',
        scheduledDate: scheduled,
        notificationDetails: details,
        payload: '/quran',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelAzkarAndWirdNotifications() async {
    await init();
    await _notificationsPlugin.cancel(id: azkarMorningId);
    await _notificationsPlugin.cancel(id: azkarEveningId);
    await _notificationsPlugin.cancel(id: azkarSleepId);
    await _notificationsPlugin.cancel(id: quranWirdId);
  }

  Future<void> showTestNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    await init();
    const androidDetails = AndroidNotificationDetails(
      'azkar_and_wird_reminders_v1',
      'أذكار وورد القرآن اليومي',
      channelDescription:
          'تنبيهات يومية لأذكار الصباح والمساء والنوم والورد القرآني بصوت واضح.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _notificationsPlugin.show(
      id: 9999,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      ),
      payload: payload,
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
    return 'prayer_adhan_${mode}_${name.name}_v3';
  }

  AndroidNotificationSound _prayerAudioSound(PrayerName name) {
    final soundName = name == PrayerName.fajr ? 'adhan_fajr' : 'adhan';
    return RawResourceAndroidNotificationSound(soundName);
  }

  int _prayerNotificationId(DateTime day, PrayerName name) {
    return _notificationId(
      'prayer-${day.year}-${day.month}-${day.day}-${name.name}',
    );
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
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
    if (Platform.isIOS || Platform.isMacOS) {
      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iosImplementation?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
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

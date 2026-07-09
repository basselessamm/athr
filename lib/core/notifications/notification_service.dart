import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'daily_messages.dart';
import 'notification_ids.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    if (!kIsWeb && Platform.isWindows) {
      _initialized = true;
      return;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        selectNotificationStream.add(response.payload);
      },
    );

    _initialized = true;
  }

  Future<String?> getInitialPayload() async {
    if (!_isSupported) return null;
    final details = await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      return details.notificationResponse?.payload;
    }
    return null;
  }

  void dispose() {
    selectNotificationStream.close();
  }

  bool get _isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<bool> requestPermissions() async {
    if (!_isSupported) return false;
    
    bool? granted = false;
    
    final androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
            
    if (androidImplementation != null) {
      granted = await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    final iosImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
            
    if (iosImplementation != null) {
      granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    
    return granted ?? false;
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
  }) async {
    if (!_isSupported) return;

    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_habits_channel',
          'عادات إيمانية',
          channelDescription: 'تنبيهات الأوراد والأذكار',
          importance: Importance.high,
          priority: Priority.high,
          color: Color(0xFF1B5E20),
          ledColor: Color(0xFF1B5E20),
          ledOnMs: 1000,
          ledOffMs: 500,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    if (!_isSupported) return;
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAll() async {
    if (!_isSupported) return;
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // --- Specialized methods ---

  Future<void> scheduleMorningAzkar(TimeOfDay time, {bool enabled = true}) async {
    if (!enabled) {
      await cancelNotification(NotificationIds.morningAzkar);
      return;
    }
    await scheduleDailyNotification(
      id: NotificationIds.morningAzkar,
      title: 'أذكار الصباح ☀️',
      body: 'حان وقت أذكار الصباح لتبدأ يومك بذكر الله وتوفيقه.',
      time: time,
      payload: 'morning_azkar',
    );
  }

  Future<void> scheduleEveningAzkar(TimeOfDay time, {bool enabled = true}) async {
    if (!enabled) {
      await cancelNotification(NotificationIds.eveningAzkar);
      return;
    }
    await scheduleDailyNotification(
      id: NotificationIds.eveningAzkar,
      title: 'أذكار المساء 🌙',
      body: 'حان وقت أذكار المساء، حصن نفسك واختم يومك بذكر الله.',
      time: time,
      payload: 'evening_azkar',
    );
  }

  Future<void> scheduleQuranReminders({bool enabled = true}) async {
    if (!enabled) {
      await cancelQuranReminders();
      return;
    }
    
    await _scheduleRepeatingStartingFrom(
      id: NotificationIds.quranReminder1,
      title: 'ورد القرآن 📖',
      body: 'لا تنسَ نصيبك من القرآن اليوم، ولو صفحات قليلة تضيء يومك.',
      time: const TimeOfDay(hour: 12, minute: 0),
    );
    await _scheduleRepeatingStartingFrom(
      id: NotificationIds.quranReminder2,
      title: 'تذكير بورد القرآن 📖',
      body: 'الوقت يمضي.. هل قرأت وردك القرآني اليوم؟',
      time: const TimeOfDay(hour: 16, minute: 0),
    );
    await _scheduleRepeatingStartingFrom(
      id: NotificationIds.quranReminder3,
      title: 'القرآن شفاء 📖',
      body: 'قبل أن ينتهي اليوم، اختمه بآيات من القرآن الكريم.',
      time: const TimeOfDay(hour: 20, minute: 0),
    );
  }

  Future<void> _scheduleRepeatingStartingFrom({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    bool startTomorrow = false,
  }) async {
    if (!_isSupported) return;

    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    if (startTomorrow) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'quran_reminders_channel',
          'تنبيهات القرآن',
          channelDescription: 'تنبيهات ورد القرآن اليومي',
          importance: Importance.high,
          priority: Priority.high,
          color: Color(0xFF1B5E20),
          ledColor: Color(0xFF1B5E20),
          ledOnMs: 1000,
          ledOffMs: 500,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'quran',
    );
  }

  Future<void> markQuranAsReadForToday() async {
    await cancelQuranReminders();
    await _scheduleRepeatingStartingFrom(
      id: NotificationIds.quranReminder1,
      title: 'ورد القرآن 📖',
      body: 'لا تنسَ نصيبك من القرآن اليوم، ولو صفحات قليلة تضيء يومك.',
      time: const TimeOfDay(hour: 12, minute: 0),
      startTomorrow: true,
    );
    await _scheduleRepeatingStartingFrom(
      id: NotificationIds.quranReminder2,
      title: 'تذكير بورد القرآن 📖',
      body: 'الوقت يمضي.. هل قرأت وردك القرآني اليوم؟',
      time: const TimeOfDay(hour: 16, minute: 0),
      startTomorrow: true,
    );
    await _scheduleRepeatingStartingFrom(
      id: NotificationIds.quranReminder3,
      title: 'القرآن شفاء 📖',
      body: 'قبل أن ينتهي اليوم، اختمه بآيات من القرآن الكريم.',
      time: const TimeOfDay(hour: 20, minute: 0),
      startTomorrow: true,
    );
  }

  Future<void> cancelQuranReminders() async {
    await cancelNotification(NotificationIds.quranReminder1);
    await cancelNotification(NotificationIds.quranReminder2);
    await cancelNotification(NotificationIds.quranReminder3);
  }

  Future<void> scheduleAthrMessage({bool enabled = true}) async {
    if (!_isSupported) return;

    if (!enabled) {
      for (int i = 0; i < 30; i++) {
        await cancelNotification(NotificationIds.athrBaseId + i);
      }
      return;
    }
    
    for (int i = 0; i < 30; i++) {
      await cancelNotification(NotificationIds.athrBaseId + i);
    }
    
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, 13, 0); 
        
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final epochDay = (now.millisecondsSinceEpoch / 86400000).floor();

    for (int i = 0; i < 30; i++) {
      final msgIndex = (epochDay + i) % dailyMessages.length;
      final msg = dailyMessages[msgIndex];
      
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: NotificationIds.athrBaseId + i, 
        title: 'أثر اليوم 🌿',
        body: msg,
        scheduledDate: scheduledDate.add(Duration(days: i)),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'athr_messages_channel',
            'رسائل أثر',
            channelDescription: 'رسائل يومية للإلهام',
            importance: Importance.defaultImportance,
            styleInformation: BigTextStyleInformation(msg),
            color: const Color(0xFF1B5E20),
            ledColor: const Color(0xFF1B5E20),
            ledOnMs: 1000,
            ledOffMs: 500,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'athr',
      );
    }
  }
}

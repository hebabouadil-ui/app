import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local (offline) notifications used purely for re-engagement. No push
/// servers, no network — privacy friendly.
class NotificationsService {
  NotificationsService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'daily_reminders';
  static const String _channelName = 'Daily Reminders';
  static const String _channelDescription =
      'Fun daily prediction and streak reminders';

  /// Rotating copy that nudges users back without being pushy.
  static const List<({String title, String body})> _dailyMessages = [
    (title: '🔮 Your daily prediction is ready', body: 'See what today has in store for you!'),
    (title: '✨ Your aura score may have changed', body: 'Tap to reveal today\'s glow.'),
    (title: '🔥 Keep your streak alive', body: 'Check in today so you don\'t lose your streak!'),
    (title: '🎯 Today\'s challenge awaits', body: 'Complete it to earn XP and a new badge.'),
    (title: '🌟 A positive message for you', body: 'Start your day with a little spark.'),
  ];

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(tz.local.name));
    } catch (_) {
      // Fall back to UTC if the local zone can't be resolved.
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  /// Requests OS notification permission (Android 13+, iOS). Returns granted.
  Future<bool> requestPermission() async {
    await init();
    final AndroidFlutterLocalNotificationsPlugin? android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final IOSFlutterLocalNotificationsPlugin? ios =
        _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    bool granted = true;
    try {
      if (android != null) {
        granted = await android.requestNotificationsPermission() ?? false;
      }
      if (ios != null) {
        granted = await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } catch (e) {
      debugPrint('Notification permission error: $e');
    }
    return granted;
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

  /// Schedules a daily reminder at [hour]:[minute] local time. Each weekday
  /// uses a rotating message so the notifications feel fresh.
  Future<void> scheduleDailyReminders({int hour = 10, int minute = 0}) async {
    await init();
    await cancelAll();
    // Schedule a primary morning reminder + an evening streak nudge.
    await _scheduleDaily(id: 100, hour: hour, minute: minute, messageIndex: 0);
    await _scheduleDaily(id: 101, hour: 20, minute: 30, messageIndex: 2);
  }

  Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required int messageIndex,
  }) async {
    final msg = _dailyMessages[messageIndex % _dailyMessages.length];
    try {
      await _plugin.zonedSchedule(
        id,
        msg.title,
        msg.body,
        _nextInstanceOf(hour, minute),
        _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // repeats daily
      );
    } catch (e) {
      debugPrint('scheduleDaily failed: $e');
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// One-off immediate-ish notification (used for testing from Settings).
  Future<void> showNow(String title, String body) async {
    await init();
    await _plugin.show(1, title, body, _details);
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}

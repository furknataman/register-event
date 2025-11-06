import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_badge_manager/flutter_badge_manager.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class LocalNoticeService {
  LocalNoticeService._internal();

  static final LocalNoticeService _instance = LocalNoticeService._internal();

  factory LocalNoticeService() => _instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> setup() async {
    if (_isInitialized) {
      return;
    }

    const androidSetting =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    try {
      await _localNotificationsPlugin.initialize(initSettings);
      _isInitialized = true;
      debugPrint('setupPlugin: setup success');

      await _configureAndroidChannel();
    } catch (error) {
      debugPrint('Local notifications init error: $error');
    }
  }

  Future<void> addNotification(String? channel, String? title, String? body,
      int? endTime, int id) async {
    await setup();
    if (endTime == null || channel == null) {
      debugPrint('Scheduled notification skipped due to missing data');
      return;
    }

    tzdata.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    final androidDetail = AndroidNotificationDetails(
      channel,
      channel,
      priority: Priority.max,
      importance: Importance.max,
      styleInformation: const DefaultStyleInformation(true, true),
    );

    const iosDetail = DarwinNotificationDetails();
    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    await setup();
    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails(),
      payload: payLoad,
    );
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> _configureAndroidChannel() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    const channel = AndroidNotificationChannel(
      'channelId',
      'channelName',
      description: 'Default notification channel',
      importance: Importance.max,
    );

    const badgeChannel = AndroidNotificationChannel(
      'badge_update_channel',
      'Badge Updates',
      description: 'Silent notifications for badge count updates',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
      showBadge: true,
    );

    final androidPlugin =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
    await androidPlugin?.createNotificationChannel(badgeChannel);
  }

  Future<void> updateAppBadge(int count) async {
    await setup();

    try {
      final badge = FlutterBadgeManager.instance;
      final isSupported = await badge.isSupported();

      if (isSupported) {
        if (count > 0) {
          await badge.update(count);
          debugPrint('App badge updated to: $count');
        } else {
          await badge.remove();
          debugPrint('App badge cleared');
        }
      } else {
        debugPrint('App badge not supported on this platform');
      }
    } catch (e) {
      debugPrint('Error updating app badge: $e');
    }
  }

  Future<void> clearAppBadge() async {
    await updateAppBadge(0);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class LocalNoticeService {
  LocalNoticeService();
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSetting = DarwinInitializationSettings();

    // #2
    const initSettings = InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  Future<void> addNotification(
      String? channel, String? title, String? body, int? endTime) async {
    // #1
    tzdata.initializeTimeZones();
    final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime!);

// #2
    final androidDetail = AndroidNotificationDetails(
        channel!, // channel Id
        channel, // channel Name
        priority: Priority.max,
        importance: Importance.max,
        styleInformation: const DefaultStyleInformation(true, true));

    const iosDetail = DarwinNotificationDetails();
    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

// #3
    const id = 1;

// #4
    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}

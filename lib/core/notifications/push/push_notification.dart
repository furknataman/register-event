import 'dart:async';
import 'dart:io';

import 'package:autumn_conference/core/notifications/local/notification.dart';
import 'package:autumn_conference/core/services/api/service.dart';
import 'package:autumn_conference/features/notifications/domain/providers/notification_provider.dart';
import 'package:autumn_conference/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint(
        'Background message received: ${message.messageId} | ${message.data}');
  }
}

Future<void> configureFirebaseMessaging() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.setAutoInitEnabled(true);

  final permission = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    debugPrint(
        'Notification permission status: ${permission.authorizationStatus}');
  }

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _waitForApnsToken(messaging);
  }

  final fcmToken = await messaging.getToken();
  if (kDebugMode) {
    debugPrint('FCM token: $fcmToken');
  }

  messaging.onTokenRefresh.listen((token) async {
    if (kDebugMode) {
      debugPrint('FCM token refreshed: $token');
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceType;
      String deviceInfoStr;

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceType = 'ios';
        deviceInfoStr = '${iosInfo.name} - ${iosInfo.systemVersion} - ${iosInfo.model}';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceType = 'android';
        deviceInfoStr = '${androidInfo.brand} ${androidInfo.model} - Android ${androidInfo.version.release}';
      } else {
        deviceType = 'unknown';
        deviceInfoStr = 'Unknown Device';
      }

      final webService = globalContainer.read(webServiceProvider);
      await webService.registerFcmToken(token, deviceType, deviceInfoStr);
      if (kDebugMode) {
        debugPrint('FCM token registered to backend');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to register refreshed FCM token: $e');
      }
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('Foreground message: ${message.messageId} | ${message.data}');
    }
    unawaited(
      LocalNoticeService().showNotification(
        title: message.notification?.title ?? message.data['title']?.toString(),
        body: message.notification?.body ?? message.data['body']?.toString(),
      ),
    );

    // Refresh badge count when notification arrives
    try {
      globalContainer.invalidate(unreadCountProvider);

      // Update iOS app badge if badge count is in the payload
      final badgeCount = message.data['badge'] ?? message.data['unreadCount'];
      if (badgeCount != null) {
        final count = int.tryParse(badgeCount.toString()) ?? 0;
        unawaited(LocalNoticeService().updateAppBadge(count));
        if (kDebugMode) {
          debugPrint('iOS app badge updated to: $count');
        }
      }

      if (kDebugMode) {
        debugPrint('Badge count refreshed after FCM message');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to refresh badge count: $e');
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('Notification opened: ${message.messageId} | ${message.data}');
    }

    // Refresh badge count when notification is opened
    try {
      globalContainer.invalidate(unreadCountProvider);
      if (kDebugMode) {
        debugPrint('Badge count refreshed after notification opened');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to refresh badge count: $e');
      }
    }
  });
}

Future<void> _waitForApnsToken(FirebaseMessaging messaging) async {
  String? apnsToken = await messaging.getAPNSToken();
  if (apnsToken != null) {
    return;
  }

  while (apnsToken == null) {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    apnsToken = await messaging.getAPNSToken();
  }

  if (kDebugMode) {
    debugPrint('APNS token resolved');
  }
}

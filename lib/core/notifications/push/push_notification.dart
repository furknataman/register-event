import 'package:autumn_conference/core/notifications/local/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

void setFiraBase() async {
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // Önce permission iste
  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);

  // iOS için APNS token'ı al ve hazır olana kadar bekle
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    String? apnsToken;
    while (apnsToken == null) {
      apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  // FCM token al
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('FCM Token: $fcmToken');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    LocalNoticeService().showNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
  });
}

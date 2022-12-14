import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart';

import 'authentication/authservice.dart';
import 'notifiation/notification.dart';

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.pink,
          fontFamily: "Raleway",
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontSize: 24, color: Color(0xff333333), fontWeight: FontWeight.w400),
              displayMedium: TextStyle(
                  fontSize: 16, color: Color(0xff333333), fontWeight: FontWeight.w400),
              displaySmall: TextStyle(
                  fontSize: 16, color: Color(0xff828282), fontWeight: FontWeight.w400),
              bodyLarge: TextStyle(
                  fontSize: 18, color: Color(0xff333333), fontWeight: FontWeight.w400),
              labelLarge: TextStyle(
                  fontSize: 22, color: Color(0xff333333), fontWeight: FontWeight.w700),
              labelSmall: TextStyle(
                  fontSize: 10, color: Color(0xff333333), fontWeight: FontWeight.w400),
              titleMedium: TextStyle(
                  fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
              titleLarge: TextStyle(
                  fontSize: 33, color: Color(0xff333333), fontWeight: FontWeight.w400),
              labelMedium: TextStyle(
                  fontSize: 14, color: Color(0xff4F4F4F), fontWeight: FontWeight.w400))),
      home: AuthService().handleAuthState(),
    );
  }
}

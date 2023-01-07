import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'authentication/authservice.dart';
import 'notifiation/local_notification/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  await Firebase.initializeApp();
  await LocalNoticeService().setup();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,
      theme: _lightTheme,
      home: AuthService().handleAuthState(),
    );
  }
}

extension CustomColorScheme on ColorScheme {
  Color get unregister => brightness == Brightness.light
      ? const Color(0xffEB5757)
      : const Color.fromARGB(255, 144, 65, 65);

  List<Color> get cardColor => brightness == Brightness.light
      ? [
          const Color.fromRGBO(255, 255, 255, 1),
          const Color.fromRGBO(255, 255, 255, 0),
        ]
      : [
          const Color.fromRGBO(0, 0, 0, 1),
          const Color.fromRGBO(0, 0, 0, 0),
        ];

  Color get disable =>
      brightness == Brightness.light ? const Color(0xffE0E0E0) : const Color(0xff333333);
}

ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xff1E1E1E),
    fontFamily: "Raleway",
    primaryColor: const Color(0xdd242424),
    cardColor: const Color(0xff242424),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(
      0xff5B64A7,
    )),
    secondaryHeaderColor: const Color(0xffBDBDBD),
    textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontSize: 24, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        displayMedium:
            TextStyle(fontSize: 16, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        displaySmall:
            TextStyle(fontSize: 16, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        titleSmall:
            TextStyle(fontSize: 14, color: Color(0xff828282), fontWeight: FontWeight.w400),
        bodyLarge:
            TextStyle(fontSize: 18, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        labelLarge:
            TextStyle(fontSize: 22, color: Color(0xffBDBDBD), fontWeight: FontWeight.w700),
        labelSmall:
            TextStyle(fontSize: 10, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        titleMedium:
            TextStyle(fontSize: 18, color: Color(0xffBDBDBD), fontWeight: FontWeight.w700),
        titleLarge:
            TextStyle(fontSize: 33, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        bodySmall:
            TextStyle(fontSize: 16, color: Color(0xffBDBDBD), fontWeight: FontWeight.w700),
        labelMedium: TextStyle(
            fontSize: 14, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400)));

ThemeData _lightTheme = ThemeData(
    backgroundColor: Colors.white,
    secondaryHeaderColor: const Color(0xff333333),
    primaryColor: const Color(0xdd242424),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xff485FFF)),
    fontFamily: "Raleway",
    textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontSize: 24, color: Color(0xff333333), fontWeight: FontWeight.w400),
        displayMedium:
            TextStyle(fontSize: 16, color: Color(0xff333333), fontWeight: FontWeight.w400),
        displaySmall:
            TextStyle(fontSize: 16, color: Color(0xff828282), fontWeight: FontWeight.w400),
        titleSmall: TextStyle(
            height: 1.7,
            fontSize: 15,
            color: Color(0xff828282),
            fontWeight: FontWeight.w400),
        bodyLarge:
            TextStyle(fontSize: 18, color: Color(0xff333333), fontWeight: FontWeight.w400),
        labelLarge:
            TextStyle(fontSize: 22, color: Color(0xff333333), fontWeight: FontWeight.w700),
        labelSmall:
            TextStyle(fontSize: 10, color: Color(0xff333333), fontWeight: FontWeight.w400),
        titleMedium:
            TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
        bodySmall:
            TextStyle(fontSize: 16, color: Color(0xff4F4F4F), fontWeight: FontWeight.w700),
        titleLarge:
            TextStyle(fontSize: 33, color: Color(0xff333333), fontWeight: FontWeight.w400),
        labelMedium: TextStyle(
            fontSize: 14, color: Color(0xff4F4F4F), fontWeight: FontWeight.w400)));

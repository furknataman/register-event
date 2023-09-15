import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff1E1E1E),
    fontFamily: "Raleway",
    primaryColor: const Color(0xdd242424),
    splashColor: Colors.white,
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
            TextStyle(fontSize: 14, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        displaySmall:
            TextStyle(fontSize: 16, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400),
        titleSmall: TextStyle(
            height: 1.7,
            fontSize: 15,
            color: Color(0xff828282),
            fontWeight: FontWeight.w400),
        headlineLarge:
            TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
        bodyMedium:
            TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
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
            TextStyle(fontSize: 12, color: Color(0xffBDBDBD), fontWeight: FontWeight.w700),
        labelMedium: TextStyle(
            fontSize: 14, color: Color(0xffBDBDBD), fontWeight: FontWeight.w400)));

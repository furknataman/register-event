import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    secondaryHeaderColor: const Color(0xff333333),
    primaryColor: const Color(0xdd242424),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xff485FFF)),
    fontFamily: "Raleway",
    textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontSize: 24, color: Color(0xff333333), fontWeight: FontWeight.w400),
        displayMedium:
            TextStyle(fontSize: 16, color: Color(0xff333333), fontWeight: FontWeight.w500),
        displaySmall:
            TextStyle(fontSize: 16, color: Color(0xff828282), fontWeight: FontWeight.w400),
        titleSmall: TextStyle(
            height: 1.7,
            fontSize: 14,
            color: Color(0xff828282),
            fontWeight: FontWeight.w400),
        headlineLarge:
            TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
        bodyLarge:
            TextStyle(fontSize: 18, color: Color(0xff333333), fontWeight: FontWeight.w400),
        bodyMedium:
            TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
        labelLarge:
            TextStyle(fontSize: 22, color: Color(0xff333333), fontWeight: FontWeight.w700),
        labelSmall:
            TextStyle(fontSize: 10, color: Color(0xff333333), fontWeight: FontWeight.w400),
        titleMedium:
            TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
        bodySmall:
            TextStyle(fontSize: 12, color: Color(0xff4F4F4F), fontWeight: FontWeight.w700),
        titleLarge:
            TextStyle(fontSize: 33, color: Color(0xff333333), fontWeight: FontWeight.w400),
        labelMedium: TextStyle(
            fontSize: 14, color: Color(0xff4F4F4F), fontWeight: FontWeight.w400)));

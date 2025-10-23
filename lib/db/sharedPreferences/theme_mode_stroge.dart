import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveThemeMode(ThemeMode themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeMode', themeMode.toString());
}

Future<ThemeMode?> getThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final themeModeString = prefs.getString('themeMode');

  if (themeModeString == null) return null;

  switch (themeModeString) {
    case 'ThemeMode.light':
      return ThemeMode.light;
    case 'ThemeMode.dark':
      return ThemeMode.dark;
    case 'ThemeMode.system':
      return ThemeMode.system;
    default:
      return null;
  }
}

// Backward compatibility - deprecated
@Deprecated('Use saveThemeMode instead')
Future<void> setThemeData(bool themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", themeMode);
}

@Deprecated('Use getThemeMode instead')
Future<bool?> getThemeData() async {
  final prefs = await SharedPreferences.getInstance();
  final themeData = prefs.getBool('isDarkMode');
  return themeData;
}

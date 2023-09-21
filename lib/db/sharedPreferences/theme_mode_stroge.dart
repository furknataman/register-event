import 'package:shared_preferences/shared_preferences.dart';

Future<void> setThemeData(bool themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", themeMode);
}

Future<bool?> getThemeData() async {
  final prefs = await SharedPreferences.getInstance();
  final themeData = prefs.getBool('isDarkMode');
  return themeData;
}

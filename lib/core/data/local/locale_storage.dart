import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLocale(String languageCode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('locale', languageCode);
}

Future<String?> getLocale() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('locale');
}

import 'package:shared_preferences/shared_preferences.dart';

Future<void> setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}


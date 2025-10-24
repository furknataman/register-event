import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../models/auth_response.dart';
import '../../../../core/data/local/token_stroge.dart' as token_storage;

abstract class AuthLocalDataSource {
  Future<void> saveUser(AuthResponse authResponse);
  Future<User?> getUser();
  Future<void> clearUser();
  
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userKey = 'user_data';
  static const String _refreshTokenKey = 'refresh_token';

  AuthLocalDataSourceImpl();

  @override
  Future<void> saveUser(AuthResponse authResponse) async {
    final userModel = authResponse.user;
    final userJson = jsonEncode(userModel.toJson());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userJson);
  }

  @override
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userMap);
      return userModel.toDomain();
    } catch (e) {
      // If there's an error parsing user data, clear it
      await clearUser();
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await token_storage.setToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await token_storage.getToken();
  }

  @override
  Future<void> clearToken() async {
    await token_storage.logout();
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
  }
}
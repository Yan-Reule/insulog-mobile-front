import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedLoginData {
  final int userId;
  final String username;
  final String passwordHash;
  final String token;

  const SavedLoginData({
    required this.userId,
    required this.username,
    required this.passwordHash,
    required this.token,
  });
}

class SavedLoginService {
  static const String _userIdKey = 'saved_user_id';
  static const String _usernameKey = 'saved_username';
  static const String _passwordKey = 'saved_password_hash';
  static const String _tokenKey = 'saved_token';

  static String hashPassword(String password) {
    final digest = sha256.convert(utf8.encode(password.trim()));
    return digest.toString();
  }

  Future<void> saveCredentials({
    required int userId,
    required String username,
    required String password,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username.trim());
    await prefs.setString(_passwordKey, hashPassword(password));
    await prefs.setString(_tokenKey, token.trim());
  }

  Future<SavedLoginData?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    final username = prefs.getString(_usernameKey);
    final passwordHash = prefs.getString(_passwordKey);
    final token = prefs.getString(_tokenKey);

    if (userId == null || username == null || passwordHash == null || token == null) {
      return null;
    }

    if (userId <= 0 || username.isEmpty || passwordHash.isEmpty || token.isEmpty) {
      return null;
    }

    return SavedLoginData(
      userId: userId,
      username: username,
      passwordHash: passwordHash,
      token: token,
    );
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_tokenKey);
  }
}

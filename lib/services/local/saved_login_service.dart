import 'package:shared_preferences/shared_preferences.dart';

class SavedLoginData {
  final String username;
  final String password;

  const SavedLoginData({
    required this.username,
    required this.password,
  });
}

class SavedLoginService {
  static const String _usernameKey = 'saved_username';
  static const String _passwordKey = 'saved_password';

  Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  Future<SavedLoginData?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    final password = prefs.getString(_passwordKey);

    if (username == null || password == null) {
      return null;
    }

    if (username.isEmpty || password.isEmpty) {
      return null;
    }

    return SavedLoginData(username: username, password: password);
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
  }
}

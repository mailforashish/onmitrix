import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onmitrix/models/login_response.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  late SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _keyUser = 'user';
  static const String _keyToken = 'token';
  static const String _keyTheme = 'theme';
  static const String _keyLanguage = 'language';

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User Session Management
  Future<void> setUser(LoginResponse user) async {
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
    await _prefs.setString(_keyToken, user.token);
  }

  Future<LoginResponse?> getUser() async {
    final userStr = _prefs.getString(_keyUser);
    if (userStr == null) return null;

    try {
      final userJson = jsonDecode(userStr) as Map<String, dynamic>;
      return LoginResponse.fromJson(userJson);
    } catch (e) {
      await clearSession();
      return null;
    }
  }

  String? getToken() {
    return _prefs.getString(_keyToken);
  }

  Future<bool> isLoggedIn() async {
    if (!isInitialized) {
      await init();
    }
    return _prefs.containsKey(_keyToken);
  }

  // Theme Management
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_keyTheme, isDark);
  }

  bool isDarkMode() {
    return _prefs.getBool(_keyTheme) ?? false;
  }

  // Language Management
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_keyLanguage, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'en';
  }

  // Clear Session
  Future<void> clearSession() async {
    // Keep theme and language preferences when logging out
    final isDark = isDarkMode();
    final language = getLanguage();
    
    await _prefs.clear();
    
    // Restore theme and language preferences
    await setDarkMode(isDark);
    await setLanguage(language);
  }

  // Clear Everything
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Check if first time launch
  bool isFirstTimeLaunch() {
    return _prefs.getBool('first_time') ?? true;
  }

  Future<void> setFirstTimeLaunch(bool value) async {
    await _prefs.setBool('first_time', value);
  }

  // App Settings
  Future<void> setSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  T? getSetting<T>(String key) {
    return _prefs.get(key) as T?;
  }

  // Check if initialized
  bool get isInitialized => _prefs != null;

  // Error handling wrapper
  Future<T?> safeOperation<T>(Future<T> Function() operation) async {
    try {
      if (!isInitialized) {
        await init();
      }
      return await operation();
    } catch (e) {
      print('SessionManager Error: $e');
      return null;
    }
  }
}
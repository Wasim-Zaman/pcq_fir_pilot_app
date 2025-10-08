import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for SharedPreferences
class PrefsKeys {
  static const String token = 'auth_token';
  static const String memberData = 'member_data';
  static const String isLoggedIn = 'is_logged_in';
}

/// Service class for SharedPreferences operations
class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  // Token operations
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(PrefsKeys.token, token);
  }

  String? getToken() {
    return _prefs.getString(PrefsKeys.token);
  }

  Future<bool> removeToken() async {
    return await _prefs.remove(PrefsKeys.token);
  }

  // Member data operations
  Future<bool> saveMemberData(Map<String, dynamic> memberData) async {
    final jsonString = jsonEncode(memberData);
    return await _prefs.setString(PrefsKeys.memberData, jsonString);
  }

  Map<String, dynamic>? getMemberData() {
    final jsonString = _prefs.getString(PrefsKeys.memberData);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> removeMemberData() async {
    return await _prefs.remove(PrefsKeys.memberData);
  }

  // Login status operations
  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(PrefsKeys.isLoggedIn, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(PrefsKeys.isLoggedIn) ?? false;
  }

  // Clear all data (logout)
  Future<bool> clearAll() async {
    await removeToken();
    await removeMemberData();
    await setLoggedIn(false);
    return true;
  }
}

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized first');
});

/// Provider for SharedPreferencesService
final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesService(prefs);
});

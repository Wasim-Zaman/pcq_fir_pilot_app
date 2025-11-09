import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for SharedPreferences
class PrefsKeys {
  static const String token = 'auth_token';
  static const String memberData = 'member_data';
  static const String isLoggedIn = 'is_logged_in';
  static const String biometricEnabled = 'biometric_enabled';
  static const String biometricEmail = 'biometric_email';
  static const String biometricPassword = 'biometric_password';
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

  // User ID retrieval
  String? getUserId() {
    final memberData = getMemberData();
    return memberData != null ? memberData['id'] as String? : null;
  }

  // Biometric authentication operations
  Future<bool> setBiometricEnabled(bool value) async {
    return await _prefs.setBool(PrefsKeys.biometricEnabled, value);
  }

  bool isBiometricEnabled() {
    return _prefs.getBool(PrefsKeys.biometricEnabled) ?? false;
  }

  Future<bool> saveBiometricCredentials({
    required String email,
    required String password,
  }) async {
    final emailSaved = await _prefs.setString(PrefsKeys.biometricEmail, email);
    final passwordSaved = await _prefs.setString(
      PrefsKeys.biometricPassword,
      password,
    );
    return emailSaved && passwordSaved;
  }

  String? getBiometricEmail() {
    return _prefs.getString(PrefsKeys.biometricEmail);
  }

  String? getBiometricPassword() {
    return _prefs.getString(PrefsKeys.biometricPassword);
  }

  Future<bool> removeBiometricCredentials() async {
    await _prefs.remove(PrefsKeys.biometricEmail);
    await _prefs.remove(PrefsKeys.biometricPassword);
    await setBiometricEnabled(false);
    return true;
  }

  bool hasBiometricCredentials() {
    return getBiometricEmail() != null && getBiometricPassword() != null;
  }

  // Clear all data (logout)
  Future<bool> clearAll() async {
    await removeToken();
    await removeMemberData();
    await setLoggedIn(false);
    // Note: We don't clear biometric credentials on logout
    // User can disable it manually
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

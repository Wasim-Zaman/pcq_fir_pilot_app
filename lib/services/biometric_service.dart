import 'dart:developer' as dev;

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Service for handling biometric authentication
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometric authentication
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      dev.log(
        'Error checking biometrics: ${e.message}',
        name: 'BiometricService',
      );
      return false;
    }
  }

  /// Check if device is supported for biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      dev.log(
        'Error checking device support: ${e.message}',
        name: 'BiometricService',
      );
      return false;
    }
  }

  /// Check if biometrics are available on device
  Future<bool> isBiometricsAvailable() async {
    try {
      final canCheck = await canCheckBiometrics();
      final isSupported = await isDeviceSupported();
      return canCheck && isSupported;
    } catch (e) {
      dev.log(
        'Error checking biometrics availability: $e',
        name: 'BiometricService',
      );
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      dev.log(
        'Error getting available biometrics: ${e.message}',
        name: 'BiometricService',
      );
      return [];
    }
  }

  /// Authenticate with biometrics only
  Future<BiometricAuthResult> authenticateWithBiometrics({
    required String localizedReason,
  }) async {
    try {
      final bool authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
      );

      return authenticated
          ? BiometricAuthResult.success()
          : BiometricAuthResult.failed('Authentication failed');
    } on PlatformException catch (e) {
      dev.log(
        'Biometric authentication error: ${e.code} - ${e.message}',
        name: 'BiometricService',
      );
      return _handlePlatformException(e);
    } catch (e) {
      dev.log('Unexpected authentication error: $e', name: 'BiometricService');
      return BiometricAuthResult.error('Unexpected error occurred');
    }
  }

  /// Authenticate with biometrics or device credentials (PIN/Pattern)
  Future<BiometricAuthResult> authenticateWithBiometricsOrCredentials({
    required String localizedReason,
  }) async {
    try {
      final bool authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: false,
      );

      return authenticated
          ? BiometricAuthResult.success()
          : BiometricAuthResult.failed('Authentication failed');
    } on PlatformException catch (e) {
      dev.log(
        'Authentication error: ${e.code} - ${e.message}',
        name: 'BiometricService',
      );
      return _handlePlatformException(e);
    } catch (e) {
      dev.log('Unexpected authentication error: $e', name: 'BiometricService');
      return BiometricAuthResult.error('Unexpected error occurred');
    }
  }

  /// Stop ongoing authentication
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
      dev.log('Authentication cancelled', name: 'BiometricService');
    } catch (e) {
      dev.log('Error stopping authentication: $e', name: 'BiometricService');
    }
  }

  /// Handle platform exceptions and return appropriate result
  BiometricAuthResult _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
        return BiometricAuthResult.notAvailable(
          'Biometric authentication not available',
        );
      case 'NotEnrolled':
        return BiometricAuthResult.notEnrolled(
          'No biometrics enrolled on device',
        );
      case 'LockedOut':
        return BiometricAuthResult.lockedOut(
          'Too many attempts. Try again later.',
        );
      case 'PermanentlyLockedOut':
        return BiometricAuthResult.permanentlyLockedOut(
          'Biometrics permanently locked. Use device settings.',
        );
      case 'PasscodeNotSet':
        return BiometricAuthResult.passcodeNotSet('Device passcode not set');
      default:
        return BiometricAuthResult.error(
          e.message ?? 'Authentication error: ${e.code}',
        );
    }
  }
}

/// Result of biometric authentication
class BiometricAuthResult {
  final BiometricAuthStatus status;
  final String? message;

  const BiometricAuthResult._({required this.status, this.message});

  factory BiometricAuthResult.success() {
    return const BiometricAuthResult._(status: BiometricAuthStatus.success);
  }

  factory BiometricAuthResult.failed(String message) {
    return BiometricAuthResult._(
      status: BiometricAuthStatus.failed,
      message: message,
    );
  }

  factory BiometricAuthResult.error(String message) {
    return BiometricAuthResult._(
      status: BiometricAuthStatus.error,
      message: message,
    );
  }

  factory BiometricAuthResult.notAvailable(String message) {
    return BiometricAuthResult._(
      status: BiometricAuthStatus.notAvailable,
      message: message,
    );
  }

  factory BiometricAuthResult.notEnrolled(String message) {
    return BiometricAuthResult._(
      status: BiometricAuthStatus.notEnrolled,
      message: message,
    );
  }

  factory BiometricAuthResult.lockedOut(String message) {
    return BiometricAuthResult._(
      status: BiometricAuthStatus.lockedOut,
      message: message,
    );
  }

  factory BiometricAuthResult.permanentlyLockedOut(String message) {
    return BiometricAuthResult._(
      status: BiometricAuthStatus.permanentlyLockedOut,
      message: message,
    );
  }

  factory BiometricAuthResult.passcodeNotSet(String message) {
    return BiometricAuthResult._(
      status: BiometricAuthStatus.passcodeNotSet,
      message: message,
    );
  }

  bool get isSuccess => status == BiometricAuthStatus.success;
  bool get isFailed => status == BiometricAuthStatus.failed;
  bool get isError => status == BiometricAuthStatus.error;
}

/// Status enum for biometric authentication
enum BiometricAuthStatus {
  success,
  failed,
  error,
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  passcodeNotSet,
}

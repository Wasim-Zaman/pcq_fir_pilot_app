import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Validation provider for form validations
/// Provides reusable validation logic for authentication forms
class ValidationNotifier extends Notifier<void> {
  @override
  void build() {
    // No state to initialize
  }

  /// Validates username
  /// Returns error message if validation fails, null otherwise
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  /// Validates password
  /// Returns error message if validation fails, null otherwise
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

/// Provider for validation logic
final validationProvider = NotifierProvider<ValidationNotifier, void>(() {
  return ValidationNotifier();
});

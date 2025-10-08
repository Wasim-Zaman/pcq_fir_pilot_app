import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Validation provider for form validations
/// Provides reusable validation logic for authentication forms
class ValidationNotifier extends Notifier<void> {
  @override
  void build() {
    // No state to initialize
  }

  /// Validates email
  /// Returns error message if validation fails, null otherwise
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
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

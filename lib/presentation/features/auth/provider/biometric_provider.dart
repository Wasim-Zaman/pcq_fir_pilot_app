import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pcq_fir_pilot_app/services/biometric_service.dart';
import 'package:pcq_fir_pilot_app/services/shared_preferences_service.dart';

/// Biometric authentication state
class BiometricState {
  final bool isAvailable;
  final bool isEnabled;
  final bool isLoading;
  final List<BiometricType> availableTypes;
  final String? error;

  const BiometricState({
    this.isAvailable = false,
    this.isEnabled = false,
    this.isLoading = false,
    this.availableTypes = const [],
    this.error,
  });

  BiometricState copyWith({
    bool? isAvailable,
    bool? isEnabled,
    bool? isLoading,
    List<BiometricType>? availableTypes,
    String? error,
  }) {
    return BiometricState(
      isAvailable: isAvailable ?? this.isAvailable,
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      availableTypes: availableTypes ?? this.availableTypes,
      error: error,
    );
  }
}

/// AsyncNotifier for biometric authentication business logic
class BiometricNotifier extends AsyncNotifier<BiometricState> {
  late final BiometricService _biometricService;
  late final SharedPreferencesService _prefsService;

  @override
  Future<BiometricState> build() async {
    _biometricService = BiometricService();
    _prefsService = ref.read(sharedPreferencesServiceProvider);

    // Check biometric availability
    final isAvailable = await _biometricService.isBiometricsAvailable();
    final availableTypes = await _biometricService.getAvailableBiometrics();
    final isEnabled = _prefsService.isBiometricEnabled();

    return BiometricState(
      isAvailable: isAvailable,
      isEnabled: isEnabled,
      availableTypes: availableTypes,
    );
  }

  /// Check biometric availability
  Future<void> checkAvailability() async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));

    final isAvailable = await _biometricService.isBiometricsAvailable();
    final availableTypes = await _biometricService.getAvailableBiometrics();

    state = AsyncValue.data(
      state.value!.copyWith(
        isAvailable: isAvailable,
        availableTypes: availableTypes,
        isLoading: false,
      ),
    );
  }

  /// Enable biometric authentication
  Future<bool> enableBiometric({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));

    try {
      // Authenticate to enable biometric
      final result = await _biometricService.authenticateWithBiometrics(
        localizedReason: 'Authenticate to enable fingerprint login',
      );

      if (result.isSuccess) {
        // Save credentials
        await _prefsService.saveBiometricCredentials(
          email: email,
          password: password,
        );
        await _prefsService.setBiometricEnabled(true);

        state = AsyncValue.data(
          state.value!.copyWith(isEnabled: true, isLoading: false),
        );
        return true;
      } else {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            error: result.message ?? 'Authentication failed',
          ),
        );
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(
          isLoading: false,
          error: 'Failed to enable biometric authentication',
        ),
      );
      return false;
    }
  }

  /// Disable biometric authentication
  Future<void> disableBiometric() async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));

    await _prefsService.removeBiometricCredentials();

    state = AsyncValue.data(
      state.value!.copyWith(isEnabled: false, isLoading: false),
    );
  }

  /// Authenticate with biometrics and return credentials
  Future<BiometricAuthCredentials?> authenticateAndGetCredentials() async {
    state = AsyncValue.data(state.value!.copyWith(isLoading: true));

    try {
      // Check if credentials are saved
      if (!_prefsService.hasBiometricCredentials()) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            error: 'No saved credentials',
          ),
        );
        return null;
      }

      // Authenticate with biometrics
      final result = await _biometricService.authenticateWithBiometrics(
        localizedReason: 'Authenticate to sign in',
      );

      if (result.isSuccess) {
        // Get saved credentials
        final email = _prefsService.getBiometricEmail();
        final password = _prefsService.getBiometricPassword();

        state = AsyncValue.data(state.value!.copyWith(isLoading: false));

        if (email != null && password != null) {
          return BiometricAuthCredentials(email: email, password: password);
        } else {
          state = AsyncValue.data(
            state.value!.copyWith(error: 'Credentials not found'),
          );
          return null;
        }
      } else {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            error: result.message ?? 'Authentication failed',
          ),
        );
        return null;
      }
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: 'Authentication error'),
      );
      return null;
    }
  }

  /// Reset error state
  void resetError() {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(error: null));
    });
  }
}

/// Credentials retrieved after biometric authentication
class BiometricAuthCredentials {
  final String email;
  final String password;

  BiometricAuthCredentials({required this.email, required this.password});
}

/// Provider for biometric authentication
final biometricProvider =
    AsyncNotifierProvider<BiometricNotifier, BiometricState>(() {
      return BiometricNotifier();
    });

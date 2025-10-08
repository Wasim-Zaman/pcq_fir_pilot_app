import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/models/member_model.dart';
import 'package:pcq_fir_pilot_app/repos/member_repo.dart';
import 'package:pcq_fir_pilot_app/services/shared_preferences_service.dart';

/// Sign-in state class to track authentication status
class SignInState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final Member? member;
  final String? token;

  const SignInState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.member,
    this.token,
  });

  SignInState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    Member? member,
    String? token,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      member: member ?? this.member,
      token: token ?? this.token,
    );
  }
}

/// AsyncNotifier for sign-in business logic
class SignInNotifier extends AsyncNotifier<SignInState> {
  @override
  Future<SignInState> build() async {
    // Check if user is already logged in
    final prefsService = ref.read(sharedPreferencesServiceProvider);
    final isLoggedIn = prefsService.isLoggedIn();

    if (isLoggedIn) {
      final token = prefsService.getToken();
      final memberData = prefsService.getMemberData();

      if (token != null && memberData != null) {
        final member = Member.fromJson(memberData);
        return SignInState(isAuthenticated: true, member: member, token: token);
      }
    }

    // Initialize with default state
    return const SignInState();
  }

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // Get member repository and prefs service
      final memberRepo = ref.read(memberRepoProvider);
      final prefsService = ref.read(sharedPreferencesServiceProvider);

      // Call login API
      final result = await memberRepo.login(email: email, password: password);

      // Handle API response
      if (result is ApiSuccess<Map<String, dynamic>>) {
        // Parse login response
        final loginResponse = LoginResponse.fromJson(result.data);

        // Save token and member data to SharedPreferences
        await prefsService.saveToken(loginResponse.token);
        await prefsService.saveMemberData(loginResponse.data.toJson());
        await prefsService.setLoggedIn(true);

        // Login successful
        state = AsyncValue.data(
          SignInState(
            isLoading: false,
            isAuthenticated: true,
            member: loginResponse.data,
            token: loginResponse.token,
          ),
        );
      } else if (result is ApiError<Map<String, dynamic>>) {
        // Login failed
        state = AsyncValue.data(
          SignInState(
            isLoading: false,
            isAuthenticated: false,
            error: result.message,
          ),
        );
      } else {
        // Handle other states (initial, loading)
        state = AsyncValue.data(
          const SignInState(isLoading: false, isAuthenticated: false),
        );
      }
    } catch (error, stackTrace) {
      // Set error state
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      // Clear all stored data
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      await prefsService.clearAll();

      state = AsyncValue.data(
        const SignInState(isLoading: false, isAuthenticated: false),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Reset error state
  void resetError() {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(error: null));
    });
  }
}

/// Provider for sign-in logic
final signInProvider = AsyncNotifierProvider<SignInNotifier, SignInState>(() {
  return SignInNotifier();
});

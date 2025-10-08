import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/repos/member_repo.dart';

/// Sign-in state class to track authentication status
class SignInState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const SignInState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  SignInState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// AsyncNotifier for sign-in business logic
class SignInNotifier extends AsyncNotifier<SignInState> {
  @override
  Future<SignInState> build() async {
    // Initialize with default state
    return const SignInState();
  }

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // Get member repository
      final memberRepo = ref.read(memberRepoProvider);

      // Call login API
      final result = await memberRepo.login(email: email, password: password);

      // Handle API response
      if (result is ApiSuccess<Map<String, dynamic>>) {
        // Login successful
        state = AsyncValue.data(
          const SignInState(isLoading: false, isAuthenticated: true),
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
      // TODO: Implement sign-out logic
      await Future.delayed(const Duration(milliseconds: 500));

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

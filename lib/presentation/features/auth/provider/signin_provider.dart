import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  /// Sign in with username and password
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // TODO: Implement actual sign-in logic here
      // Example:
      // final authService = ref.read(authServiceProvider);
      // await authService.signIn(username: username, password: password);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Set success state
      state = AsyncValue.data(
        const SignInState(isLoading: false, isAuthenticated: true),
      );
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

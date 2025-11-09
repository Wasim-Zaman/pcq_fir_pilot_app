import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/biometric_provider.dart';

/// Biometric authentication button for sign-in screen
class BiometricAuthButton extends ConsumerWidget {
  final VoidCallback onSuccess;

  const BiometricAuthButton({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricState = ref.watch(biometricProvider);

    return biometricState.when(
      data: (state) {
        // Only show if biometric is available and enabled
        if (!state.isAvailable || !state.isEnabled) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: state.isLoading
              ? null
              : () => _handleBiometricAuth(context, ref),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kPrimaryColor.withOpacity(0.1),
              border: Border.all(color: AppColors.kPrimaryColor, width: 2),
            ),
            child: state.isLoading
                ? SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.kPrimaryColor,
                      ),
                    ),
                  )
                : Icon(
                    Icons.fingerprint,
                    size: 48,
                    color: AppColors.kPrimaryColor,
                  ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _handleBiometricAuth(BuildContext context, WidgetRef ref) async {
    final credentials = await ref
        .read(biometricProvider.notifier)
        .authenticateAndGetCredentials();

    if (credentials != null) {
      onSuccess();
    }
  }
}

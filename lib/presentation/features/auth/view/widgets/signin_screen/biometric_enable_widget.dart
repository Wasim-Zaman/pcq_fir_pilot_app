import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/biometric_provider.dart';

/// Widget to enable/disable biometric authentication
class BiometricEnableWidget extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const BiometricEnableWidget({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<BiometricEnableWidget> createState() =>
      _BiometricEnableWidgetState();
}

class _BiometricEnableWidgetState extends ConsumerState<BiometricEnableWidget> {
  @override
  Widget build(BuildContext context) {
    final biometricState = ref.watch(biometricProvider);

    return biometricState.when(
      data: (state) {
        // Only show if biometric is available
        if (!state.isAvailable) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            16.heightBox,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.kPrimaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fingerprint,
                    color: AppColors.kPrimaryColor,
                    size: 32,
                  ),
                  16.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable Fingerprint Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kTextPrimaryColor,
                          ),
                        ),
                        4.heightBox,
                        Text(
                          state.isEnabled
                              ? 'Fingerprint login is enabled'
                              : 'Quick sign in with your fingerprint',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.kTextSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.widthBox,
                  Switch(
                    value: state.isEnabled,
                    onChanged: state.isLoading
                        ? null
                        : (value) => _handleToggle(value),
                    activeThumbColor: AppColors.kPrimaryColor,
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _handleToggle(bool value) async {
    if (value) {
      // Enable biometric
      final success = await ref
          .read(biometricProvider.notifier)
          .enableBiometric(email: widget.email, password: widget.password);

      if (mounted) {
        if (success) {
          CustomSnackbar.showNormal(
            context,
            'Fingerprint login enabled successfully!',
          );
        } else {
          final state = ref.read(biometricProvider).value;
          CustomSnackbar.showError(
            context,
            state?.error ?? 'Failed to enable fingerprint login',
          );
        }
      }
    } else {
      // Disable biometric
      await ref.read(biometricProvider.notifier).disableBiometric();

      if (mounted) {
        CustomSnackbar.showNormal(context, 'Fingerprint login disabled');
      }
    }
  }
}

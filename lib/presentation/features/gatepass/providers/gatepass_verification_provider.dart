import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/signin_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/providers/action_type_provider.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

/// State class for Gate Pass Scan operations
class GatePassScanState {
  final bool isScanning;
  final String? error;
  final String? successMessage;
  final Map<String, dynamic>? scanResult;

  const GatePassScanState({
    this.isScanning = false,
    this.error,
    this.successMessage,
    this.scanResult,
  });

  GatePassScanState copyWith({
    bool? isScanning,
    String? error,
    String? successMessage,
    Map<String, dynamic>? scanResult,
  }) {
    return GatePassScanState(
      isScanning: isScanning ?? this.isScanning,
      error: error,
      successMessage: successMessage,
      scanResult: scanResult ?? this.scanResult,
    );
  }
}

/// AsyncNotifier for Gate Pass Scan operations
class GatePassVerificationNotifier extends AsyncNotifier<GatePassScanState> {
  @override
  Future<GatePassScanState> build() async {
    return const GatePassScanState();
  }

  /// Internal method to perform scan and handle response
  Future<void> verifyGatepass({
    required BuildContext context,
    required String gatePassId,
    String? notes,
  }) async {
    // Set scanning state
    state = const AsyncValue.data(GatePassScanState(isScanning: true));
    final actionType = ref.read(actionTypeProvider).value;
    final actionTypeName = ref.read(actionTypeProvider).displayName;

    try {
      final member = ref.read(signInProvider).value?.member;
      if (member == null) {
        if (context.mounted) {
          CustomDialog.showScanErrorDialog(
            context,
            title: 'Verification Failed',
            message: 'User not authenticated',
          );
        }
        state = AsyncValue.data(
          GatePassScanState(isScanning: false, error: 'User not authenticated'),
        );
      }

      // Call scan API
      final result = await ref
          .read(gatepassRepoProvider)
          .verifyGatepass(
            scannedById: member?.id ?? '',
            gatePassId: gatePassId,
            actionType: actionType,
            notes: notes,
          );

      // Handle API response
      if (result is ApiSuccess<Map<String, dynamic>>) {
        final responseData = result.data;
        final message =
            responseData['message'] as String? ??
            '$actionTypeName completed successfully';

        // Update state with success
        state = AsyncValue.data(
          GatePassScanState(
            isScanning: false,
            successMessage: message,
            scanResult: responseData,
          ),
        );

        // Show success dialog and reset state after
        if (context.mounted) {
          CustomDialog.showScanSuccessDialog(
            context,
            title: '$actionTypeName Successful',
            message: message,
          );
          // Reset state after success
          resetState();
        }
      } else if (result is ApiError<Map<String, dynamic>>) {
        // Handle error
        final errorMessage = result.message;
        state = AsyncValue.data(
          GatePassScanState(isScanning: false, error: errorMessage),
        );

        // Show error dialog
        if (context.mounted) {
          CustomDialog.showScanErrorDialog(
            context,
            title: '$actionTypeName Failed',
            message: errorMessage,
          );
        }
      }
    } catch (e) {
      // Handle unexpected errors
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      state = AsyncValue.data(
        GatePassScanState(isScanning: false, error: errorMessage),
      );

      // Show error dialog
      if (context.mounted) {
        CustomDialog.showScanErrorDialog(
          context,
          title: '$actionTypeName Failed',
          message: errorMessage,
        );
      }
    }
  }

  /// Reset scan state
  void resetState() {
    state = const AsyncValue.data(GatePassScanState());
  }
}

/// Provider for Gate Pass Scan operations
final gatePassVerificationProvider =
    AsyncNotifierProvider<GatePassVerificationNotifier, GatePassScanState>(
      () => GatePassVerificationNotifier(),
    );

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/signin_provider.dart';
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
class GatePassScanNotifier extends AsyncNotifier<GatePassScanState> {
  @override
  Future<GatePassScanState> build() async {
    return const GatePassScanState();
  }

  /// Perform Check-Out scan
  Future<void> performCheckOut({
    required BuildContext context,
    required String gatePassId,
    String? notes,
  }) async {
    // Get the memberid from signin provider
    final memberProvider = ref.read(signInProvider).value;
    final scannedById = memberProvider?.member?.id;

    // Validate scannedById
    if (scannedById == null || scannedById.isEmpty) {
      if (context.mounted) {
        CustomDialog.showScanErrorDialog(
          context,
          title: 'Check-Out Failed',
          message: 'Unable to identify user. Please sign in again.',
        );
      }
      return;
    }

    await _performScan(
      context: context,
      scanOperation: () => ref
          .read(gatepassRepoProvider)
          .scanCheckOut(
            gatePassId: gatePassId,
            scannedById: scannedById,
            notes: notes,
          ),
      operationType: 'Check-Out',
    );
  }

  /// Perform Check-In scan
  Future<void> performCheckIn({
    required BuildContext context,
    required String gatePassId,
    String? notes,
  }) async {
    // Get the memberid from signin provider
    final memberProvider = ref.read(signInProvider).value;
    final scannedById = memberProvider?.member?.id;

    // Validate scannedById
    if (scannedById == null || scannedById.isEmpty) {
      if (context.mounted) {
        CustomDialog.showScanErrorDialog(
          context,
          title: 'Check-In Failed',
          message: 'Unable to identify user. Please sign in again.',
        );
      }
      return;
    }

    await _performScan(
      context: context,
      scanOperation: () => ref
          .read(gatepassRepoProvider)
          .scanCheckIn(
            gatePassId: gatePassId,
            scannedById: scannedById,
            notes: notes,
          ),
      operationType: 'Check-In',
    );
  }

  /// Perform Return-Out scan
  Future<void> performReturnOut({
    required BuildContext context,
    required String gatePassId,
    String? notes,
  }) async {
    // Get the memberid from signin provider
    final memberProvider = ref.read(signInProvider).value;
    final scannedById = memberProvider?.member?.id;

    // Validate scannedById
    if (scannedById == null || scannedById.isEmpty) {
      if (context.mounted) {
        CustomDialog.showScanErrorDialog(
          context,
          title: 'Return-Out Failed',
          message: 'Unable to identify user. Please sign in again.',
        );
      }
      return;
    }

    await _performScan(
      context: context,
      scanOperation: () => ref
          .read(gatepassRepoProvider)
          .scanReturnOut(
            gatePassId: gatePassId,
            scannedById: scannedById,
            notes: notes,
          ),
      operationType: 'Return-Out',
    );
  }

  /// Perform Return-In scan
  Future<void> performReturnIn({
    required BuildContext context,
    required String gatePassId,
    String? notes,
  }) async {
    // Get the memberid from signin provider
    final memberProvider = ref.read(signInProvider).value;
    final scannedById = memberProvider?.member?.id;

    // Validate scannedById
    if (scannedById == null || scannedById.isEmpty) {
      if (context.mounted) {
        CustomDialog.showScanErrorDialog(
          context,
          title: 'Return-In Failed',
          message: 'Unable to identify user. Please sign in again.',
        );
      }
      return;
    }

    await _performScan(
      context: context,
      scanOperation: () => ref
          .read(gatepassRepoProvider)
          .scanReturnIn(
            gatePassId: gatePassId,
            scannedById: scannedById,
            notes: notes,
          ),
      operationType: 'Return-In',
    );
  }

  /// Internal method to perform scan and handle response
  Future<void> _performScan({
    required BuildContext context,
    required Future<ApiState<Map<String, dynamic>>> Function() scanOperation,
    required String operationType,
  }) async {
    // Set scanning state
    state = const AsyncValue.data(GatePassScanState(isScanning: true));

    try {
      // Call scan API
      final result = await scanOperation();

      // Handle API response
      if (result is ApiSuccess<Map<String, dynamic>>) {
        final responseData = result.data;
        final message =
            responseData['message'] as String? ??
            '$operationType completed successfully';

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
            title: '$operationType Successful',
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
            title: '$operationType Failed',
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
          title: '$operationType Failed',
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
final gatePassScanProvider =
    AsyncNotifierProvider<GatePassScanNotifier, GatePassScanState>(
      () => GatePassScanNotifier(),
    );

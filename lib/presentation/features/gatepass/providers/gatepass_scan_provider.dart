import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

import '../models/gatepass_state.dart';

/// AsyncNotifier for scan barcode business logic
class ScanBarcodeNotifier extends AsyncNotifier<GatePassState> {
  @override
  Future<GatePassState> build() async {
    // Initialize with default state
    return const GatePassState();
  }

  /// Change scan mode
  void changeScanMode(ScanMode mode) {
    state.whenData((currentState) {
      state = AsyncValue.data(currentState.copyWith(scanMode: mode));
    });
  }

  /// Handle QR code scan
  Future<void> scanQRCode() async {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(isLoading: true, error: null),
      );
    });

    try {
      // TODO: Implement actual QR code scanning using camera
      // This should return the scanned code from the camera
      // Example:
      // final qrCodeScanner = ref.read(qrCodeScannerProvider);
      // final scannedCode = await qrCodeScanner.scan();

      // For now, simulate QR code scanning
      await Future.delayed(const Duration(seconds: 2));

      // Mock scanned code - in real implementation, this would come from camera
      const scannedCode = 'QR-CODE-12345-ABCDE';

      // Process the scanned code
      await processScannedCode(scannedCode);
    } catch (error) {
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(isLoading: false, error: error.toString()),
        );
      });
    }
  }

  /// Process scanned code (can be called from UI with actual scanned data)
  Future<void> processScannedCode(String scannedCode) async {
    if (scannedCode.trim().isEmpty) {
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(error: 'Invalid scanned code'),
        );
      });
      return;
    }

    // Call gatepass API to scan the pass
    await _scanPass(scannedCode);
  }

  /// Handle manual input
  Future<void> submitManualInput(String code) async {
    if (code.trim().isEmpty) {
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(error: 'Please enter a valid code'),
        );
      });
      return;
    }

    // Call gatepass API to scan the pass
    await _scanPass(code);
  }

  /// Scan pass using the gatepass repository
  Future<void> _scanPass(String passNumber) async {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(isLoading: true, error: null),
      );
    });

    try {
      // Get gatepass repository
      final gatepassRepo = ref.read(gatepassRepoProvider);

      // Call scan pass API
      final result = await gatepassRepo.scanPass(passNumber: passNumber);

      // Handle API response
      if (result is ApiSuccess<Map<String, dynamic>>) {
        // Scan successful
        state.whenData((currentState) {
          state = AsyncValue.data(
            currentState.copyWith(
              isLoading: false,
              scannedCode: passNumber,
              error: null,
            ),
          );
        });
      } else if (result is ApiError<Map<String, dynamic>>) {
        // Scan failed
        state.whenData((currentState) {
          state = AsyncValue.data(
            currentState.copyWith(
              isLoading: false,
              scannedCode: null,
              error: result.message,
            ),
          );
        });
      } else {
        // Handle other states
        state.whenData((currentState) {
          state = AsyncValue.data(
            currentState.copyWith(
              isLoading: false,
              scannedCode: null,
              error: 'Unexpected response from server',
            ),
          );
        });
      }
    } catch (error) {
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            scannedCode: null,
            error: error.toString(),
          ),
        );
      });
    }
  }

  /// Reset state
  void reset() {
    state = const AsyncValue.data(GatePassState());
  }
}

/// Provider for scan barcode logic
final scanBarcodeProvider =
    AsyncNotifierProvider<ScanBarcodeNotifier, GatePassState>(() {
      return ScanBarcodeNotifier();
    });

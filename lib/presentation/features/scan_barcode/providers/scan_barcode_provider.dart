import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/scan_barcode_state.dart';

/// AsyncNotifier for scan barcode business logic
class ScanBarcodeNotifier extends AsyncNotifier<ScanBarcodeState> {
  @override
  Future<ScanBarcodeState> build() async {
    // Initialize with default state
    return const ScanBarcodeState();
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
      // Example:
      // final qrCodeScanner = ref.read(qrCodeScannerProvider);
      // final result = await qrCodeScanner.scan();

      // Simulate QR code scanning
      await Future.delayed(const Duration(seconds: 2));

      // Mock scanned code
      const scannedCode = 'QR-CODE-12345-ABCDE';

      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            scannedCode: scannedCode,
            error: null,
          ),
        );
      });
    } catch (error) {
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(isLoading: false, error: error.toString()),
        );
      });
    }
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

    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(isLoading: true, error: null),
      );
    });

    try {
      // TODO: Implement actual validation/submission
      // Example:
      // final validationService = ref.read(validationServiceProvider);
      // await validationService.validateCode(code);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            scannedCode: code,
            error: null,
          ),
        );
      });
    } catch (error) {
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(isLoading: false, error: error.toString()),
        );
      });
    }
  }

  /// Reset state
  void reset() {
    state = const AsyncValue.data(ScanBarcodeState());
  }
}

/// Provider for scan barcode logic
final scanBarcodeProvider =
    AsyncNotifierProvider<ScanBarcodeNotifier, ScanBarcodeState>(() {
      return ScanBarcodeNotifier();
    });

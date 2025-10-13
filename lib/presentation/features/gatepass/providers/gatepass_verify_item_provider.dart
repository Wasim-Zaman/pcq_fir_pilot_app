import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/providers/action_type_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/gatepass_scan_item_provider.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

/// State class for Verify Item
class VerifyItemState {
  final bool isLoading;
  final String? error;
  final VerifyItemResponse? response;
  final bool isSuccess;

  const VerifyItemState({
    this.isLoading = false,
    this.error,
    this.response,
    this.isSuccess = false,
  });

  VerifyItemState copyWith({
    bool? isLoading,
    String? error,
    VerifyItemResponse? response,
    bool? isSuccess,
  }) {
    return VerifyItemState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      response: response ?? this.response,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// AsyncNotifier for Verify Item
class VerifyItemNotifier extends AsyncNotifier<VerifyItemState> {
  @override
  Future<VerifyItemState> build() async {
    return const VerifyItemState();
  }

  /// Verify item with given details
  Future<void> verifyItem({
    required String gatePassId,
    required String itemId,
    required String scannedById,
    required String verificationStatus,
    required int verifiedQuantity,
    required String verificationRemarks,
  }) async {
    // Set loading state
    state = const AsyncValue.data(VerifyItemState(isLoading: true));

    try {
      // Get gatepass repository
      final gatepassRepo = ref.read(gatepassRepoProvider);

      // Get current action type
      final actionType = ref.read(actionTypeProvider).value;

      // Call verify item API
      final result = await gatepassRepo.verifyItem(
        scanType: actionType,
        gatePassId: gatePassId,
        itemId: itemId,
        scannedById: scannedById,
        verificationStatus: verificationStatus,
        verifiedQuantity: verifiedQuantity,
        verificationRemarks: verificationRemarks,
      );

      // Handle API response
      if (result is ApiSuccess<VerifyItemResponse>) {
        final response = result.data;

        print('✅ Verify API Success');
        print('   Gate Pass Item ID: $itemId');
        print(
          '   Verification Status: ${response.data.verification.verificationStatus}',
        );

        // Update the scanned item list with the verified item
        // Pass the original gate pass item ID for matching
        final verifiedItem = response.data.verification;
        print('🔄 Calling updateScannedItem with gate pass item ID: $itemId');
        ref
            .read(gatePassScanItemProvider.notifier)
            .updateScannedItem(verifiedItem, itemId);

        state = AsyncValue.data(
          VerifyItemState(
            isLoading: false,
            response: response,
            isSuccess: true,
          ),
        );

        print('✅ Verify state updated to success');
      } else if (result is ApiError<VerifyItemResponse>) {
        // Handle error
        state = AsyncValue.data(
          VerifyItemState(isLoading: false, error: result.message),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      state = AsyncValue.data(
        VerifyItemState(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Reset state
  void reset() {
    state = const AsyncValue.data(VerifyItemState());
  }

  /// Reset error state
  void resetError() {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(error: null));
    });
  }
}

/// Provider for Verify Item
final verifyItemProvider =
    AsyncNotifierProvider<VerifyItemNotifier, VerifyItemState>(
      () => VerifyItemNotifier(),
    );

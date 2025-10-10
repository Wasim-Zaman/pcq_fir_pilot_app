import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

/// State class for Item Verification
class GatePassScanItemState {
  final bool isLoading;
  final String? error;
  final VerifiedItem? verifiedItem;
  final ItemVerificationResponse? response;

  const GatePassScanItemState({
    this.isLoading = false,
    this.error,
    this.verifiedItem,
    this.response,
  });

  GatePassScanItemState copyWith({
    bool? isLoading,
    String? error,
    VerifiedItem? verifiedItem,
    ItemVerificationResponse? response,
  }) {
    return GatePassScanItemState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verifiedItem: verifiedItem,
      response: response ?? this.response,
    );
  }
}

/// AsyncNotifier for Item Verification
class GatePassScanItemNotifier extends AsyncNotifier<GatePassScanItemState> {
  @override
  Future<GatePassScanItemState> build() async {
    return const GatePassScanItemState();
  }

  /// Fetch item verification details by item ID
  Future<void> fetchItemVerification(String itemId) async {
    // Set loading state
    state = const AsyncValue.data(GatePassScanItemState(isLoading: true));

    try {
      // Get gatepass repository
      final gatepassRepo = ref.read(gatepassRepoProvider);

      // Call item verification API
      final result = await gatepassRepo.getItemVerification(itemId: itemId);

      // Handle API response
      if (result is ApiSuccess<ItemVerificationResponse>) {
        final response = result.data;

        // Get the first item from the response (since we only scan one item at a time)
        final verifiedItem = response.data.isNotEmpty
            ? response.data.first
            : null;

        state = AsyncValue.data(
          GatePassScanItemState(
            isLoading: false,
            verifiedItem: verifiedItem,
            response: response,
          ),
        );
      } else if (result is ApiError<ItemVerificationResponse>) {
        // Handle error
        state = AsyncValue.data(
          GatePassScanItemState(isLoading: false, error: result.message),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      state = AsyncValue.data(
        GatePassScanItemState(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Clear verified item
  void clearVerifiedItem() {
    state = const AsyncValue.data(GatePassScanItemState());
  }

  /// Reset error state
  void resetError() {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(error: null));
    });
  }

  void showScanDialog(BuildContext context, handleScan) async {
    final itemId = await CustomDialog.showInputDialog(
      context,
      title: 'Scan Item/QR Code',
      hintText: 'Scan or enter item ID',
    );

    if (itemId != null && itemId.isNotEmpty) {
      handleScan(itemId);
    }
  }

  /// Handle verify item button
  void handleVerifyItem(BuildContext context, GatePass gatePass) async {
    if (state.value?.verifiedItem == null) {
      CustomSnackbar.showNormal(context, "No Item to verify");
      return;
    }

    final item = state.value?.verifiedItem!;

    // Navigate to verification screen using Go Router
    context.push(
      kGatePassItemVerificationRoute,
      extra: {'gatePass': gatePass, 'item': item},
    );
  }
}

/// Provider for Item Verification
final gatePassScanItemProvider =
    AsyncNotifierProvider<GatePassScanItemNotifier, GatePassScanItemState>(
      () => GatePassScanItemNotifier(),
    );

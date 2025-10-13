import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

/// State class for Item Verification
class GatePassScanItemState {
  final bool isLoading;
  final String? error;
  final List<VerifiedItem> scannedItems;
  final ItemVerificationResponse? response;

  const GatePassScanItemState({
    this.isLoading = false,
    this.error,
    this.scannedItems = const [],
    this.response,
  });

  GatePassScanItemState copyWith({
    bool? isLoading,
    String? error,
    List<VerifiedItem>? scannedItems,
    ItemVerificationResponse? response,
  }) {
    return GatePassScanItemState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      scannedItems: scannedItems ?? this.scannedItems,
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
  Future<void> fetchItemVerification(String itemId, String gatePassId) async {
    // Set loading state while keeping existing scanned items
    state.whenData((currentState) {
      // Check if item is already scanned
      final isAlreadyScanned = currentState.scannedItems.any(
        (item) => item.itemCode.toLowerCase() == itemId.toLowerCase(),
      );

      if (isAlreadyScanned) {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            error: 'Item already scanned',
          ),
        );
        return;
      }

      state = AsyncValue.data(currentState.copyWith(isLoading: true));
    });

    // Early return if already showing error
    final currentError = state.value?.error;
    if (currentError != null) {
      return;
    }

    try {
      // Get gatepass repository
      final gatepassRepo = ref.read(gatepassRepoProvider);

      // Call item verification API
      final result = await gatepassRepo.getItemVerification(
        itemCode: itemId,
        gatePassId: gatePassId,
      );

      // Handle API response
      if (result is ApiSuccess<ItemVerificationResponse>) {
        final response = result.data;

        // Get the first item from the response
        final verifiedItem = response.data.isNotEmpty
            ? response.data.first
            : null;

        if (verifiedItem != null) {
          // Add new item to the list
          state.whenData((currentState) {
            final updatedList = [...currentState.scannedItems, verifiedItem];
            state = AsyncValue.data(
              currentState.copyWith(
                isLoading: false,
                scannedItems: updatedList,
                response: response,
                error: null,
              ),
            );
          });
        } else {
          state.whenData((currentState) {
            state = AsyncValue.data(
              currentState.copyWith(isLoading: false, error: 'No item found'),
            );
          });
        }
      } else if (result is ApiError<ItemVerificationResponse>) {
        // Handle error
        state.whenData((currentState) {
          state = AsyncValue.data(
            currentState.copyWith(isLoading: false, error: result.message),
          );
        });
      }
    } catch (e) {
      // Handle unexpected errors
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(isLoading: false, error: e.toString()),
        );
      });
    }
  }

  /// Clear all scanned items
  void clearScannedItems() {
    state = const AsyncValue.data(GatePassScanItemState());
  }

  /// Remove a specific item from the list
  void removeScannedItem(String itemId) {
    state.whenData((currentState) {
      final updatedList = currentState.scannedItems
          .where((item) => item.id != itemId)
          .toList();
      state = AsyncValue.data(currentState.copyWith(scannedItems: updatedList));
    });
  }

  /// Update a specific item in the scanned items list after verification
  /// NOTE: updatedItem.id is the verification record ID, not the gate pass item ID
  /// We need to pass the original gatePassItemId to match the correct item
  void updateScannedItem(VerifiedItem updatedItem, String gatePassItemId) {
    print('🔄 updateScannedItem called');
    print('   Gate Pass Item ID to match: $gatePassItemId');
    print('   Updated verification status: ${updatedItem.verificationStatus}');
    print('   Updated verified quantity: ${updatedItem.verifiedQuantity}');

    // Get current state value
    final currentStateValue = state.value;
    if (currentStateValue == null) {
      print('❌ ERROR: currentStateValue is NULL!');
      return;
    }

    print('   Current items count: ${currentStateValue.scannedItems.length}');
    print(
      '   Scanned items IDs: ${currentStateValue.scannedItems.map((i) => i.id).toList()}',
    );

    // Create new list with updated item
    // We compare by the original scanned item ID (gate pass item ID)
    final updatedList = currentStateValue.scannedItems.map((item) {
      if (item.id == gatePassItemId) {
        print('   ✅ Found item to update: ${item.id}');
        // Keep the original item's ID (gate pass item ID) but update verification fields
        final updated = item.copyWith(
          verificationStatus: updatedItem.verificationStatus,
          verifiedQuantity: updatedItem.verifiedQuantity,
          verificationRemarks: updatedItem.verificationRemarks,
          hasDiscrepancy: updatedItem.hasDiscrepancy,
          quantityDifference: updatedItem.quantityDifference,
        );
        print(
          '   📝 Updated item verification status: ${updated.verificationStatus}',
        );
        return updated;
      }
      return item;
    }).toList();

    print('   Updated list count: ${updatedList.length}');

    // Update state with new list
    state = AsyncValue.data(
      GatePassScanItemState(
        isLoading: false,
        error: null,
        scannedItems: updatedList,
        response: currentStateValue.response,
      ),
    );

    print('   ✅ State updated successfully');
    print(
      '   Verified count: ${updatedList.where((i) => i.verificationStatus.toLowerCase() == 'verified').length}',
    );
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

  /// Handle verify item button for a specific item
  void handleVerifyItem(
    BuildContext context,
    GatePass gatePass,
    VerifiedItem item,
  ) async {
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

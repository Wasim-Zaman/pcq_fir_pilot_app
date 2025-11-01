import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/core/router/app_router.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/gatepass_details_provider.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';
import 'package:pcq_fir_pilot_app/services/shared_preferences_service.dart';

/// State class for Item Verification
class GatePassScanItemState {
  final bool isLoading;
  final String? error;
  final List<VerifiedItem> scannedItems;
  final ItemVerificationResponse? response;
  final String? actionType;
  final String? message;
  final bool scannedAll;

  const GatePassScanItemState({
    this.isLoading = false,
    this.error,
    this.scannedItems = const [],
    this.response,
    this.actionType,
    this.message,
    this.scannedAll = false,
  });

  GatePassScanItemState copyWith({
    bool? isLoading,
    String? error,
    List<VerifiedItem>? scannedItems,
    ItemVerificationResponse? response,
    String? actionType,
    String? message,
    bool? scannedAll,
  }) {
    return GatePassScanItemState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      scannedItems: scannedItems ?? this.scannedItems,
      response: response ?? this.response,
      actionType: actionType ?? this.actionType,
      message: message ?? this.message,
      scannedAll: scannedAll ?? this.scannedAll,
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
    // Get gate pass details to access the list of items
    final gatePassDetails = ref.read(gatePassDetailsProvider).value;
    final gatePassItemsList = gatePassDetails?.gatePass?.items.map(
      (e) => e.itemCode,
    );
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

      if (gatePassItemsList?.contains(itemId) == false) {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            error: 'Item not found in this gate pass',
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

            // Check if all items have been scanned
            final scannedAll = gatePassItemsList?.length == updatedList.length;

            state = AsyncValue.data(
              currentState.copyWith(
                isLoading: false,
                scannedItems: updatedList,
                response: response,
                error: null,
                message: null,
                scannedAll: scannedAll,
                actionType: scannedAll
                    ? (gatePassDetails?.gatePass?.status == 'APPROVED'
                          ? 'Check-Out'
                          : "Check-In")
                    : null,
              ),
            );

            // Do the checkInOrOut process if all items are scanned
            if (scannedAll) {
              handleCheckInOrOut(notes: 'All items scanned');
            }
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
      state = AsyncValue.data(
        currentState.copyWith(scannedItems: updatedList, message: null),
      );
    });
  }

  /// Update a specific item in the scanned items list after verification
  /// NOTE: updatedItem.id is the verification record ID, not the gate pass item ID
  /// We need to pass the original gatePassItemId to match the correct item
  void updateScannedItem(VerifiedItem updatedItem, String gatePassItemId) {
    // Get current state value
    final currentStateValue = state.value;
    if (currentStateValue == null) {
      return;
    }

    // Create new list with updated item
    // We compare by the original scanned item ID (gate pass item ID)
    final updatedList = currentStateValue.scannedItems.map((item) {
      if (item.id == gatePassItemId) {
        // Keep the original item's ID (gate pass item ID) but update verification fields
        final updated = item.copyWith(
          verificationStatus: updatedItem.verificationStatus,
          verifiedQuantity: updatedItem.verifiedQuantity,
          verificationRemarks: updatedItem.verificationRemarks,
          hasDiscrepancy: updatedItem.hasDiscrepancy,
          quantityDifference: updatedItem.quantityDifference,
        );
        return updated;
      }
      return item;
    }).toList();

    // Update state with new list
    state = AsyncValue.data(
      GatePassScanItemState(
        isLoading: false,
        error: null,
        scannedItems: updatedList,
        response: currentStateValue.response,
      ),
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
  void handleVerifyItem(GatePass gatePass, VerifiedItem item) async {
    // Navigate to verification screen using Go Router
    ref
        .read(goRouterProvider)
        .push(
          kGatePassItemVerificationRoute,
          extra: {'gatePass': gatePass, 'item': item},
        );
  }

  void handleCheckInOrOut({required String notes}) async {
    try {
      state = AsyncValue.data(state.value!.copyWith(isLoading: true));
      // Get the local storage provider
      final scannedById = ref
          .read(sharedPreferencesServiceProvider)
          .getUserId();

      // Get the gate pass details
      final gatePassDetails = ref.read(gatePassDetailsProvider).value;
      final gatePassId = gatePassDetails?.gatePass?.id;

      if (gatePassId == null) {
        throw Exception('Missing gate pass ID');
      }

      // Call check-in/check-out API
      final gatepassRepo = ref.read(gatepassRepoProvider);
      final result = await gatepassRepo.checkInOrOut(
        gatePassId: gatePassId,
        scannedById: scannedById ?? '',
        notes: notes,
      );

      if (result is ApiSuccess<Map<String, dynamic>>) {
        // Clear scanned items after successful check-in/check-out
        clearScannedItems();
        // Extract success message from response data
        final successMessage = result.data['message'] as String?;
        // Success - you can handle success state if needed
        state = AsyncValue.data(
          state.value!.copyWith(
            error: null,
            isLoading: false,
            scannedItems: [], // Clear scanned itemms
            message: successMessage ?? 'Successfully completed the action.',
          ),
        );
      } else if (result is ApiError<Map<String, dynamic>>) {
        // API error
        state = AsyncValue.data(
          state.value!.copyWith(error: result.message, isLoading: false),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(error: e.toString(), isLoading: false),
      );
    }
  }
}

/// Provider for Item Verification
final gatePassScanItemProvider =
    AsyncNotifierProvider<GatePassScanItemNotifier, GatePassScanItemState>(
      () => GatePassScanItemNotifier(),
    );

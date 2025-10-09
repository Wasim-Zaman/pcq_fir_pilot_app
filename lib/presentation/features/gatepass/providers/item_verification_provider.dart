import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

/// State class for Item Verification
class ItemVerificationState {
  final bool isLoading;
  final String? error;
  final List<VerifiedItem> verifiedItems;
  final ItemVerificationResponse? response;

  const ItemVerificationState({
    this.isLoading = false,
    this.error,
    this.verifiedItems = const [],
    this.response,
  });

  ItemVerificationState copyWith({
    bool? isLoading,
    String? error,
    List<VerifiedItem>? verifiedItems,
    ItemVerificationResponse? response,
  }) {
    return ItemVerificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verifiedItems: verifiedItems ?? this.verifiedItems,
      response: response ?? this.response,
    );
  }
}

/// AsyncNotifier for Item Verification
class ItemVerificationNotifier extends AsyncNotifier<ItemVerificationState> {
  @override
  Future<ItemVerificationState> build() async {
    return const ItemVerificationState();
  }

  /// Fetch item verification details by item ID
  Future<void> fetchItemVerification(String itemId) async {
    // Set loading state
    state = const AsyncValue.data(ItemVerificationState(isLoading: true));

    try {
      // Get gatepass repository
      final gatepassRepo = ref.read(gatepassRepoProvider);

      // Call item verification API
      final result = await gatepassRepo.getItemVerification(itemId: itemId);

      // Handle API response
      if (result is ApiSuccess<ItemVerificationResponse>) {
        final response = result.data;

        // Merge incoming items with existing items while preventing duplicates
        state.whenData((currentState) {
          final Map<String, VerifiedItem> byId = {
            for (final item in currentState.verifiedItems) item.id: item,
          };

          for (final newItem in response.data) {
            // replace or add by id
            byId[newItem.id] = newItem;
          }

          final merged = byId.values.toList();

          state = AsyncValue.data(
            currentState.copyWith(
              isLoading: false,
              verifiedItems: merged,
              response: response,
            ),
          );
        });
      } else if (result is ApiError<ItemVerificationResponse>) {
        // Handle error
        state = AsyncValue.data(
          ItemVerificationState(isLoading: false, error: result.message),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      state = AsyncValue.data(
        ItemVerificationState(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Add a verified item to the list
  void addVerifiedItem(VerifiedItem item) {
    state.whenData((currentState) {
      // Ensure the item is not already present (by id)
      final exists = currentState.verifiedItems.any(
        (existing) => existing.id == item.id,
      );

      if (!exists) {
        final updatedItems = [...currentState.verifiedItems, item];
        state = AsyncValue.data(
          currentState.copyWith(verifiedItems: updatedItems),
        );
      }
    });
  }

  /// Remove a verified item by id
  void removeVerifiedItem(String id) {
    state.whenData((currentState) {
      final updatedItems = currentState.verifiedItems
          .where((item) => item.id != id)
          .toList();
      state = AsyncValue.data(
        currentState.copyWith(verifiedItems: updatedItems),
      );
    });
  }

  /// Clear all verified items
  void clearVerifiedItems() {
    state = const AsyncValue.data(ItemVerificationState());
  }

  /// Reset error state
  void resetError() {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(error: null));
    });
  }
}

/// Provider for Item Verification
final itemVerificationProvider =
    AsyncNotifierProvider<ItemVerificationNotifier, ItemVerificationState>(
      () => ItemVerificationNotifier(),
    );

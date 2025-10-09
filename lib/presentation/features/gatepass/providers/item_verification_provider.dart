import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

/// State class for Item Verification
class ItemVerificationState {
  final bool isLoading;
  final String? error;
  final VerifiedItem? verifiedItem;
  final ItemVerificationResponse? response;

  const ItemVerificationState({
    this.isLoading = false,
    this.error,
    this.verifiedItem,
    this.response,
  });

  ItemVerificationState copyWith({
    bool? isLoading,
    String? error,
    VerifiedItem? verifiedItem,
    ItemVerificationResponse? response,
  }) {
    return ItemVerificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verifiedItem: verifiedItem,
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

        // Get the first item from the response (since we only scan one item at a time)
        final verifiedItem = response.data.isNotEmpty
            ? response.data.first
            : null;

        state = AsyncValue.data(
          ItemVerificationState(
            isLoading: false,
            verifiedItem: verifiedItem,
            response: response,
          ),
        );
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

  /// Clear verified item
  void clearVerifiedItem() {
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

import '../models/gatepass_models.dart';

/// State class for Gate Pass Details
class GatePassDetailsState {
  final bool isLoading;
  final String? error;
  final GatePass? gatePass;

  const GatePassDetailsState({
    this.isLoading = false,
    this.error,
    this.gatePass,
  });

  GatePassDetailsState copyWith({
    bool? isLoading,
    String? error,
    GatePass? gatePass,
  }) {
    return GatePassDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      gatePass: gatePass ?? this.gatePass,
    );
  }
}

/// AsyncNotifier for Gate Pass Details
class GatePassDetailsNotifier extends AsyncNotifier<GatePassDetailsState> {
  @override
  Future<GatePassDetailsState> build() async {
    return const GatePassDetailsState();
  }

  /// Fetch gate pass details by pass number
  Future<void> fetchGatePassDetails(String passNumber) async {
    // Set loading state
    state = const AsyncValue.data(GatePassDetailsState(isLoading: true));

    try {
      // Get gatepass repository
      final gatepassRepo = ref.read(gatepassRepoProvider);

      // Call scan pass API
      final result = await gatepassRepo.scanPass(passNumber: passNumber);

      // Handle API response
      if (result is ApiSuccess<Map<String, dynamic>>) {
        // Parse the response
        final response = GatePassResponse.fromJson(result.data);

        // Update state with gate pass data
        state = AsyncValue.data(
          GatePassDetailsState(isLoading: false, gatePass: response.data),
        );
      } else if (result is ApiError<Map<String, dynamic>>) {
        // Handle error
        state = AsyncValue.data(
          GatePassDetailsState(isLoading: false, error: result.message),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      state = AsyncValue.data(
        GatePassDetailsState(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Clear gate pass details
  void clearDetails() {
    state = const AsyncValue.data(GatePassDetailsState());
  }

  /// Refresh gate pass details
  Future<void> refreshDetails(String passNumber) async {
    await fetchGatePassDetails(passNumber);
  }
}

/// Provider for Gate Pass Details
final gatePassDetailsProvider =
    AsyncNotifierProvider<GatePassDetailsNotifier, GatePassDetailsState>(
      () => GatePassDetailsNotifier(),
    );

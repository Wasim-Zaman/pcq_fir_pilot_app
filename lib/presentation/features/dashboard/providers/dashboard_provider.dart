import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_analytics.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_state.dart';
import 'package:pcq_fir_pilot_app/repos/gatepass_repo.dart';

/// AsyncNotifier for dashboard business logic
class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    // Initialize with loading and fetch initial data
    return await loadDashboardData();
  }

  /// Load dashboard data
  Future<DashboardState> loadDashboardData() async {
    try {
      final gatepassRepo = ref.read(gatepassRepoProvider);
      final result = await gatepassRepo.getDashboardAnalytics();

      if (result is ApiSuccess<DashboardAnalytics>) {
        return DashboardState(isLoading: false, analytics: result.data);
      } else if (result is ApiError<DashboardAnalytics>) {
        return DashboardState(isLoading: false, error: result.message);
      } else {
        return DashboardState(
          isLoading: false,
          error: 'Unexpected error occurred',
        );
      }
    } catch (error) {
      return DashboardState(isLoading: false, error: error.toString());
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();

    try {
      final newState = await loadDashboardData();
      state = AsyncValue.data(newState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for dashboard logic
final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardState>(() {
      return DashboardNotifier();
    });

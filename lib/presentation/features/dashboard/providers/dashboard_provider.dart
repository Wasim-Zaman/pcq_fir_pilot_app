import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dashboard statistics model
class DashboardStats {
  final int todayScans;
  final int pendingVerifications;
  final DateTime lastUpdated;

  const DashboardStats({
    required this.todayScans,
    required this.pendingVerifications,
    required this.lastUpdated,
  });

  DashboardStats copyWith({
    int? todayScans,
    int? pendingVerifications,
    DateTime? lastUpdated,
  }) {
    return DashboardStats(
      todayScans: todayScans ?? this.todayScans,
      pendingVerifications: pendingVerifications ?? this.pendingVerifications,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Dashboard state class to track dashboard status
class DashboardState {
  final bool isLoading;
  final String? error;
  final DashboardStats? stats;

  const DashboardState({this.isLoading = false, this.error, this.stats});

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    DashboardStats? stats,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
    );
  }
}

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
      // TODO: Implement actual API call here
      // Example:
      // final dashboardService = ref.read(dashboardServiceProvider);
      // final stats = await dashboardService.fetchDashboardStats();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final stats = DashboardStats(
        todayScans: 12,
        pendingVerifications: 3,
        lastUpdated: DateTime.now(),
      );

      return DashboardState(isLoading: false, stats: stats);
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

  /// Increment today's scans count
  void incrementTodayScans() {
    state.whenData((currentState) {
      if (currentState.stats != null) {
        final updatedStats = currentState.stats!.copyWith(
          todayScans: currentState.stats!.todayScans + 1,
          lastUpdated: DateTime.now(),
        );
        state = AsyncValue.data(currentState.copyWith(stats: updatedStats));
      }
    });
  }

  /// Update pending verifications count
  void updatePendingVerifications(int count) {
    state.whenData((currentState) {
      if (currentState.stats != null) {
        final updatedStats = currentState.stats!.copyWith(
          pendingVerifications: count,
          lastUpdated: DateTime.now(),
        );
        state = AsyncValue.data(currentState.copyWith(stats: updatedStats));
      }
    });
  }
}

/// Provider for dashboard logic
final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardState>(() {
      return DashboardNotifier();
    });

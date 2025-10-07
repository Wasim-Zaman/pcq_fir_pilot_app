import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_stats.dart';

/// Dashboard state class to track dashboard status
/// Contains loading state, error messages, and dashboard statistics
class DashboardState {
  final bool isLoading;
  final String? error;
  final DashboardStats? stats;

  const DashboardState({this.isLoading = false, this.error, this.stats});

  /// Create a copy of this state with updated fields
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

  /// Check if the state has data
  bool get hasData => stats != null;

  /// Check if the state has error
  bool get hasError => error != null;

  @override
  String toString() {
    return 'DashboardState(isLoading: $isLoading, error: $error, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardState &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.stats == stats;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^ error.hashCode ^ stats.hashCode;
  }
}

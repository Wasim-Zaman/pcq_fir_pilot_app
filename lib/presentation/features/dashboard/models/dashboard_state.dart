import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_analytics.dart';

/// Dashboard state class to track dashboard status
/// Contains loading state, error messages, and dashboard analytics
class DashboardState {
  final bool isLoading;
  final String? error;
  final DashboardAnalytics? analytics;

  const DashboardState({this.isLoading = false, this.error, this.analytics});

  /// Create a copy of this state with updated fields
  DashboardState copyWith({
    bool? isLoading,
    String? error,
    DashboardAnalytics? analytics,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      analytics: analytics ?? this.analytics,
    );
  }

  /// Check if the state has data
  bool get hasData => analytics != null;

  /// Check if the state has error
  bool get hasError => error != null;

  @override
  String toString() {
    return 'DashboardState(isLoading: $isLoading, error: $error, analytics: $analytics)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardState &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.analytics == analytics;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^ error.hashCode ^ analytics.hashCode;
  }
}

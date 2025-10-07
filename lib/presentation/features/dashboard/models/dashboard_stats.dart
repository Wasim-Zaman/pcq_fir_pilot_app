/// Dashboard statistics model
/// Contains the data for dashboard metrics
class DashboardStats {
  final int todayScans;
  final int pendingVerifications;
  final DateTime lastUpdated;

  const DashboardStats({
    required this.todayScans,
    required this.pendingVerifications,
    required this.lastUpdated,
  });

  /// Create a copy of this model with updated fields
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

  /// Create DashboardStats from JSON
  /// TODO: Update this method when API integration is ready
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      todayScans: json['todayScans'] as int? ?? 0,
      pendingVerifications: json['pendingVerifications'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  /// Convert DashboardStats to JSON
  Map<String, dynamic> toJson() {
    return {
      'todayScans': todayScans,
      'pendingVerifications': pendingVerifications,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DashboardStats(todayScans: $todayScans, pendingVerifications: $pendingVerifications, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardStats &&
        other.todayScans == todayScans &&
        other.pendingVerifications == pendingVerifications &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return todayScans.hashCode ^
        pendingVerifications.hashCode ^
        lastUpdated.hashCode;
  }
}

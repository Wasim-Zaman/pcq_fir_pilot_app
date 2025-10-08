/// Dashboard analytics model
/// Contains the data for dashboard analytics from the API
class DashboardAnalytics {
  final Summary summary;
  final List<StatusDistribution> statusDistribution;
  final List<TypeDistribution> typeDistribution;
  final List<Last7Days> last7Days;

  const DashboardAnalytics({
    required this.summary,
    required this.statusDistribution,
    required this.typeDistribution,
    required this.last7Days,
  });

  /// Create DashboardAnalytics from JSON
  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    return DashboardAnalytics(
      summary: Summary.fromJson(json['summary'] as Map<String, dynamic>),
      statusDistribution: (json['statusDistribution'] as List<dynamic>)
          .map((e) => StatusDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
      typeDistribution: (json['typeDistribution'] as List<dynamic>)
          .map((e) => TypeDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
      last7Days: (json['last7Days'] as List<dynamic>)
          .map((e) => Last7Days.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert DashboardAnalytics to JSON
  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'statusDistribution': statusDistribution.map((e) => e.toJson()).toList(),
      'typeDistribution': typeDistribution.map((e) => e.toJson()).toList(),
      'last7Days': last7Days.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DashboardAnalytics(summary: $summary, statusDistribution: $statusDistribution, typeDistribution: $typeDistribution, last7Days: $last7Days)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardAnalytics &&
        other.summary == summary &&
        other.statusDistribution == statusDistribution &&
        other.typeDistribution == typeDistribution &&
        other.last7Days == last7Days;
  }

  @override
  int get hashCode {
    return summary.hashCode ^
        statusDistribution.hashCode ^
        typeDistribution.hashCode ^
        last7Days.hashCode;
  }
}

class Summary {
  final int totalGatePasses;
  final int pendingApprovals;
  final int inTransit;
  final int completedToday;

  const Summary({
    required this.totalGatePasses,
    required this.pendingApprovals,
    required this.inTransit,
    required this.completedToday,
  });

  /// Create Summary from JSON
  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalGatePasses: json['totalGatePasses'] as int,
      pendingApprovals: json['pendingApprovals'] as int,
      inTransit: json['inTransit'] as int,
      completedToday: json['completedToday'] as int,
    );
  }

  /// Convert Summary to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalGatePasses': totalGatePasses,
      'pendingApprovals': pendingApprovals,
      'inTransit': inTransit,
      'completedToday': completedToday,
    };
  }

  @override
  String toString() {
    return 'Summary(totalGatePasses: $totalGatePasses, pendingApprovals: $pendingApprovals, inTransit: $inTransit, completedToday: $completedToday)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Summary &&
        other.totalGatePasses == totalGatePasses &&
        other.pendingApprovals == pendingApprovals &&
        other.inTransit == inTransit &&
        other.completedToday == completedToday;
  }

  @override
  int get hashCode {
    return totalGatePasses.hashCode ^
        pendingApprovals.hashCode ^
        inTransit.hashCode ^
        completedToday.hashCode;
  }
}

class StatusDistribution {
  final int count;
  final String status;

  const StatusDistribution({required this.count, required this.status});

  /// Create StatusDistribution from JSON
  factory StatusDistribution.fromJson(Map<String, dynamic> json) {
    return StatusDistribution(
      count: json['_count'] as int,
      status: json['status'] as String,
    );
  }

  /// Convert StatusDistribution to JSON
  Map<String, dynamic> toJson() {
    return {'_count': count, 'status': status};
  }

  @override
  String toString() {
    return 'StatusDistribution(count: $count, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatusDistribution &&
        other.count == count &&
        other.status == status;
  }

  @override
  int get hashCode {
    return count.hashCode ^ status.hashCode;
  }
}

class TypeDistribution {
  final int count;
  final String gatePassType;

  const TypeDistribution({required this.count, required this.gatePassType});

  /// Create TypeDistribution from JSON
  factory TypeDistribution.fromJson(Map<String, dynamic> json) {
    return TypeDistribution(
      count: json['_count'] as int,
      gatePassType: json['gatePassType'] as String,
    );
  }

  /// Convert TypeDistribution to JSON
  Map<String, dynamic> toJson() {
    return {'_count': count, 'gatePassType': gatePassType};
  }

  @override
  String toString() {
    return 'TypeDistribution(count: $count, gatePassType: $gatePassType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TypeDistribution &&
        other.count == count &&
        other.gatePassType == gatePassType;
  }

  @override
  int get hashCode {
    return count.hashCode ^ gatePassType.hashCode;
  }
}

class Last7Days {
  final int count;
  final DateTime gatePassDate;

  const Last7Days({required this.count, required this.gatePassDate});

  /// Create Last7Days from JSON
  factory Last7Days.fromJson(Map<String, dynamic> json) {
    return Last7Days(
      count: json['_count'] as int,
      gatePassDate: DateTime.parse(json['gatePassDate'] as String),
    );
  }

  /// Convert Last7Days to JSON
  Map<String, dynamic> toJson() {
    return {'_count': count, 'gatePassDate': gatePassDate.toIso8601String()};
  }

  @override
  String toString() {
    return 'Last7Days(count: $count, gatePassDate: $gatePassDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Last7Days &&
        other.count == count &&
        other.gatePassDate == gatePassDate;
  }

  @override
  int get hashCode {
    return count.hashCode ^ gatePassDate.hashCode;
  }
}

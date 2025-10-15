/// Dashboard analytics model
/// Contains the data for dashboard analytics from the API
class DashboardAnalytics {
  final Summary summary;
  final List<StatusDistribution> statusDistribution;
  final List<TypeDistribution> typeDistribution;
  final List<Last7Days> dailyTrend;

  const DashboardAnalytics({
    required this.summary,
    required this.statusDistribution,
    required this.typeDistribution,
    required this.dailyTrend,
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
      dailyTrend: (json['dailyTrend'] as List<dynamic>)
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
      'dailyTrend': dailyTrend.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DashboardAnalytics(summary: $summary, statusDistribution: $statusDistribution, typeDistribution: $typeDistribution, dailyTrend: $dailyTrend)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardAnalytics &&
        other.summary == summary &&
        other.statusDistribution == statusDistribution &&
        other.typeDistribution == typeDistribution &&
        other.dailyTrend == dailyTrend;
  }

  @override
  int get hashCode {
    return summary.hashCode ^
        statusDistribution.hashCode ^
        typeDistribution.hashCode ^
        dailyTrend.hashCode;
  }
}

class Summary {
  final int totalGatePasses;
  final int pendingApprovals;
  final int approved;
  final int inTransit;
  final int arrived;
  final int completed;
  final int rejected;
  final int cancelled;
  final double averageProcessingTimeHours;

  const Summary({
    required this.totalGatePasses,
    required this.pendingApprovals,
    required this.approved,
    required this.inTransit,
    required this.arrived,
    required this.completed,
    required this.rejected,
    required this.cancelled,
    required this.averageProcessingTimeHours,
  });

  /// Create Summary from JSON
  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalGatePasses: json['totalGatePasses'] as int? ?? 0,
      pendingApprovals: json['pendingApprovals'] as int? ?? 0,
      approved: json['approved'] as int? ?? 0,
      inTransit: json['inTransit'] as int? ?? 0,
      arrived: json['arrived'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      rejected: json['rejected'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
      averageProcessingTimeHours: (json['averageProcessingTimeHours'] is int)
          ? (json['averageProcessingTimeHours'] as int).toDouble()
          : (json['averageProcessingTimeHours'] as double? ?? 0.0),
    );
  }

  /// Convert Summary to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalGatePasses': totalGatePasses,
      'pendingApprovals': pendingApprovals,
      'approved': approved,
      'inTransit': inTransit,
      'arrived': arrived,
      'completed': completed,
      'rejected': rejected,
      'cancelled': cancelled,
      'averageProcessingTimeHours': averageProcessingTimeHours,
    };
  }

  @override
  String toString() {
    return 'Summary(totalGatePasses: $totalGatePasses, pendingApprovals: $pendingApprovals, approved: $approved, inTransit: $inTransit, arrived: $arrived, completed: $completed, rejected: $rejected, cancelled: $cancelled, averageProcessingTimeHours: $averageProcessingTimeHours)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Summary &&
        other.totalGatePasses == totalGatePasses &&
        other.pendingApprovals == pendingApprovals &&
        other.approved == approved &&
        other.inTransit == inTransit &&
        other.arrived == arrived &&
        other.completed == completed &&
        other.rejected == rejected &&
        other.cancelled == cancelled &&
        other.averageProcessingTimeHours == averageProcessingTimeHours;
  }

  @override
  int get hashCode {
    return totalGatePasses.hashCode ^
        pendingApprovals.hashCode ^
        approved.hashCode ^
        inTransit.hashCode ^
        arrived.hashCode ^
        completed.hashCode ^
        rejected.hashCode ^
        cancelled.hashCode ^
        averageProcessingTimeHours.hashCode;
  }
}

class StatusDistribution {
  final int count;
  final String status;

  const StatusDistribution({required this.count, required this.status});

  /// Create StatusDistribution from JSON
  factory StatusDistribution.fromJson(Map<String, dynamic> json) {
    return StatusDistribution(
      count: json['count'] as int? ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  /// Convert StatusDistribution to JSON
  Map<String, dynamic> toJson() {
    return {'count': count, 'status': status};
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
  final String type;

  const TypeDistribution({required this.count, required this.type});

  /// Create TypeDistribution from JSON
  factory TypeDistribution.fromJson(Map<String, dynamic> json) {
    return TypeDistribution(
      count: json['count'] as int? ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  /// Convert TypeDistribution to JSON
  Map<String, dynamic> toJson() {
    return {'count': count, 'type': type};
  }

  @override
  String toString() {
    return 'TypeDistribution(count: $count, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TypeDistribution &&
        other.count == count &&
        other.type == type;
  }

  @override
  int get hashCode {
    return count.hashCode ^ type.hashCode;
  }
}

class Last7Days {
  final int count;
  final DateTime date;

  const Last7Days({required this.count, required this.date});

  /// Create Last7Days from JSON
  factory Last7Days.fromJson(Map<String, dynamic> json) {
    return Last7Days(
      count: json['count'] as int? ?? 0,
      date: DateTime.parse(json['date'] as String),
    );
  }

  /// Convert Last7Days to JSON
  Map<String, dynamic> toJson() {
    return {'count': count, 'date': date.toIso8601String()};
  }

  @override
  String toString() {
    return 'Last7Days(count: $count, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Last7Days && other.count == count && other.date == date;
  }

  @override
  int get hashCode {
    return count.hashCode ^ date.hashCode;
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_analytics.dart';

/// Widget to display status distribution pie chart
class StatusDistributionChart extends StatelessWidget {
  final List<StatusDistribution> statusDistribution;

  const StatusDistributionChart({super.key, required this.statusDistribution});

  @override
  Widget build(BuildContext context) {
    if (statusDistribution.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No status data available',
            style: TextStyle(color: AppColors.kTextSecondaryColor),
          ),
        ),
      );
    }

    final total = statusDistribution.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Gate pass status breakdown',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.kTextSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Pie Chart
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _getSections(total),
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {},
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Legend
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: statusDistribution.map((item) {
                    final percentage = total > 0
                        ? ((item.count / total) * 100).toStringAsFixed(1)
                        : '0.0';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getColorForStatus(item.status),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatStatus(item.status),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              // color: AppColors.kTextPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections(int total) {
    return statusDistribution.asMap().entries.map((entry) {
      final item = entry.value;
      final percentage = total > 0 ? (item.count / total) * 100 : 0.0;
      final isLarge = percentage > 10;

      return PieChartSectionData(
        color: _getColorForStatus(item.status),
        value: item.count.toDouble(),
        title: isLarge ? '${item.count}' : '',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.kSurfaceColor,
        ),
      );
    }).toList();
  }

  Color _getColorForStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'PENDING_APPROVAL':
        return AppColors.kWarningColor;
      case 'APPROVED':
        return AppColors.kSuccessColor.withValues(alpha: 0.7);
      case 'IN_TRANSIT':
        return AppColors.kInfoColor;
      case 'ARRIVED':
        return AppColors.kPurpleColor;
      case 'COMPLETED':
        return AppColors.kSuccessColor;
      case 'REJECTED':
        return AppColors.kErrorColor;
      case 'CANCELLED':
        return AppColors.kGreyColor;
      case 'RETURNING':
        return AppColors.kOrangeColor;
      default:
        return AppColors.kBlueGreyColor;
    }
  }

  String _formatStatus(String status) {
    return status
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

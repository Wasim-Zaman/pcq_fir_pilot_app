import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_analytics.dart';

/// Widget to display daily trend chart
class DailyTrendChart extends StatelessWidget {
  final List<Last7Days> dailyTrend;

  const DailyTrendChart({super.key, required this.dailyTrend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (dailyTrend.isEmpty) {
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
            'No trend data available',
            // style: TextStyle(color: AppColors.kTextSecondaryColor),
          ),
        ),
      );
    }

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
            'Daily Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // color: isDark
              //     ? AppColors.kDarkTextPrimaryColor
              //     : const Color.fromARGB(221, 20, 11, 11),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gate passes over time',
            // style: TextStyle(fontSize: 14, color: AppColors.kGrey600Color),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark
                          ? AppColors.kGrey600Color
                          : AppColors.kGrey200Color,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() < 0 ||
                            value.toInt() >= dailyTrend.length) {
                          return const Text('');
                        }
                        final date = dailyTrend[value.toInt()].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: TextStyle(
                              color: AppColors.kGrey600Color,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 32,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            // color: AppColors.kGrey600Color,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.kGrey600Color
                          : AppColors.kGrey300Color,
                    ),
                    left: BorderSide(
                      color: isDark
                          ? AppColors.kGrey600Color
                          : AppColors.kGrey300Color,
                    ),
                  ),
                ),
                minX: 0,
                maxX: (dailyTrend.length - 1).toDouble(),
                minY: 0,
                maxY: _getMaxY(),
                lineBarsData: [
                  LineChartBarData(
                    spots: dailyTrend
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(
                            entry.key.toDouble(),
                            entry.value.count.toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: AppColors.kPrimaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: isDark
                              ? AppColors.kDarkSurfaceColor
                              : AppColors.kSurfaceColor,
                          strokeWidth: 2,
                          strokeColor: AppColors.kPrimaryColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final date = dailyTrend[touchedSpot.x.toInt()].date;
                        return LineTooltipItem(
                          '${DateFormat('MMM dd').format(date)}\n${touchedSpot.y.toInt()} passes',
                          TextStyle(
                            color: isDark
                                ? AppColors.kDarkSurfaceColor
                                : AppColors.kSurfaceColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    if (dailyTrend.isEmpty) return 10;
    final maxCount = dailyTrend
        .map((e) => e.count)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    return (maxCount + 2).ceilToDouble();
  }
}

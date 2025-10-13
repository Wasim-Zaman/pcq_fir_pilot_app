import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/providers/action_type_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_dropdown.dart';

import 'compact_stat_card.dart';
import 'daily_trend_chart.dart';
import 'dashboard_header.dart';
import 'status_distribution_chart.dart';

/// Main content widget for the dashboard
class DashboardContent extends ConsumerWidget {
  final dynamic state;
  final VoidCallback onScanQRCode;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  const DashboardContent({
    super.key,
    required this.state,
    required this.onScanQRCode,
    required this.onNotifications,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActionType = ref.watch(actionTypeProvider);
    final actionTypes = ref.watch(actionTypeListProvider);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            DashboardHeader(
              onNotifications: onNotifications,
              onProfile: onProfile,
            ),

            24.heightBox,

            // Charts Section
            DailyTrendChart(dailyTrend: state.analytics?.dailyTrend ?? []),

            16.heightBox,

            StatusDistributionChart(
              statusDistribution: state.analytics?.statusDistribution ?? [],
            ),

            24.heightBox,

            // Statistics Grid
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            16.heightBox,

            // Grid Layout for Stats
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: [
                CompactStatCard(
                  title: 'Total Gate Passes',
                  value:
                      state.analytics?.summary.totalGatePasses.toString() ??
                      '0',
                  icon: Iconsax.document,
                  color: AppColors.kPrimaryColor,
                ),
                CompactStatCard(
                  title: 'Pending Approvals',
                  value:
                      state.analytics?.summary.pendingApprovals.toString() ??
                      '0',
                  icon: Iconsax.clock,
                  color: AppColors.kWarningColor,
                ),
                CompactStatCard(
                  title: 'In Transit',
                  value: state.analytics?.summary.inTransit.toString() ?? '0',
                  icon: Iconsax.truck_fast,
                  color: AppColors.kInfoColor,
                ),
                CompactStatCard(
                  title: 'Completed',
                  value: state.analytics?.summary.completed.toString() ?? '0',
                  icon: Iconsax.tick_circle,
                  color: AppColors.kSuccessColor,
                ),
                CompactStatCard(
                  title: 'Approved',
                  value: state.analytics?.summary.approved.toString() ?? '0',
                  icon: Iconsax.verify5,
                  color: Colors.green,
                ),
                CompactStatCard(
                  title: 'Arrived',
                  value: state.analytics?.summary.arrived.toString() ?? '0',
                  icon: Iconsax.location,
                  color: Colors.purple,
                ),
                CompactStatCard(
                  title: 'Rejected',
                  value: state.analytics?.summary.rejected.toString() ?? '0',
                  icon: Iconsax.close_circle,
                  color: AppColors.kErrorColor,
                ),
                CompactStatCard(
                  title: 'Cancelled',
                  value: state.analytics?.summary.cancelled.toString() ?? '0',
                  icon: Iconsax.slash5,
                  color: Colors.grey,
                ),
              ],
            ),

            24.heightBox,

            // Processing Time Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.kInfoColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Iconsax.timer_1,
                      color: AppColors.kInfoColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Average Processing Time',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.analytics?.summary.averageProcessingTimeHours.toStringAsFixed(1) ?? '0.0'} hours',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kInfoColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            24.heightBox,

            // Action Type Dropdown
            CustomDropdown<ActionType>(
              value: selectedActionType,
              labelText: 'Select Action Type',
              hintText: 'Choose an action',
              prefixIcon: const Icon(Iconsax.setting_2),
              items: actionTypes.map((actionType) {
                return DropdownMenuItem<ActionType>(
                  value: actionType,
                  child: Text(actionType.displayName),
                );
              }).toList(),
              onChanged: (ActionType? newValue) {
                if (newValue != null) {
                  ref.read(actionTypeProvider.notifier).setActionType(newValue);
                }
              },
            ),

            16.heightBox,

            // Scan QR Code Button
            CustomButton(
              text: 'Scan QR Code',
              onPressed: onScanQRCode,
              width: double.infinity,
              icon: const Icon(Iconsax.scan_barcode),
              useGradient: true,
            ),

            16.heightBox,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';

import 'dashboard_header.dart';
import 'dashboard_stat_card.dart';

/// Main content widget for the dashboard
class DashboardContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
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

            32.heightBox,

            // Today's Scans Card
            DashboardStatCard(
              title: 'Total Gate Passes',
              value: state.analytics?.summary.totalGatePasses.toString() ?? '0',
              subtitle: 'total gate passes',
              icon: Iconsax.document,
              color: AppColors.kPrimaryColor,
            ),

            16.heightBox,

            // Pending Verifications Card
            DashboardStatCard(
              title: 'Pending Approvals',
              value: state.analytics?.summary.pendingApprovals.toString() ?? '0',
              subtitle: 'pending approvals',
              icon: Iconsax.clock,
              color: AppColors.kWarningColor,
            ),

            16.heightBox,

            // In Transit Card
            DashboardStatCard(
              title: 'In Transit',
              value: state.analytics?.summary.inTransit.toString() ?? '0',
              subtitle: 'in transit',
              icon: Iconsax.truck_fast,
              color: Colors.blue,
            ),

            16.heightBox,

            // Completed Today Card
            DashboardStatCard(
              title: 'Completed Today',
              value: state.analytics?.summary.completedToday.toString() ?? '0',
              subtitle: 'completed today',
              icon: Iconsax.tick_circle,
              color: Colors.green,
            ),

            32.heightBox,

            // Scan QR Code Button
            CustomButton(
              text: 'Scan QR Code',
              onPressed: onScanQRCode,
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

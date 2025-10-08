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
              title: 'Today\'s Scans',
              value: state.stats?.todayScans.toString() ?? '0',
              subtitle: 'documents verified',
              icon: Iconsax.document,
              color: AppColors.kPrimaryColor,
            ),

            16.heightBox,

            // Pending Verifications Card
            DashboardStatCard(
              title: 'Pending Verifications',
              value: state.stats?.pendingVerifications.toString() ?? '0',
              subtitle: 'documents in progress',
              icon: Iconsax.clock,
              color: AppColors.kWarningColor,
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

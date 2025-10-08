import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import 'dashboard_icon_button.dart';

/// Header widget with title and action buttons
class DashboardHeader extends StatelessWidget {
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  const DashboardHeader({
    super.key,
    required this.onNotifications,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kSurfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.kShadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dashboard Title
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.kTextPrimaryColor,
            ),
          ),

          // Action Buttons
          Row(
            children: [
              // Notifications Button
              DashboardIconButton(
                icon: Iconsax.notification,
                onTap: onNotifications,
              ),

              12.widthBox,

              // Profile Button
              DashboardIconButton(icon: Iconsax.user, onTap: onProfile),
            ],
          ),
        ],
      ),
    );
  }
}

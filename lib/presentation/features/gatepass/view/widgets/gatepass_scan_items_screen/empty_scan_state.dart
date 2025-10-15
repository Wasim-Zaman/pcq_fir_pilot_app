import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

/// Empty scan state widget
class EmptyScanState extends StatelessWidget {
  const EmptyScanState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.scanner, size: 80, color: AppColors.kTextSecondaryColor),
          16.heightBox,
          Text(
            'No item scanned yet',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.kTextSecondaryColor,
            ),
          ),
          8.heightBox,
          Text(
            'Tap the scan button to start',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.kTextSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

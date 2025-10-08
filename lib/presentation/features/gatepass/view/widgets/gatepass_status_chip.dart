import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';

/// Status chip widget for displaying gate pass status
class GatePassStatusChip extends StatelessWidget {
  final String status;

  const GatePassStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'ARRIVED':
        backgroundColor = AppColors.kSuccessColor.withValues(alpha: 0.1);
        textColor = AppColors.kSuccessColor;
        break;
      case 'PENDING':
        backgroundColor = AppColors.kWarningColor.withValues(alpha: 0.1);
        textColor = AppColors.kWarningColor;
        break;
      case 'APPROVED':
        backgroundColor = AppColors.kInfoColor.withValues(alpha: 0.1);
        textColor = AppColors.kInfoColor;
        break;
      default:
        backgroundColor = AppColors.kTextSecondaryColor.withValues(alpha: 0.1);
        textColor = AppColors.kTextSecondaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

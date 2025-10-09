import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

/// Verification status selector widget
class VerificationStatusSelector extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const VerificationStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.kTextPrimaryColor,
          ),
        ),
        12.heightBox,
        Row(
          children: [
            Expanded(
              child: _buildStatusButton(
                context: context,
                label: 'VERIFIED',
                icon: Icons.check_circle,
                color: AppColors.kSuccessColor,
                isSelected: selectedStatus == 'VERIFIED',
                onTap: () => onStatusChanged('VERIFIED'),
              ),
            ),
            16.widthBox,
            Expanded(
              child: _buildStatusButton(
                context: context,
                label: 'UNVERIFIED',
                icon: Icons.cancel,
                color: AppColors.kErrorColor,
                isSelected: selectedStatus == 'UNVERIFIED',
                onTap: () => onStatusChanged('UNVERIFIED'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : AppColors.kSurfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.kBorderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.kIconSecondaryColor,
              size: 32,
            ),
            8.heightBox,
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : AppColors.kTextSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

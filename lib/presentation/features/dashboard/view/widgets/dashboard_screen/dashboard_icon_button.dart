import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';

/// Icon button widget for header actions
class DashboardIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const DashboardIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.kDarkPrimaryDarkColor
              : AppColors.kBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.kTextPrimaryColor),
      ),
    );
  }
}

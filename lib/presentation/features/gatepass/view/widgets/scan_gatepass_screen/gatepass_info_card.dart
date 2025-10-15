import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';

/// Reusable info card widget for gate pass details
class GatePassInfoCard extends StatelessWidget {
  final List<Widget> children;

  const GatePassInfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.kDarkShadowColor
                : AppColors.kShadowLightColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

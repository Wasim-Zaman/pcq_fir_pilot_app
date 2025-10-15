import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';

/// Information card widget containing multiple info rows
class InfoCard extends StatelessWidget {
  final List<Widget> children;

  const InfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorderLightColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.kShadowLightColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                const Divider(height: 1, color: AppColors.kBorderLightColor),
            ],
          );
        }).toList(),
      ),
    );
  }
}

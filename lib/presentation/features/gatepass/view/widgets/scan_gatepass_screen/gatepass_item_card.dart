import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';

import '../../../models/gatepass_models.dart';

/// Item card widget for displaying gate pass items
class GatePassItemCard extends StatelessWidget {
  final GatePassItem item;

  const GatePassItemCard({super.key, required this.item});

  /// Show full item details in a dialog
  void _showItemDetails(BuildContext context) {
    CustomDialog.showGatePassItemDetailsDialog(context, item: item);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kSurfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorderLightColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemCode,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kTextPrimaryColor,
                  ),
                ),
                4.heightBox,
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.kTextSecondaryColor,
                  ),
                ),
                if (item.remarks != null && item.remarks!.isNotEmpty) ...[
                  4.heightBox,
                  Text(
                    'Note: ${item.remarks}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.kWarningColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          16.widthBox,
          // Eye icon button
          InkWell(
            onTap: () => _showItemDetails(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Iconsax.eye,
                color: AppColors.kPrimaryColor,
                size: 20,
              ),
            ),
          ),
          12.widthBox,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Qty: ${item.quantity}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';

/// Scanned item card widget
class ScannedItemCard extends StatelessWidget {
  final VerifiedItem item;
  final VoidCallback? onVerify;
  final VoidCallback? onRemove;
  final bool isLoading;

  const ScannedItemCard({
    super.key,
    required this.item,
    this.onVerify,
    this.onRemove,
    this.isLoading = false,
  });

  /// Show full item details in a dialog
  void _showItemDetails(BuildContext context) {
    CustomDialog.showItemDetailsDialog(context, item: item);
  }

  /// Get status color based on verification status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        return AppColors.kSuccessColor;
      case 'pending':
        return AppColors.kWarningColor;
      case 'rejected':
      case 'failed':
        return AppColors.kErrorColor;
      default:
        return AppColors.kTextSecondaryColor;
    }
  }

  /// Check if item is already verified
  bool _isItemVerified() {
    final status = item.verificationStatus.toLowerCase();
    return status == 'verified' || status == 'approved';
  }

  @override
  Widget build(BuildContext context) {
    final isVerified = _isItemVerified();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVerified
              ? AppColors.kSuccessColor.withValues(alpha: 0.3)
              : AppColors.kBorderLightColor,
          width: isVerified ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isVerified
                ? AppColors.kSuccessColor.withValues(alpha: 0.1)
                : AppColors.kHoverColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Code
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.itemCode,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
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
                  8.widthBox,
                  // Show checkmark only if verified
                  if (isVerified)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.kSuccessColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.kSuccessColor,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ],
          ),
          12.heightBox,

          // Description
          Text(item.description, style: TextStyle(fontSize: 14)),
          16.heightBox,

          // Divider
          Divider(
            color: isDarkMode
                ? AppColors.kBorderLightColor
                : AppColors.kDarkBorderColor,
          ),
          16.heightBox,

          // Quantity
          InfoRow(label: 'Quantity', value: '${item.quantity} ${item.uom}'),
          12.heightBox,

          // UOM
          InfoRow(label: 'Unit of Measure', value: item.uom),
          12.heightBox,

          // Verification Status
          InfoRow(
            label: 'Status',
            value: item.verificationStatus.toUpperCase(),
            valueColor: _getStatusColor(item.verificationStatus),
          ),

          // Show verified quantity if item is verified
          if (_isItemVerified()) ...[
            12.heightBox,
            InfoRow(
              label: 'Verified Quantity',
              value: '${item.verifiedQuantity} ${item.uom}',
            ),
          ],

          if (item.remarks.isNotEmpty) ...[
            12.heightBox,
            InfoRow(label: 'Remarks', value: item.remarks),
          ],

          // Show verification remarks if item is verified and has remarks
          if (_isItemVerified() && item.verificationRemarks.isNotEmpty) ...[
            12.heightBox,
            InfoRow(
              label: 'Verification Remarks',
              value: item.verificationRemarks,
            ),
          ],

          // Action Buttons
          if (onVerify != null || onRemove != null) ...[
            16.heightBox,
            Divider(
              color: isDarkMode
                  ? AppColors.kBorderLightColor
                  : AppColors.kDarkBorderColor,
            ),
            16.heightBox,
            // Show "Already Verified" message if item is verified
            if (_isItemVerified()) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.kSuccessColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.kSuccessColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.verify5,
                      color: AppColors.kSuccessColor,
                      size: 20,
                    ),
                    8.widthBox,
                    const Text(
                      'Item Verified',
                      style: TextStyle(
                        color: AppColors.kSuccessColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              if (onRemove != null) ...[
                12.heightBox,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : onRemove,
                    icon: const Icon(Iconsax.trash, size: 18),
                    label: const Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.kErrorColor,
                      side: const BorderSide(color: AppColors.kErrorColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ] else ...[
              // Show action buttons for unverified items
              // Row(
              //   children: [
              //     if (onRemove != null)
              //       Expanded(
              //         child: OutlinedButton.icon(
              //           onPressed: isLoading ? null : onRemove,
              //           icon: const Icon(Iconsax.trash, size: 18),
              //           label: const Text('Remove'),
              //           style: OutlinedButton.styleFrom(
              //             foregroundColor: AppColors.kErrorColor,
              //             side: const BorderSide(color: AppColors.kErrorColor),
              //             padding: const EdgeInsets.symmetric(vertical: 12),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //           ),
              //         ),
              //       ),
              //     if (onRemove != null && onVerify != null) 12.widthBox,
              //     if (onVerify != null)
              //       Expanded(
              //         child: ElevatedButton.icon(
              //           onPressed: isLoading ? null : onVerify,
              //           icon: isLoading
              //               ? const SizedBox(
              //                   width: 18,
              //                   height: 18,
              //                   child: CircularProgressIndicator(
              //                     strokeWidth: 2,
              //                     valueColor: AlwaysStoppedAnimation<Color>(
              //                       AppColors.kCardColor,
              //                     ),
              //                   ),
              //                 )
              //               : const Icon(Iconsax.verify5, size: 18),
              //           label: Text(isLoading ? 'Verifying...' : 'Verify'),
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: AppColors.kSuccessColor,
              //             foregroundColor: AppColors.kCardColor,
              //             padding: const EdgeInsets.symmetric(vertical: 12),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //           ),
              //         ),
              //       ),
              //   ],
              // ),
            ],
          ],
        ],
      ),
    );
  }
}

/// Info row widget for displaying label-value pairs
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color:
                  valueColor ??
                  (isDarkMode
                      ? AppColors.kDarkTextPrimaryColor
                      : AppColors.kTextSecondaryColor),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

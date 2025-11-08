import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/datetime_extension.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

class CustomDialog {
  static void showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Show success dialog for scan operations (green theme with checkmark)
  static void showScanSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon with circular background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.kSuccessColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.kSuccessColor,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kSuccessColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.kTextSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Continue button - navigates to dashboard
                CustomButton(
                  text: "Go to Dashboard",
                  icon: const Icon(Iconsax.tick_circle),
                  width: double.infinity,
                  onPressed: () {
                    // Close dialog and navigate to dashboard
                    Navigator.of(dialogContext).pop();
                    context.go(kDashboardRoute);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show error dialog for scan operations (red theme with error icon)
  static void showScanErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error icon with circular background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.kErrorColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: AppColors.kErrorColor,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kErrorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.kTextSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Try Again button
                CustomButton(
                  text: "Try Again",
                  icon: Icon(Iconsax.refresh),
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show input dialog for text input (e.g., pass number, item ID)
  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    required String hintText,
    String? initialValue,
    String? prefixText,
    Widget? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool autofocus = true,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: CustomTextField(
            controller: controller,
            hintText: hintText,
            prefixText: prefixText,
            prefixIcon: prefixIcon ?? Icon(Iconsax.barcode),
            keyboardType: keyboardType,
            autofocus: autofocus,
            validator:
                validator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Field cannot be empty';
                  }
                  return null;
                },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, value);
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: "Submit",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }

  /// Show item details dialog with complete information
  static void showItemDetailsDialog(
    BuildContext context, {
    required VerifiedItem item,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: AppColors.kPrimaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.document_text5,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    12.widthBox,
                    const Expanded(
                      child: Text(
                        'Item Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item header card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.kHighlightColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.kPrimaryColor.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.box5,
                                  color: AppColors.kPrimaryColor,
                                  size: 20,
                                ),
                                8.widthBox,
                                Expanded(
                                  child: Text(
                                    item.itemCode,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            8.heightBox,
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.kTextSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.heightBox,

                      _DetailSection(
                        title: 'Basic Information',
                        icon: Iconsax.info_circle5,
                        children: [
                          _DetailRow(label: 'Item Code', value: item.itemCode),
                          _DetailRow(
                            label: 'Description',
                            value: item.description,
                          ),
                          _DetailRow(
                            label: 'SR No',
                            value: item.srNo.toString(),
                          ),
                        ],
                      ),
                      16.heightBox,
                      _DetailSection(
                        title: 'Quantity Information',
                        icon: Iconsax.weight5,
                        children: [
                          _DetailRow(
                            label: 'Quantity',
                            value: '${item.quantity} ${item.uom}',
                          ),
                          _DetailRow(
                            label: 'Verified Quantity',
                            value: '${item.verifiedQuantity} ${item.uom}',
                          ),
                          _DetailRow(label: 'Unit of Measure', value: item.uom),
                          if (item.hasDiscrepancy)
                            _DetailRow(
                              label: 'Quantity Difference',
                              value: item.quantityDifference.toString(),
                              valueColor: AppColors.kErrorColor,
                            ),
                          _DetailRow(
                            label: 'Has Discrepancy',
                            value: item.hasDiscrepancy ? 'Yes' : 'No',
                            valueColor: item.hasDiscrepancy
                                ? AppColors.kErrorColor
                                : AppColors.kSuccessColor,
                          ),
                        ],
                      ),
                      16.heightBox,
                      _DetailSection(
                        title: 'Verification Details',
                        icon: Iconsax.verify5,
                        children: [
                          _DetailRow(
                            label: 'Status',
                            value: item.verificationStatus,
                            valueColor: _getStatusColor(
                              item.verificationStatus,
                            ),
                          ),
                          _DetailRow(
                            label: 'Verified At',
                            value: item.verifiedAt.toFormattedDateTime(),
                          ),
                          _DetailRow(
                            label: 'Verified By ID',
                            value: item.verifiedById,
                          ),
                          if (item.verificationRemarks.isNotEmpty)
                            _DetailRow(
                              label: 'Verification Remarks',
                              value: item.verificationRemarks,
                            ),
                        ],
                      ),
                      if (item.remarks.isNotEmpty) ...[
                        16.heightBox,
                        _DetailSection(
                          title: 'Additional Information',
                          icon: Iconsax.message_text5,
                          children: [
                            _DetailRow(label: 'Remarks', value: item.remarks),
                          ],
                        ),
                      ],
                      16.heightBox,
                      _DetailSection(
                        title: 'System Information',
                        icon: Iconsax.setting_25,
                        children: [
                          _DetailRow(
                            label: 'Gate Pass ID',
                            value: item.gatePassId,
                          ),
                          if (item.itemId != null)
                            _DetailRow(label: 'Item ID', value: item.itemId!),
                          _DetailRow(
                            label: 'Created At',
                            value: item.createdAt.toFormattedDateTime(),
                          ),
                          _DetailRow(
                            label: 'Updated At',
                            value: item.updatedAt.toFormattedDateTime(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show gate pass item details dialog
  static void showGatePassItemDetailsDialog(
    BuildContext context, {
    required GatePassItem item,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: AppColors.kPrimaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.box5,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    12.widthBox,
                    const Expanded(
                      child: Text(
                        'Item Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item header card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.kHighlightColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.kPrimaryColor.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.box5,
                                  color: AppColors.kPrimaryColor,
                                  size: 20,
                                ),
                                8.widthBox,
                                Expanded(
                                  child: Text(
                                    item.itemCode,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            8.heightBox,
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.kTextSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.heightBox,

                      _DetailSection(
                        title: 'Basic Information',
                        icon: Iconsax.info_circle5,
                        children: [
                          _DetailRow(label: 'Item Code', value: item.itemCode),
                          _DetailRow(
                            label: 'Description',
                            value: item.description,
                          ),
                          _DetailRow(
                            label: 'SR No',
                            value: item.srNo.toString(),
                          ),
                        ],
                      ),
                      16.heightBox,

                      _DetailSection(
                        title: 'Quantity Information',
                        icon: Iconsax.weight5,
                        children: [
                          _DetailRow(
                            label: 'Quantity',
                            value: '${item.quantity} ${item.uom}',
                          ),
                          _DetailRow(label: 'Unit of Measure', value: item.uom),
                        ],
                      ),

                      if (item.remarks != null && item.remarks!.isNotEmpty) ...[
                        16.heightBox,
                        _DetailSection(
                          title: 'Additional Information',
                          icon: Iconsax.message_text5,
                          children: [
                            _DetailRow(label: 'Remarks', value: item.remarks!),
                          ],
                        ),
                      ],

                      16.heightBox,
                      _DetailSection(
                        title: 'System Information',
                        icon: Iconsax.setting_25,
                        children: [
                          _DetailRow(
                            label: 'Gate Pass ID',
                            value: item.gatePassId,
                          ),
                          if (item.itemId != null)
                            _DetailRow(label: 'Item ID', value: item.itemId!),
                          _DetailRow(label: 'ID', value: item.id),
                          _DetailRow(
                            label: 'Created At',
                            value: item.createdAt.toFormattedDateTime(),
                          ),
                          _DetailRow(
                            label: 'Updated At',
                            value: item.updatedAt.toFormattedDateTime(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get status color based on verification status
  static Color _getStatusColor(String status) {
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
}

/// Detail section widget for dialog
class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 16, color: AppColors.kPrimaryColor),
            ),
            8.widthBox,
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.kDarkTextPrimaryColor
                    : AppColors.kTextPrimaryColor,
              ),
            ),
          ],
        ),
        12.heightBox,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.kDarkBackgroundColor
                : AppColors.kBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.kDarkBorderColor
                  : AppColors.kBorderLightColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

/// Detail row widget for dialog
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode
                    ? AppColors.kDarkTextSecondaryColor
                    : AppColors.kTextSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          8.widthBox,
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color:
                    valueColor ??
                    (isDarkMode
                        ? AppColors.kDarkTextPrimaryColor
                        : AppColors.kTextPrimaryColor),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/item_verification_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/delete_confirmation_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/item_details_dialog.dart';

/// Verified item card widget
class VerifiedItemCard extends ConsumerWidget {
  final dynamic item;

  const VerifiedItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkmark icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.green.shade700, size: 24),
          ),
          16.widthBox,

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemCode ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Quantity badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item.verifiedQuantity ?? item.quantity ?? 0} ${item.uom ?? ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                6.heightBox,
                Text(
                  item.description ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                8.heightBox,
                // Action buttons: view and delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => ItemDetailsDialog(item: item),
                        );
                      },
                      icon: const Icon(Iconsax.eye, size: 20),
                      tooltip: 'View details',
                    ),
                    IconButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => const DeleteConfirmationDialog(),
                        );

                        if (confirmed == true) {
                          // remove from provider
                          ref
                              .read(itemVerificationProvider.notifier)
                              .removeVerifiedItem(item.id);

                          // show snackbar
                          if (context.mounted) {
                            CustomSnackbar.showError(
                              context,
                              'Scanned item removed',
                            );
                          }
                        }
                      },
                      icon: const Icon(
                        Iconsax.trash,
                        size: 20,
                        color: AppColors.kErrorColor,
                      ),
                      tooltip: 'Delete scanned item',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

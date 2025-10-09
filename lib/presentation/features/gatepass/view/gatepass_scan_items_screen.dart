import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/item_verification_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

/// Item Verification Screen with QR scanning capability
class GatePassScanItemsScreen extends ConsumerStatefulWidget {
  const GatePassScanItemsScreen({super.key});

  @override
  ConsumerState<GatePassScanItemsScreen> createState() =>
      _GatePassScanItemsScreenState();
}

class _GatePassScanItemsScreenState
    extends ConsumerState<GatePassScanItemsScreen> {
  final TextEditingController _scanController = TextEditingController();

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  /// Show scan dialog
  void _showScanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Scan Item/QR Code',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _scanController,
              hintText: 'Scan or enter item ID',
              prefixIcon: const Icon(Iconsax.scan_barcode),
              keyboardType: TextInputType.text,
              autofocus: true,
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.pop(context);
                  _handleScan(value);
                }
              },
            ),
            12.heightBox,
            const Text(
              'Scan using PDA device or enter manually',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _scanController.clear();
            },
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Scan',
            onPressed: () {
              if (_scanController.text.isNotEmpty) {
                Navigator.pop(context);
                _handleScan(_scanController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Handle scan action
  Future<void> _handleScan(String itemId) async {
    _scanController.clear();

    // Call the provider to fetch item verification
    await ref
        .read(itemVerificationProvider.notifier)
        .fetchItemVerification(itemId);
  }

  @override
  Widget build(BuildContext context) {
    final itemVerificationState = ref.watch(itemVerificationProvider);

    return itemVerificationState.when(
      data: (state) {
        return CustomScaffold(
          appBar: AppBar(
            title: const Text('Item Verification'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Scan Section
                  _buildScanSection(),
                  24.heightBox,

                  // Verified Items Section
                  if (state.verifiedItems.isNotEmpty) ...[
                    _buildVerifiedItemsHeader(state.verifiedItems.length),
                    16.heightBox,
                    Expanded(
                      child: _buildVerifiedItemsList(state.verifiedItems),
                    ),
                  ] else ...[
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.scan_barcode,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No items scanned yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Show error if any
                  if (state.error != null) ...[
                    16.heightBox,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          12.widthBox,
                          Expanded(
                            child: Text(
                              state.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Show loading indicator
                  if (state.isLoading) ...[
                    16.heightBox,
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const CustomScaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => CustomScaffold(
        appBar: AppBar(title: const Text('Item Verification')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              16.heightBox,
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build scan section with QR code button
  Widget _buildScanSection() {
    return InkWell(
      onTap: _showScanDialog,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimaryColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Iconsax.scan_barcode,
                size: 48,
                color: AppColors.kPrimaryColor,
              ),
            ),
            16.heightBox,
            Text(
              'Scan Item/QR Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.kPrimaryColor,
              ),
            ),
            8.heightBox,
            Text(
              'Tap to scan or enter item ID',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  /// Build verified items header
  Widget _buildVerifiedItemsHeader(int itemCount) {
    // Allow any number of items; show count only
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          itemCount == 1 ? 'Verified Item' : 'Verified Items',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          '$itemCount',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// Build verified items list
  Widget _buildVerifiedItemsList(List verifiedItems) {
    return ListView.separated(
      itemCount: verifiedItems.length,
      separatorBuilder: (context, index) => 12.heightBox,
      itemBuilder: (context, index) {
        final item = verifiedItems[index];
        return _buildVerifiedItemCard(item);
      },
    );
  }

  /// Build individual verified item card
  Widget _buildVerifiedItemCard(dynamic item) {
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
                        // Show details dialog
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(item.itemCode ?? 'Item Details'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description: ${item.description ?? ''}'),
                                8.heightBox,
                                Text(
                                  'Quantity: ${item.quantity ?? 0} ${item.uom ?? ''}',
                                ),
                                8.heightBox,
                                Text(
                                  'Verified Quantity: ${item.verifiedQuantity ?? 0}',
                                ),
                                8.heightBox,
                                Text(
                                  'Verification Status: ${item.verificationStatus ?? ''}',
                                ),
                                8.heightBox,
                                Text(
                                  'Remarks: ${item.verificationRemarks ?? ''}',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Iconsax.eye, size: 20),
                      tooltip: 'View details',
                    ),
                    IconButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete scanned item'),
                            content: const Text(
                              'Are you sure you want to remove this scanned item?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
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
                        color: Colors.red,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/gatepass_scan_item_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/empty_scan_state.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/scanned_item_card.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

/// Item Verification Screen with QR scanning capability
class GatePassScanItemsScreen extends ConsumerStatefulWidget {
  final GatePass gatePass;

  const GatePassScanItemsScreen({super.key, required this.gatePass});

  @override
  ConsumerState<GatePassScanItemsScreen> createState() =>
      _GatePassScanItemsScreenState();
}

class _GatePassScanItemsScreenState
    extends ConsumerState<GatePassScanItemsScreen> {
  final TextEditingController _scanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // clear the state and scanned items when screen is initialized
    Future.microtask(() {
      ref.read(gatePassScanItemProvider.notifier).clearScannedItems();

      // Show scan dialog on screen load
      _scanItemDialog();
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  /// Verify a specific scanned item
  void _verifyItem(VerifiedItem item) {
    // Check if item is already verified
    final status = item.verificationStatus.toLowerCase();
    final isVerified = status == 'verified' || status == 'approved';

    if (isVerified) {
      // Don't navigate if already verified
      return;
    }

    // Navigate to verification screen
    ref
        .read(gatePassScanItemProvider.notifier)
        .handleVerifyItem(widget.gatePass, item);

    // The state will be automatically updated by the verifyItemProvider
    // when the verification is complete
  }

  /// Remove a scanned item from the list
  void _removeItem(String itemId) {
    ref.read(gatePassScanItemProvider.notifier).removeScannedItem(itemId);
  }

  void _scanItemDialog() {
    ref
        .read(gatePassScanItemProvider.notifier)
        .showScanDialog(context, _handleScan);
  }

  /// Handle scan action
  Future<void> _handleScan(String itemId) async {
    _scanController.clear();

    // Call the provider to fetch item verification
    await ref
        .read(gatePassScanItemProvider.notifier)
        .fetchItemVerification(itemId, widget.gatePass.id);
  }

  @override
  Widget build(BuildContext context) {
    final itemVerificationState = ref.watch(gatePassScanItemProvider);

    // Listen for state changes and show dialog when appropriate
    ref.listen(gatePassScanItemProvider, (previous, next) {
      if (previous is! AsyncData<GatePassScanItemState> ||
          next is! AsyncData<GatePassScanItemState>) {
        return;
      }

      final previousState = previous.value;
      final currentState = next.value;

      // Check if we just finished loading (was loading, now not loading)
      final justFinishedLoading =
          previousState.isLoading && !currentState.isLoading;

      if (!justFinishedLoading) return;

      // Show error if present
      if (currentState.error != null) {
        CustomSnackbar.showError(context, currentState.error!);
        // Reset error and show dialog again
        ref.read(gatePassScanItemProvider.notifier).resetError();
        if (currentState.scannedAll) return;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) _scanItemDialog();
        });
        return;
      }

      // Show scan dialog again if not all items are scanned
      if (!currentState.scannedAll) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) _scanItemDialog();
        });
      }
    });

    return itemVerificationState.when(
      data: (state) {
        return CustomScaffold(
          appBar: AppBar(title: const Text('Scan Items')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Scanned Items List Section
                if (state.scannedItems.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scanned Items (${state.scannedItems.length})',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.scannedItems.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            ref
                                .read(gatePassScanItemProvider.notifier)
                                .clearScannedItems();
                          },
                          icon: const Icon(
                            Iconsax.trash,
                            size: 18,
                            color: AppColors.kErrorColor,
                          ),
                          label: const Text(
                            'Clear All',
                            style: TextStyle(color: AppColors.kErrorColor),
                          ),
                        ),
                    ],
                  ),
                  16.heightBox,
                  // List of scanned items
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.scannedItems.length,
                    separatorBuilder: (context, index) => 16.heightBox,
                    itemBuilder: (context, index) {
                      final item = state.scannedItems[index];
                      return ScannedItemCard(
                        item: item,
                        isLoading: state.isLoading,
                        onVerify: () => _verifyItem(item),
                        onRemove: () => _removeItem(item.id),
                      );
                    },
                  ),
                ] else ...[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const EmptyScanState(),
                  ),
                ],

                // Show success message if all items are scanned
                if (state.scannedAll && state.message != null) ...[
                  16.heightBox,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kSuccessColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.kSuccessColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.kSuccessColor,
                          size: 24,
                        ),
                        12.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Success!',
                                style: TextStyle(
                                  color: AppColors.kSuccessColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              4.heightBox,
                              Text(
                                state.message!,
                                style: const TextStyle(
                                  color: AppColors.kSuccessColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Show error if any
                if (state.error != null) ...[
                  16.heightBox,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kErrorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.kErrorColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.kErrorColor,
                        ),
                        12.widthBox,
                        Expanded(
                          child: Text(
                            state.error!,
                            style: const TextStyle(
                              color: AppColors.kErrorColor,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.kErrorColor,
                          ),
                          onPressed: () {
                            ref
                                .read(gatePassScanItemProvider.notifier)
                                .resetError();
                          },
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
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.kErrorColor,
              ),
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
}

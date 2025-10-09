import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/item_verification_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/gatepass_item_verification_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/empty_scan_state.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/scan_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/scan_section.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/scanned_item_card.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

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
      builder: (context) => ScanDialog(
        controller: _scanController,
        onCancel: () => _scanController.clear(),
        onScan: _handleScan,
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

  /// Handle verify item button
  void _handleVerifyItem() async {
    final currentState = ref.read(itemVerificationProvider).value;

    if (currentState?.verifiedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No item to verify'),
          backgroundColor: AppColors.kErrorColor,
        ),
      );
      return;
    }

    final item = currentState!.verifiedItem!;

    // Navigate to verification screen
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => GatePassItemVerificationScreen(
          gatePassId: item.gatePassId,
          item: item,
        ),
      ),
    );

    // If verification was successful, the item is already cleared in the verification screen
    // No need to do anything here
    if (result == true) {
      // Item was verified and screen returned true
      // The verification screen already handles clearing the item
    }
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
                  ScanSection(onTap: _showScanDialog),
                  24.heightBox,

                  // Verified Item Section
                  if (state.verifiedItem != null) ...[
                    const Text(
                      'Scanned Item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    16.heightBox,
                    ScannedItemCard(item: state.verifiedItem!),
                    24.heightBox,

                    // Verify Item Button
                    CustomButton(
                      text: "Verify Item",
                      width: double.infinity,
                      icon: Icon(Iconsax.verify1),
                      backgroundColor: AppColors.kSuccessColor,
                      onPressed: state.isLoading ? null : _handleVerifyItem,
                    ),
                  ] else ...[
                    const EmptyScanState(),
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
                                  .read(itemVerificationProvider.notifier)
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

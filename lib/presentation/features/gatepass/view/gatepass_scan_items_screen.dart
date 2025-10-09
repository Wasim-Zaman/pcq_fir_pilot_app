import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/item_verification_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/scan_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/scan_section.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/verified_items_header.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/verified_items_list.dart';
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

                  // Verified Items Section
                  if (state.verifiedItems.isNotEmpty) ...[
                    VerifiedItemsHeader(itemCount: state.verifiedItems.length),
                    16.heightBox,
                    Expanded(
                      child: VerifiedItemsList(
                        verifiedItems: state.verifiedItems,
                      ),
                    ),
                  ] else ...[
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
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
}

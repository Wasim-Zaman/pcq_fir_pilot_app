import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import '../providers/gatepass_scan_provider.dart';
import 'widgets/scan_option_card.dart';

/// Scan Barcode screen for document input
class ScanBarcodeScreen extends ConsumerWidget {
  const ScanBarcodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanBarcodeProvider);

    return CustomScaffold(
      appBar: AppBar(title: const Text('')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              8.heightBox,
              // Title
              Text(
                'Document Input',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              40.heightBox,
              // Scan QR Code Card
              ScanOptionCard(
                icon: Iconsax.scan,
                title: 'Scan QR Code',
                subtitle: 'Use camera to scan\ndocument QR code',
                onTap: () => _handleScanQRCode(context, ref),
              ),
              24.heightBox,
              // Manual Input Card
              ScanOptionCard(
                icon: Iconsax.keyboard,
                title: 'Manual Input',
                subtitle: 'Enter document\ndetails manually',
                onTap: () => _handleManualInput(context, ref),
              ),
              const Spacer(),
              // Loading indicator
              if (scanState.maybeWhen(
                data: (state) => state.isLoading,
                orElse: () => false,
              ))
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: CircularProgressIndicator(),
                ),
              24.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  void _handleScanQRCode(BuildContext context, WidgetRef ref) {
    // TODO: Navigate to camera scanner or trigger scan
    ref.read(scanBarcodeProvider.notifier).scanQRCode();
  }

  void _handleManualInput(BuildContext context, WidgetRef ref) {
    // TODO: Navigate to manual input screen or show dialog
    _showManualInputDialog(context, ref);
  }

  void _showManualInputDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Input'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter document code',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            Navigator.pop(context);
            if (value.trim().isNotEmpty) {
              ref.read(scanBarcodeProvider.notifier).submitManualInput(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final code = controller.text.trim();
              if (code.isNotEmpty) {
                ref.read(scanBarcodeProvider.notifier).submitManualInput(code);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

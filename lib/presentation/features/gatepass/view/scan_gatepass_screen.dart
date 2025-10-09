import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import 'widgets/scan_gatepass_screen/scan_option_card.dart';

/// Scan Barcode screen for document input
class ScanGatepassScreen extends ConsumerWidget {
  const ScanGatepassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      appBar: AppBar(),
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
                onTap: () => _showPassNumberDialog(context, true),
              ),
              24.heightBox,
              // Manual Input Card
              ScanOptionCard(
                icon: Iconsax.keyboard,
                title: 'Manual Input',
                subtitle: 'Enter document\ndetails manually',
                onTap: () => _showPassNumberDialog(context, false),
              ),
              const Spacer(),
              24.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  /// Show dialog for entering pass number
  /// [isScan] determines if this was triggered by scan or manual input
  void _showPassNumberDialog(BuildContext context, bool isScan) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isScan ? 'Scan Pass Number' : 'Enter Pass Number'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isScan)
                Text(
                  'Use your PDA device to scan the QR code or enter manually',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              if (isScan) 16.heightBox,
              TextFormField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Pass Number',
                  hintText: 'e.g., AQPCI-2025000001',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a pass number';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    _navigateToDetails(context, value.trim());
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                _navigateToDetails(context, controller.text.trim());
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  /// Navigate to gate pass details screen
  void _navigateToDetails(BuildContext context, String passNumber) {
    context.push(kGatePassDetailsRoute, extra: passNumber);
  }
}

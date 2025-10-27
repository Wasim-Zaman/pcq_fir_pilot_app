import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import 'widgets/scan_gatepass_screen/scan_option_card.dart';

/// Scan Barcode screen for document input
class ScanGatepassScreen extends ConsumerWidget {
  const ScanGatepassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      appBar: AppBar(title: const Text('Scan Gatepass')),
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Scan QR Code Card
            ScanOptionCard(
              icon: Iconsax.scan,
              title: 'Scan QR Code',
              subtitle:
                  'Use PDA (Personal Digital Assistant) to scan\ndocument QR code',
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
    );
  }

  /// Show dialog for entering pass number
  /// [isScan] determines if this was triggered by scan or manual input
  void _showPassNumberDialog(BuildContext context, bool isScan) async {
    final passNumber = await CustomDialog.showInputDialog(
      context,
      title: isScan ? 'Scan Pass Number' : 'Enter Pass Number',
      hintText: 'e.g., AQPCI-2025000001',
      prefixIcon: const Icon(Iconsax.barcode),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a pass number';
        }
        return null;
      },
    );

    if (passNumber != null && passNumber.isNotEmpty) {
      if (context.mounted) {
        _navigateToDetails(context, passNumber);
      }
    }
  }

  /// Navigate to gate pass details screen
  void _navigateToDetails(BuildContext context, String passNumber) {
    context.push(kGatePassDetailsRoute, extra: passNumber);
  }
}

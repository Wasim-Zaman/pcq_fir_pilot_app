import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';

class GatePassActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String passNumber;
  final String status;

  const GatePassActionButton({
    super.key,
    required this.onPressed,
    required this.passNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: _getButtonText(),
      icon: const Icon(Iconsax.verify),
      onPressed: onPressed,
    );
  }

  // Get the dynamic button text based on approval status
  String _getButtonText() {
    // normalize status: lower case and remove non-alphanumeric chars
    final normalized = status.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    switch (normalized) {
      case 'approved':
        return 'Check-Out';
      case 'intransit':
        return 'Check-In';
      case 'arrived':
        return 'Return-Out';
      case 'returning':
        return 'Return-In';
      case 'completed':
        return 'Journey Completed';
      case 'pending':
        return 'Awaiting Approval';
      case 'rejected':
        return 'Verification Not Allowed';
      default:
        return 'Start Verification';
    }
  }
}

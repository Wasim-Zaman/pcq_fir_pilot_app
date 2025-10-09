import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/gatepass_verification_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';

class GatePassActionButton extends ConsumerWidget {
  final GatePass gatePass;

  const GatePassActionButton({super.key, required this.gatePass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomButton(
      text: _getButtonText(),
      icon: const Icon(Iconsax.verify),
      onPressed: () => _handleButtonPress(context),
    );
  }

  // Get the dynamic button text based on approval status
  String _getButtonText() {
    // normalize status: lower case and remove non-alphanumeric chars
    final normalized = gatePass.status.toLowerCase().replaceAll(
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

  void _handleButtonPress(BuildContext context) {
    // Handle button press based on gate pass status
    final normalized = gatePass.status.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    switch (normalized) {
      case 'approved':
        // Navigate to Check-Out verification screen
        _navigateToVerificationScreen(context, 'Check-Out');
        break;
      case 'intransit':
        // Navigate to Check-In verification screen
        _navigateToVerificationScreen(context, 'Check-In');
        break;
      case 'arrived':
        // Navigate to Return-Out verification screen
        _navigateToVerificationScreen(context, 'Return-Out');
        break;
      case 'returning':
        // Navigate to Return-In verification screen
        _navigateToVerificationScreen(context, 'Return-In');
        break;
      case 'completed':
        // Journey already completed
        CustomSnackbar.showNormal(context, "Journey already completed");
        break;
      case 'pending':
        // Awaiting approval
        CustomSnackbar.showNormal(context, "Gate Pass is awaiting approval");
        break;
      case 'rejected':
        // Verification not allowed
        CustomSnackbar.showNormal(
          context,
          "Verification not allowed for rejected Gate Pass",
        );
        break;
      default:
        // Start verification process
        CustomSnackbar.showNormal(context, "Starting verification process");
    }
  }

  /// Navigate to the verification screen
  void _navigateToVerificationScreen(BuildContext context, String actionType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GatePassVerificationScreen(
          gatePass: gatePass,
          actionType: actionType,
        ),
      ),
    );
  }
}

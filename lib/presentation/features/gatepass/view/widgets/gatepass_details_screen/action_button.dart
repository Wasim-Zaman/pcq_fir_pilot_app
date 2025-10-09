import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/gatepass_scan_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

class GatePassActionButton extends ConsumerWidget {
  final GatePass gatePass;

  const GatePassActionButton({super.key, required this.gatePass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomButton(
      text: _getButtonText(),
      icon: const Icon(Iconsax.verify),
      isLoading: ref.watch(gatePassScanProvider).isLoading,
      onPressed: () => _handleButtonPress(context, ref),
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

  void _handleButtonPress(BuildContext context, WidgetRef ref) {
    // Handle button press based on gate pass status
    final normalized = gatePass.status.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    switch (normalized) {
      case 'approved':
        // Handle Check-Out action
        _showNotesDialog(
          context: context,
          ref: ref,
          title: 'Check-Out',
          actionType: 'Check-Out',
        );
        break;
      case 'intransit':
        // Handle Check-In action
        _showNotesDialog(
          context: context,
          ref: ref,
          title: 'Check-In',
          actionType: 'Check-In',
        );
        break;
      case 'arrived':
        // Handle Return-Out action
        _showNotesDialog(
          context: context,
          ref: ref,
          title: 'Return-Out',
          actionType: 'Return-Out',
        );
        break;
      case 'returning':
        // Handle Return-In action
        _showNotesDialog(
          context: context,
          ref: ref,
          title: 'Return-In',
          actionType: 'Return-In',
        );
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

  /// Show dialog for entering notes before performing scan action
  void _showNotesDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String actionType,
  }) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('$title Notes'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add optional notes for this $title action',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              16.heightBox,
              CustomTextField(
                controller: controller,
                autofocus: true,
                maxLines: 3,
                labelText: 'Notes (Optional)',
                hintText: 'Enter any additional notes...',
                prefixIcon: const Icon(Icons.note_outlined),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: "Confirm",
            onPressed: () {
              Navigator.pop(context);
              final notes = controller.text.trim().isEmpty
                  ? null
                  : controller.text.trim();
              _performScanAction(
                context: context,
                ref: ref,
                actionType: actionType,
                notes: notes,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Perform the actual scan action based on action type
  void _performScanAction({
    required BuildContext context,
    required WidgetRef ref,
    required String actionType,
    String? notes,
  }) {
    final scanNotifier = ref.read(gatePassScanProvider.notifier);

    switch (actionType) {
      case 'Check-Out':
        scanNotifier.performCheckOut(
          context: context,
          gatePassId: gatePass.id,
          notes: notes,
        );
        break;
      case 'Check-In':
        scanNotifier.performCheckIn(
          context: context,
          gatePassId: gatePass.id,
          notes: notes,
        );
        break;
      case 'Return-Out':
        scanNotifier.performReturnOut(
          context: context,
          gatePassId: gatePass.id,
          notes: notes,
        );
        break;
      case 'Return-In':
        scanNotifier.performReturnIn(
          context: context,
          gatePassId: gatePass.id,
          notes: notes,
        );
        break;
    }
  }
}

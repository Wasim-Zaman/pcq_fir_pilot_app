import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/gatepass_scan_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

class GatePassVerificationScreen extends ConsumerStatefulWidget {
  final GatePass gatePass;
  final String actionType; // 'Check-Out', 'Check-In', 'Return-Out', 'Return-In'

  const GatePassVerificationScreen({
    super.key,
    required this.gatePass,
    required this.actionType,
  });

  @override
  ConsumerState<GatePassVerificationScreen> createState() =>
      _GatePassVerificationScreenState();
}

class _GatePassVerificationScreenState
    extends ConsumerState<GatePassVerificationScreen> {
  final TextEditingController _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasShownDialog = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(gatePassScanProvider);
    final isLoading = scanState.value?.isScanning ?? false;

    // Listen to scan state changes for showing dialogs
    ref.listen<AsyncValue<GatePassScanState>>(gatePassScanProvider, (
      previous,
      next,
    ) {
      // Prevent showing multiple dialogs
      if (_hasShownDialog) return;

      if (next.value?.successMessage != null && context.mounted) {
        _hasShownDialog = true;
        // Show success dialog
        CustomDialog.showScanSuccessDialog(
          context,
          title: '${widget.actionType} Successful',
          message: next.value!.successMessage!,
        );
      } else if (next.value?.error != null && context.mounted) {
        _hasShownDialog = true;
        // Show error dialog
        CustomDialog.showScanErrorDialog(
          context,
          title: '${widget.actionType} Failed',
          message: next.value!.error!,
        );
      }
    });

    return CustomScaffold(
      title: '${widget.actionType} Verification',
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _buildHeaderCard(),
              24.heightBox,

              // Gate Pass Details Card
              _buildGatePassDetailsCard(),
              24.heightBox,

              // Notes Section
              _buildNotesSection(isLoading),
              32.heightBox,

              // Action Button
              _buildActionButton(isLoading),
              16.heightBox,

              // Cancel Button
              CustomOutlinedButton(
                text: 'Cancel',
                isLoading: isLoading,
                width: double.infinity,
                icon: Icon(Iconsax.close_circle),
                onPressed: isLoading ? null : () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getActionColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getActionIcon(), color: _getActionColor(), size: 32),
            ),
            16.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.actionType,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getActionColor(),
                    ),
                  ),
                  4.heightBox,
                  Text(
                    'Verify and confirm this action',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGatePassDetailsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gate Pass Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            16.heightBox,
            _buildInfoRow('Pass Number', widget.gatePass.passNumber),
            12.heightBox,
            _buildInfoRow('Current Status', widget.gatePass.status),
            12.heightBox,
            _buildInfoRow('Departure', widget.gatePass.sourceFrom.name),
            12.heightBox,
            _buildInfoRow('Destination', widget.gatePass.destinationTo.name),
            12.heightBox,
            _buildInfoRow(
              'Vehicle',
              '${widget.gatePass.vehicle.plateNumber} (${widget.gatePass.vehicle.vehicleType})',
            ),
            12.heightBox,
            _buildInfoRow('Driver', widget.gatePass.driver.name),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        8.widthBox,
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        8.heightBox,
        Text(
          'Add optional notes for this ${widget.actionType} action',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        16.heightBox,
        CustomTextField(
          controller: _notesController,
          labelText: 'Notes (Optional)',
          hintText: 'Enter any additional notes or observations...',
          prefixIcon: const Icon(Icons.note_outlined),
          enabled: !isLoading,
        ),
      ],
    );
  }

  Widget _buildActionButton(bool isLoading) {
    return CustomButton(
      text: 'Confirm ${widget.actionType}',
      icon: Icon(_getActionIcon()),
      isLoading: isLoading,
      width: double.infinity,
      onPressed: isLoading ? null : _handleVerification,
    );
  }

  void _handleVerification() {
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();
    final scanNotifier = ref.read(gatePassScanProvider.notifier);

    switch (widget.actionType) {
      case 'Check-Out':
        scanNotifier.performCheckOut(
          context: context,
          gatePassId: widget.gatePass.id,
          notes: notes,
        );
        break;
      case 'Check-In':
        scanNotifier.performCheckIn(
          context: context,
          gatePassId: widget.gatePass.id,
          notes: notes,
        );
        break;
      case 'Return-Out':
        scanNotifier.performReturnOut(
          context: context,
          gatePassId: widget.gatePass.id,
          notes: notes,
        );
        break;
      case 'Return-In':
        scanNotifier.performReturnIn(
          context: context,
          gatePassId: widget.gatePass.id,
          notes: notes,
        );
        break;
    }
  }

  Color _getActionColor() {
    switch (widget.actionType) {
      case 'Check-Out':
        return Colors.blue;
      case 'Check-In':
        return Colors.green;
      case 'Return-Out':
        return Colors.orange;
      case 'Return-In':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionIcon() {
    switch (widget.actionType) {
      case 'Check-Out':
        return Iconsax.logout;
      case 'Check-In':
        return Iconsax.login;
      case 'Return-Out':
        return Iconsax.arrow_left;
      case 'Return-In':
        return Iconsax.arrow_right;
      default:
        return Iconsax.verify;
    }
  }
}

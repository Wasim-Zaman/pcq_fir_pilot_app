import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import '../models/gatepass_models.dart';
import '../providers/gatepass_details_provider.dart';
import 'widgets/gatepass_error_view.dart';
import 'widgets/gatepass_info_card.dart';
import 'widgets/gatepass_info_row.dart';
import 'widgets/gatepass_item_card.dart';
import 'widgets/gatepass_section_title.dart';
import 'widgets/gatepass_status_chip.dart';
import 'widgets/gatepass_verification_card.dart';

/// Gate Pass Details Screen
class GatePassDetailsScreen extends ConsumerStatefulWidget {
  final String passNumber;

  const GatePassDetailsScreen({super.key, required this.passNumber});

  @override
  ConsumerState<GatePassDetailsScreen> createState() =>
      _GatePassDetailsScreenState();
}

class _GatePassDetailsScreenState extends ConsumerState<GatePassDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch gate pass details on screen load
    Future.microtask(() {
      ref
          .read(gatePassDetailsProvider.notifier)
          .fetchGatePassDetails(widget.passNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gatePassState = ref.watch(gatePassDetailsProvider);

    return CustomScaffold(
      appBar: AppBar(
        title: const Text('Gate Pass Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: gatePassState.when(
        data: (state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return GatePassErrorView(
              error: state.error!,
              onRetry: () => ref
                  .read(gatePassDetailsProvider.notifier)
                  .refreshDetails(widget.passNumber),
            );
          }

          if (state.gatePass == null) {
            return const Center(child: Text('No gate pass found'));
          }

          return _buildGatePassDetails(state.gatePass!);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => GatePassErrorView(
          error: error.toString(),
          onRetry: () => ref
              .read(gatePassDetailsProvider.notifier)
              .refreshDetails(widget.passNumber),
        ),
      ),
    );
  }

  Widget _buildGatePassDetails(GatePass gatePass) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(gatePassDetailsProvider.notifier)
            .refreshDetails(widget.passNumber);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gate Pass Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GatePassStatusChip(status: gatePass.status),
              ],
            ),
            24.heightBox,

            // Gate Pass Basic Info Card
            GatePassInfoCard(
              children: [
                GatePassInfoRow(
                  label: 'Vehicle Number:',
                  value: gatePass.vehicle.plateNumber,
                ),
                16.heightBox,
                GatePassInfoRow(
                  label: 'Gate Pass Number:',
                  value: gatePass.passNumber,
                ),
                16.heightBox,
                GatePassInfoRow(
                  label: 'Date:',
                  value: _formatDate(gatePass.gatePassDate),
                ),
              ],
            ),
            24.heightBox,

            // Items Section
            const GatePassSectionTitle(title: 'Items'),
            16.heightBox,
            ...gatePass.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GatePassItemCard(item: item),
              ),
            ),
            24.heightBox,

            // Additional Information
            const GatePassSectionTitle(title: 'Additional Information'),
            16.heightBox,
            GatePassInfoCard(
              children: [
                GatePassInfoRow(label: 'Type:', value: gatePass.gatePassType),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Returnable:',
                  value: gatePass.returnable ? 'Yes' : 'No',
                ),
                12.heightBox,
                GatePassInfoRow(label: 'Sender:', value: gatePass.senderName),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Receiver:',
                  value: gatePass.receiverName,
                ),
                12.heightBox,
                GatePassInfoRow(
                  label: 'From:',
                  value: gatePass.sourceFrom.name,
                ),
                12.heightBox,
                GatePassInfoRow(
                  label: 'To:',
                  value: gatePass.destinationTo.name,
                ),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Valid Until:',
                  value: _formatDate(gatePass.validUntil),
                ),
              ],
            ),
            24.heightBox,

            // Vehicle Information
            const GatePassSectionTitle(title: 'Vehicle Information'),
            16.heightBox,
            GatePassInfoCard(
              children: [
                GatePassInfoRow(
                  label: 'Plate Number:',
                  value: gatePass.vehicle.plateNumber,
                ),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Type:',
                  value: gatePass.vehicle.vehicleType,
                ),
                12.heightBox,
                GatePassInfoRow(label: 'Make:', value: gatePass.vehicle.make),
                12.heightBox,
                GatePassInfoRow(label: 'Color:', value: gatePass.vehicle.color),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Owner:',
                  value: gatePass.vehicle.ownerCompany,
                ),
              ],
            ),
            24.heightBox,

            // Driver Information
            const GatePassSectionTitle(title: 'Driver Information'),
            16.heightBox,
            GatePassInfoCard(
              children: [
                GatePassInfoRow(label: 'Name:', value: gatePass.driver.name),
                12.heightBox,
                GatePassInfoRow(
                  label: 'License:',
                  value: gatePass.driver.licenseNumber,
                ),
                12.heightBox,
                GatePassInfoRow(label: 'Phone:', value: gatePass.driver.phone),
              ],
            ),
            24.heightBox,

            // Approval Information
            const GatePassSectionTitle(title: 'Approval Information'),
            16.heightBox,
            GatePassInfoCard(
              children: [
                GatePassInfoRow(
                  label: 'Prepared By:',
                  value: gatePass.preparedBy.fullName,
                ),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Approved By:',
                  value: gatePass.approvedBy.fullName,
                ),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Status:',
                  value: gatePass.approvalStatus,
                ),
                12.heightBox,
                GatePassInfoRow(
                  label: 'Remarks:',
                  value: gatePass.approvalRemarks,
                ),
              ],
            ),
            24.heightBox,

            // Verifications
            if (gatePass.verifications.isNotEmpty) ...[
              const GatePassSectionTitle(title: 'Verification History'),
              16.heightBox,
              ...gatePass.verifications.map(
                (verification) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GatePassVerificationCard(
                    verification: verification,
                    formatDateTime: _formatDateTime,
                  ),
                ),
              ),
              24.heightBox,
            ],

            // Start Verification Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _handleStartVerification(gatePass),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Verification'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            24.heightBox,
          ],
        ),
      ),
    );
  }

  void _handleStartVerification(GatePass gatePass) {
    // TODO: Navigate to verification screen or start verification flow
    CustomSnackbar.showNormal(
      context,
      'Starting verification for ${gatePass.passNumber}',
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gate Pass Information'),
        content: const Text(
          'This screen displays detailed information about the gate pass including items, vehicle, driver, and verification history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/core/extensions/datetime_extension.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_dialog.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import '../models/gatepass_models.dart';
import '../providers/gatepass_details_provider.dart';
import 'widgets/gatepass_details_screen/additional_info_card.dart';
import 'widgets/gatepass_details_screen/approval_info_card.dart';
import 'widgets/gatepass_details_screen/basic_info_card.dart';
import 'widgets/gatepass_details_screen/driver_info_card.dart';
// New split widgets
import 'widgets/gatepass_details_screen/header.dart';
import 'widgets/gatepass_details_screen/items_list.dart';
import 'widgets/gatepass_details_screen/vehicle_info_card.dart';
import 'widgets/gatepass_details_screen/verifications_section.dart';
import 'widgets/scan_gatepass_screen/gatepass_error_view.dart';

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
            GatePassHeader(title: 'Gate Pass Details', status: gatePass.status),
            24.heightBox,

            GatePassBasicInfoCard(
              vehicleNumber: gatePass.vehicle.plateNumber,
              passNumber: gatePass.passNumber,
              date: gatePass.gatePassDate,
            ),
            24.heightBox,

            GatePassItemsList(items: gatePass.items),
            24.heightBox,

            GatePassAdditionalInfoCard(
              gatePassType: gatePass.gatePassType,
              returnable: gatePass.returnable,
              senderName: gatePass.senderName,
              receiverName: gatePass.receiverName,
              fromName: gatePass.sourceFrom.name,
              toName: gatePass.destinationTo.name,
              validUntil: gatePass.validUntil,
            ),
            24.heightBox,

            GatePassVehicleInfoCard(vehicle: gatePass.vehicle),
            24.heightBox,

            GatePassDriverInfoCard(driver: gatePass.driver),
            24.heightBox,

            GatePassApprovalInfoCard(
              preparedBy: gatePass.preparedBy,
              approvedBy: gatePass.approvedBy,
              approvalStatus: gatePass.approvalStatus,
              approvalRemarks: gatePass.approvalRemarks,
            ),
            24.heightBox,

            GatePassVerificationsSection(
              verifications: gatePass.verifications,
              formatDateTime: _formatDateTime,
            ),
            24.heightBox,

            CustomButton(
              text: "Start Verification",
              onPressed: () {
                context.push(kGatePassScanItemRoute);
              },
            ),

            // GatePassActionButton(gatePass: gatePass),
            // 24.heightBox,
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    CustomDialog.showInfoDialog(
      context,
      title: 'Gate Pass Information',
      message:
          'This screen displays detailed information about the gate pass including items, vehicle, driver, and verification history.',
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // final day = dateTime.day.toString().padLeft(2, '0');
    // final month = dateTime.month.toString().padLeft(2, '0');
    // final year = dateTime.year.toString();
    // final hour = dateTime.hour.toString().padLeft(2, '0');
    // final minute = dateTime.minute.toString().padLeft(2, '0');
    // return '$day/$month/$year $hour:$minute';

    return dateTime.toFormattedDateTime();
  }
}

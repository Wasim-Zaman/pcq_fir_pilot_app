import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/signin_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/providers/gatepass_verify_item_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_item_verification_screen/item_info_card.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_item_verification_screen/verification_form.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_item_verification_screen/verification_status_selector.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

/// Gate Pass Item Verification Screen
class GatePassItemVerificationScreen extends ConsumerStatefulWidget {
  final GatePass gatePass;
  final VerifiedItem item;

  const GatePassItemVerificationScreen({
    super.key,
    required this.gatePass,
    required this.item,
  });

  @override
  ConsumerState<GatePassItemVerificationScreen> createState() =>
      _GatePassItemVerificationScreenState();
}

class _GatePassItemVerificationScreenState
    extends ConsumerState<GatePassItemVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _remarksController = TextEditingController();
  String _selectedStatus = 'VERIFIED';

  @override
  void initState() {
    super.initState();
    // Pre-fill with item quantity
    _quantityController.text = widget.item.quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  /// Handle submit verification
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get member ID from sign in provider
    final signInState = ref.read(signInProvider).value;
    if (signInState == null || signInState.member == null) {
      CustomSnackbar.showNormal(context, "User not authenticated");
      return;
    }

    final memberId = signInState.member!.id;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final remarks = _remarksController.text.trim();

    // Call verify item API
    await ref
        .read(verifyItemProvider.notifier)
        .verifyItem(
          gatePassId: widget.gatePass.id,
          itemId: widget.item.id,
          scannedById: memberId,
          verificationStatus: _selectedStatus,
          verifiedQuantity: quantity,
          verificationRemarks: remarks,
        );
  }

  /// Get the action type based on gate pass status (same logic as action_button.dart)
  String _getActionType() {
    final normalized = widget.gatePass.status.toLowerCase().replaceAll(
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
      default:
        return 'Start Verification';
    }
  }

  @override
  Widget build(BuildContext context) {
    final verifyItemState = ref.watch(verifyItemProvider);

    // Listen to verify item state changes
    ref.listen<AsyncValue<VerifyItemState>>(verifyItemProvider, (
      previous,
      next,
    ) {
      next.whenData((state) {
        if (state.isSuccess && state.response != null) {
          final allItemsProcessed =
              state.response!.data.verificationSummary.allItemsProcessed;

          // Show success message
          CustomSnackbar.showNormal(
            context,
            state.response?.message ?? 'Item verified successfully',
          );

          if (allItemsProcessed) {
            // Navigate to gate pass verification screen using Go Router
            context.push(
              kGatePassVerificationRoute,
              extra: {
                'gatePass': widget.gatePass,
                'actionType': _getActionType(),
              },
            );
          } else {
            // Clear the scanned item and go back to scan screen
            // ref.read(gatePassScanItemProvider.notifier).clearVerifiedItem();
            context.pop(true);
          }
        } else if (state.error != null) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.kErrorColor,
            ),
          );
        }
      });
    });

    return verifyItemState.when(
      data: (state) {
        return CustomScaffold(
          appBar: AppBar(title: const Text('Verify Item'), centerTitle: true),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Item Info Card
                    ItemInfoCard(item: widget.item),
                    24.heightBox,

                    // Verification Status Selector
                    VerificationStatusSelector(
                      selectedStatus: _selectedStatus,
                      onStatusChanged: (status) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                    ),
                    24.heightBox,

                    // Verification Form
                    VerificationForm(
                      quantityController: _quantityController,
                      remarksController: _remarksController,
                    ),
                    32.heightBox,

                    // Submit Button
                    CustomButton(
                      text: 'Submit Verification',
                      onPressed: state.isLoading ? null : _handleSubmit,
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
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
        appBar: AppBar(title: const Text('Verify Item')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.kErrorColor,
              ),
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

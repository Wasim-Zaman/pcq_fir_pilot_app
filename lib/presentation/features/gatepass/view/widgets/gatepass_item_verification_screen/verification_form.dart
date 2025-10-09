import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

/// Verification form widget
class VerificationForm extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController remarksController;
  final String? quantityError;
  final String? remarksError;

  const VerificationForm({
    super.key,
    required this.quantityController,
    required this.remarksController,
    this.quantityError,
    this.remarksError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Verified Quantity Field
        CustomTextField(
          controller: quantityController,
          labelText: 'Verified Quantity',
          hintText: 'Enter verified quantity',
          prefixIcon: const Icon(Icons.numbers),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter verified quantity';
            }
            final quantity = int.tryParse(value);
            if (quantity == null || quantity <= 0) {
              return 'Please enter a valid quantity';
            }
            return null;
          },
        ),
        if (quantityError != null) ...[
          8.heightBox,
          Text(
            quantityError!,
            style: const TextStyle(color: AppColors.kErrorColor, fontSize: 12),
          ),
        ],
        20.heightBox,

        // Verification Remarks Field
        CustomTextField(
          controller: remarksController,
          labelText: 'Verification Remarks',
          hintText: 'Enter verification remarks',
          prefixIcon: const Icon(Icons.note_alt_outlined),
          maxLines: 3,
          minLines: 3,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter verification remarks';
            }
            return null;
          },
        ),
        if (remarksError != null) ...[
          8.heightBox,
          Text(
            remarksError!,
            style: const TextStyle(color: AppColors.kErrorColor, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

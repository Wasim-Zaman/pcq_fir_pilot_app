import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

/// Verification form widget
class VerificationForm extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController remarksController;
  final String? quantityError;
  final String? remarksError;
  final int? actualQuantity;

  const VerificationForm({
    super.key,
    required this.quantityController,
    required this.remarksController,
    this.quantityError,
    this.remarksError,
    this.actualQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display actual quantity if provided
        if (actualQuantity != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  'Actual Quantity: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '$actualQuantity',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          16.heightBox,
        ],

        // Verified Quantity Field
        CustomTextField(
          controller: quantityController,
          labelText: 'Verified Quantity',
          hintText: 'Enter verified quantity',
          prefixIcon: const Icon(Iconsax.box_add),
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
          prefixIcon: const Icon(Iconsax.note),
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

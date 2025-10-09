import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

/// Scan dialog widget for item verification
class ScanDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final Function(String) onScan;

  const ScanDialog({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Scan Item/QR Code',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: controller,
            hintText: 'Scan or enter item ID',
            prefixIcon: const Icon(Iconsax.scan_barcode),
            keyboardType: TextInputType.text,
            autofocus: true,
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                Navigator.pop(context);
                onScan(value);
              }
            },
          ),
          12.heightBox,
          const Text(
            'Scan using PDA device or enter manually',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel();
          },
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: 'Scan',
          onPressed: () {
            if (controller.text.isNotEmpty) {
              Navigator.pop(context);
              onScan(controller.text);
            }
          },
        ),
      ],
    );
  }
}

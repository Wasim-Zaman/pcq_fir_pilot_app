import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

/// Item details dialog widget
class ItemDetailsDialog extends StatelessWidget {
  final dynamic item;

  const ItemDetailsDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(item.itemCode ?? 'Item Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description: ${item.description ?? ''}'),
          8.heightBox,
          Text('Quantity: ${item.quantity ?? 0} ${item.uom ?? ''}'),
          8.heightBox,
          Text('Verified Quantity: ${item.verifiedQuantity ?? 0}'),
          8.heightBox,
          Text('Verification Status: ${item.verificationStatus ?? ''}'),
          8.heightBox,
          Text('Remarks: ${item.verificationRemarks ?? ''}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

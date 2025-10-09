import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';

/// Scanned item card widget
class ScannedItemCard extends StatelessWidget {
  final VerifiedItem item;

  const ScannedItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Code
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.itemCode,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 24,
                ),
              ),
            ],
          ),
          12.heightBox,

          // Description
          Text(
            item.description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          16.heightBox,

          // Divider
          Divider(color: Colors.grey.shade200),
          16.heightBox,

          // Quantity
          InfoRow(
            label: 'Quantity',
            value: '${item.verifiedQuantity} ${item.uom}',
          ),
          12.heightBox,

          // UOM
          InfoRow(label: 'Unit of Measure', value: item.uom),
          12.heightBox,

          // Verification Status
          InfoRow(
            label: 'Status',
            value: item.verificationStatus,
            valueColor: _getStatusColor(item.verificationStatus),
          ),

          if (item.remarks.isNotEmpty) ...[
            12.heightBox,
            InfoRow(label: 'Remarks', value: item.remarks),
          ],
        ],
      ),
    );
  }

  /// Get status color based on verification status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// Info row widget for displaying label-value pairs
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

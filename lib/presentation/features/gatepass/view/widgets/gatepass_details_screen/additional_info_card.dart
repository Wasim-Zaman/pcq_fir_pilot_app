import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../scan_gatepass_screen/gatepass_info_card.dart';
import '../scan_gatepass_screen/gatepass_info_row.dart';
import '../scan_gatepass_screen/gatepass_section_title.dart';

class GatePassAdditionalInfoCard extends StatelessWidget {
  final String gatePassType;
  final bool returnable;
  final String senderName;
  final String receiverName;
  final String fromName;
  final String toName;
  final DateTime validUntil;

  const GatePassAdditionalInfoCard({
    super.key,
    required this.gatePassType,
    required this.returnable,
    required this.senderName,
    required this.receiverName,
    required this.fromName,
    required this.toName,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Additional Information'),
        16.heightBox,
        GatePassInfoCard(
          children: [
            GatePassInfoRow(label: 'Type:', value: gatePassType),
            12.heightBox,
            GatePassInfoRow(
              label: 'Returnable:',
              value: returnable ? 'Yes' : 'No',
            ),
            12.heightBox,
            GatePassInfoRow(label: 'Sender:', value: senderName),
            12.heightBox,
            GatePassInfoRow(label: 'Receiver:', value: receiverName),
            12.heightBox,
            GatePassInfoRow(label: 'From:', value: fromName),
            12.heightBox,
            GatePassInfoRow(label: 'To:', value: toName),
            12.heightBox,
            GatePassInfoRow(
              label: 'Valid Until:',
              value: _formatDate(validUntil),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}

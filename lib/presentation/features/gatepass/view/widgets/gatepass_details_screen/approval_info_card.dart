import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../scan_gatepass_screen/gatepass_info_card.dart';
import '../scan_gatepass_screen/gatepass_info_row.dart';
import '../scan_gatepass_screen/gatepass_section_title.dart';

class GatePassApprovalInfoCard extends StatelessWidget {
  final dynamic preparedBy;
  final dynamic approvedBy;
  final String approvalStatus;
  final String approvalRemarks;

  const GatePassApprovalInfoCard({
    super.key,
    required this.preparedBy,
    required this.approvedBy,
    required this.approvalStatus,
    required this.approvalRemarks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Approval Information'),
        16.heightBox,
        GatePassInfoCard(
          children: [
            GatePassInfoRow(label: 'Prepared By:', value: preparedBy.fullName),
            12.heightBox,
            GatePassInfoRow(label: 'Approved By:', value: approvedBy.fullName),
            12.heightBox,
            GatePassInfoRow(label: 'Status:', value: approvalStatus),
            12.heightBox,
            GatePassInfoRow(label: 'Remarks:', value: approvalRemarks),
          ],
        ),
      ],
    );
  }
}

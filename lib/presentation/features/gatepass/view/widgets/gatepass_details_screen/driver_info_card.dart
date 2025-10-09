import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../scan_gatepass_screen/gatepass_info_card.dart';
import '../scan_gatepass_screen/gatepass_info_row.dart';
import '../scan_gatepass_screen/gatepass_section_title.dart';

class GatePassDriverInfoCard extends StatelessWidget {
  final dynamic driver;

  const GatePassDriverInfoCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Driver Information'),
        16.heightBox,
        GatePassInfoCard(
          children: [
            GatePassInfoRow(label: 'Name:', value: driver.name),
            12.heightBox,
            GatePassInfoRow(label: 'License:', value: driver.licenseNumber),
            12.heightBox,
            GatePassInfoRow(label: 'Phone:', value: driver.phone),
          ],
        ),
      ],
    );
  }
}

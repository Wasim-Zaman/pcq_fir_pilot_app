import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../scan_gatepass_screen/gatepass_info_card.dart';
import '../scan_gatepass_screen/gatepass_info_row.dart';
import '../scan_gatepass_screen/gatepass_section_title.dart';

class GatePassVehicleInfoCard extends StatelessWidget {
  final dynamic vehicle;

  const GatePassVehicleInfoCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Vehicle Information'),
        16.heightBox,
        GatePassInfoCard(
          children: [
            GatePassInfoRow(label: 'Plate Number:', value: vehicle.plateNumber),
            12.heightBox,
            GatePassInfoRow(label: 'Type:', value: vehicle.vehicleType),
            12.heightBox,
            GatePassInfoRow(label: 'Make:', value: vehicle.make),
            12.heightBox,
            GatePassInfoRow(label: 'Color:', value: vehicle.color),
            12.heightBox,
            GatePassInfoRow(label: 'Owner:', value: vehicle.ownerCompany),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/datetime_extension.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../scan_gatepass_screen/gatepass_info_card.dart';
import '../scan_gatepass_screen/gatepass_info_row.dart';

class GatePassBasicInfoCard extends StatelessWidget {
  final String vehicleNumber;
  final String passNumber;
  final DateTime date;

  const GatePassBasicInfoCard({
    super.key,
    required this.vehicleNumber,
    required this.passNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GatePassInfoCard(
      children: [
        GatePassInfoRow(label: 'Vehicle Number:', value: vehicleNumber),
        16.heightBox,
        GatePassInfoRow(label: 'Gate Pass Number:', value: passNumber),
        16.heightBox,
        GatePassInfoRow(label: 'Date:', value: date.toFormattedDate()),
      ],
    );
  }
}

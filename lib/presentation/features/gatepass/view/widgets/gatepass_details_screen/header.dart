import 'package:flutter/material.dart';

import '../scan_gatepass_screen/gatepass_status_chip.dart';

class GatePassHeader extends StatelessWidget {
  final String title;
  final String status;

  const GatePassHeader({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(children: [GatePassStatusChip(status: status)]),
      ],
    );
  }
}

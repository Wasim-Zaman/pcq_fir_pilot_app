import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../scan_gatepass_screen/gatepass_section_title.dart';
import '../scan_gatepass_screen/gatepass_verification_card.dart';

class GatePassVerificationsSection extends StatelessWidget {
  final List verifications;

  const GatePassVerificationsSection({super.key, required this.verifications});

  @override
  Widget build(BuildContext context) {
    if (verifications.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Verification History'),
        16.heightBox,
        ...verifications.map(
          (verification) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GatePassVerificationCard(
              verification: verification,
            ),
          ),
        ),
      ],
    );
  }
}

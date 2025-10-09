import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../scan_gatepass_screen/gatepass_item_card.dart';
import '../scan_gatepass_screen/gatepass_section_title.dart';

class GatePassItemsList extends StatelessWidget {
  final List items;

  const GatePassItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Items'),
        16.heightBox,
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GatePassItemCard(item: item),
          ),
        ),
      ],
    );
  }
}

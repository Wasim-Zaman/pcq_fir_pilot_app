import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/widgets/gatepass_scan_items_screen/verified_item_card.dart';

/// Verified items list widget
class VerifiedItemsList extends StatelessWidget {
  final List verifiedItems;

  const VerifiedItemsList({super.key, required this.verifiedItems});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: verifiedItems.length,
      separatorBuilder: (context, index) => 12.heightBox,
      itemBuilder: (context, index) {
        final item = verifiedItems[index];
        return VerifiedItemCard(item: item);
      },
    );
  }
}

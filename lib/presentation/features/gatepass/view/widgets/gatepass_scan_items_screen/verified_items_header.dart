import 'package:flutter/material.dart';

/// Verified items header widget
class VerifiedItemsHeader extends StatelessWidget {
  final int itemCount;

  const VerifiedItemsHeader({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          itemCount == 1 ? 'Verified Item' : 'Verified Items',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          '$itemCount',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

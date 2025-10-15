import 'package:flutter/material.dart';

/// Section title widget for gate pass details sections
class GatePassSectionTitle extends StatelessWidget {
  final String title;

  const GatePassSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        // color: AppColors.kTextPrimaryColor,
      ),
    );
  }
}

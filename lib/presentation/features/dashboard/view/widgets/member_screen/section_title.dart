import 'package:flutter/material.dart';

/// Section title widget for organizing content sections
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // color: AppColors.kTextPrimaryColor,
      ),
    );
  }
}

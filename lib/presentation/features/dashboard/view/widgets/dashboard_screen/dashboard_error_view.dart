import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';

/// Error view widget for displaying error states
class DashboardErrorView extends StatelessWidget {
  final String title;
  final String errorMessage;
  final VoidCallback onRetry;

  const DashboardErrorView({
    super.key,
    this.title = 'Error loading dashboard',
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.kErrorColor,
            ),
            16.heightBox,
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            8.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 14,
                  // color: AppColors.kTextSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            24.heightBox,
            CustomButton(
              text: 'Retry',
              onPressed: onRetry,
              icon: const Icon(Iconsax.refresh),
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}

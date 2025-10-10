import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';

/// Error view widget for gate pass details screen
class GatePassErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const GatePassErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              size: 64,
              color: AppColors.kErrorColor.withValues(alpha: 0.7),
            ),
            16.heightBox,
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.kTextPrimaryColor,
              ),
            ),
            8.heightBox,
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.kTextSecondaryColor,
              ),
            ),
            24.heightBox,

            CustomButton(
              text: "Retry",
              icon: const Icon(Iconsax.warning_2),
              width: 300,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

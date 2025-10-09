import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';

import '../../../models/gatepass_models.dart';

/// Verification card widget for displaying verification history
class GatePassVerificationCard extends StatelessWidget {
  final Verification verification;
  final String Function(DateTime) formatDateTime;

  const GatePassVerificationCard({
    super.key,
    required this.verification,
    required this.formatDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: verification.isVerified
            ? AppColors.kSuccessColor.withValues(alpha: 0.1)
            : AppColors.kWarningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: verification.isVerified
              ? AppColors.kSuccessColor.withValues(alpha: 0.3)
              : AppColors.kWarningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                verification.scanType.replaceAll('_', ' '),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextPrimaryColor,
                ),
              ),
              Icon(
                verification.isVerified ? Icons.check_circle : Icons.warning,
                color: verification.isVerified
                    ? AppColors.kSuccessColor
                    : AppColors.kWarningColor,
              ),
            ],
          ),
          8.heightBox,
          Text(
            'Scanned by: ${verification.scannedBy.fullName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.kTextPrimaryColor,
            ),
          ),
          4.heightBox,
          Text(
            'Time: ${formatDateTime(verification.scannedAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.kTextSecondaryColor,
            ),
          ),
          if (verification.notes != null && verification.notes!.isNotEmpty) ...[
            8.heightBox,
            Text(
              verification.notes!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.kTextPrimaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

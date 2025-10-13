import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_cached_network_image.dart';

import '../scan_gatepass_screen/gatepass_info_row.dart';
import '../scan_gatepass_screen/gatepass_section_title.dart';

class GatePassDriverInfoCard extends StatelessWidget {
  final dynamic driver;

  const GatePassDriverInfoCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Driver Information'),
        16.heightBox,
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.kSurfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.kShadowLightColor,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Driver Image
              CustomCachedNetworkImage(
                imageUrl: driver.photoUrl,
                width: 100,
                height: 100,
                borderRadius: BorderRadius.circular(50),
                borderColor: AppColors.kBorderColor,
                borderWidth: 2,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kShadowLightColor,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                errorWidget: Icon(
                  Iconsax.user,
                  size: 40,
                  color: AppColors.kTextSecondaryColor,
                ),
              ),
              20.heightBox,
              // Driver Information
              GatePassInfoRow(label: 'Name:', value: driver.name),
              12.heightBox,
              GatePassInfoRow(label: 'License:', value: driver.licenseNumber),
              12.heightBox,
              GatePassInfoRow(label: 'Phone:', value: driver.phone),
            ],
          ),
        ),
      ],
    );
  }
}

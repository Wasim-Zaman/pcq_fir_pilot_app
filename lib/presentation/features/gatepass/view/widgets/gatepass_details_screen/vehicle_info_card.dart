import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_cached_network_image.dart';

import '../scan_gatepass_screen/gatepass_info_row.dart';
import '../scan_gatepass_screen/gatepass_section_title.dart';

class GatePassVehicleInfoCard extends StatelessWidget {
  final Vehicle vehicle;

  const GatePassVehicleInfoCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GatePassSectionTitle(title: 'Vehicle Information'),
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
              // Vehicle Image
              CustomCachedNetworkImage(
                imageUrl: vehicle.imageUrl,
                width: double.infinity,
                height: 150,
                borderRadius: BorderRadius.circular(12),
                borderColor: AppColors.kBorderColor,
                borderWidth: 2,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kShadowLightColor,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                errorWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.car,
                      size: 48,
                      color: AppColors.kTextSecondaryColor,
                    ),
                    8.heightBox,
                    Text(
                      'Vehicle Image',
                      style: TextStyle(
                        color: AppColors.kTextSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              20.heightBox,
              // Vehicle Information
              GatePassInfoRow(
                label: 'Plate Number:',
                value: vehicle.plateNumber,
              ),
              12.heightBox,
              GatePassInfoRow(label: 'Type:', value: vehicle.vehicleType),
              12.heightBox,
              GatePassInfoRow(label: 'Make:', value: vehicle.make),
              12.heightBox,
              GatePassInfoRow(label: 'Color:', value: vehicle.color),
              12.heightBox,
              GatePassInfoRow(label: 'Owner:', value: vehicle.ownerCompany),
            ],
          ),
        ),
      ],
    );
  }
}

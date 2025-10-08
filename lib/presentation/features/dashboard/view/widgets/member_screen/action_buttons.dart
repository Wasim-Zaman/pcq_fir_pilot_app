import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';

/// Action buttons widget for profile actions
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Edit Profile Button (placeholder)
        CustomButton(
          text: "Edit Profile",
          icon: Icon(Iconsax.edit),
          width: double.infinity,
          onPressed: () {
            CustomSnackbar.showNormal(context, 'Edit profile coming soon!');
          },
        ),

        12.heightBox,
        // Change Password Button (placeholder)
        CustomOutlinedButton(
          text: "Change Password",
          icon: Icon(Iconsax.lock),
          width: double.infinity,
          onPressed: () {
            CustomSnackbar.showNormal(context, 'Change password coming soon!');
          },
        ),
      ],
    );
  }
}

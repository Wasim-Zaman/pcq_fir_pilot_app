import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/signin_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import 'widgets/member_screen/dashboard_screen_widgets.dart';

/// Member Details Screen showing user profile information
class MemberDetailsScreen extends ConsumerWidget {
  const MemberDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);

    return signInState.when(
      data: (state) {
        final member = state.member;

        if (member == null) {
          return CustomScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Iconsax.user,
                    size: 64,
                    color: AppColors.kTextSecondaryColor,
                  ),
                  16.heightBox,
                  const Text(
                    'No user data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.kTextSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.logout),
                onPressed: () => _handleLogout(context, ref),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                ProfileHeader(member: member),
                24.heightBox,

                // Personal Information Section
                const SectionTitle(title: 'Personal Information'),
                12.heightBox,
                InfoCard(
                  children: [
                    InfoRow(
                      icon: Iconsax.user,
                      label: 'Full Name',
                      value: member.fullName,
                    ),
                    InfoRow(
                      icon: Iconsax.sms,
                      label: 'Email',
                      value: member.email,
                    ),
                    InfoRow(
                      icon: Iconsax.call,
                      label: 'Mobile',
                      value: member.mobile,
                    ),
                  ],
                ),
                24.heightBox,

                // Work Information Section
                const SectionTitle(title: 'Work Information'),
                12.heightBox,
                InfoCard(
                  children: [
                    InfoRow(
                      icon: Iconsax.building,
                      label: 'Department',
                      value: member.department,
                    ),
                    InfoRow(
                      icon: Iconsax.card,
                      label: 'Employee Code',
                      value: member.employeeCode,
                    ),
                    InfoRow(
                      icon: Iconsax.shield_tick,
                      label: 'Role',
                      value: member.role,
                      valueColor: _getRoleColor(member.role),
                    ),
                    InfoRow(
                      icon: Iconsax.status,
                      label: 'Status',
                      value: member.status.toUpperCase(),
                      valueColor: member.isActive
                          ? AppColors.kSuccessColor
                          : AppColors.kErrorColor,
                    ),
                  ],
                ),
                24.heightBox,

                // Account Details Section
                const SectionTitle(title: 'Account Details'),
                12.heightBox,
                InfoCard(
                  children: [
                    InfoRow(
                      icon: Iconsax.calendar,
                      label: 'Created At',
                      value: _formatDate(member.createdAt),
                    ),
                    InfoRow(
                      icon: Iconsax.refresh,
                      label: 'Last Updated',
                      value: _formatDate(member.updatedAt),
                    ),
                    InfoRow(
                      icon: Iconsax.finger_scan,
                      label: 'Member ID',
                      value: member.id,
                      valueStyle: const TextStyle(
                        fontSize: 12,
                        color: AppColors.kTextSecondaryColor,
                      ),
                    ),
                  ],
                ),
                24.heightBox,

                // Action Buttons
                const ActionButtons(),
                32.heightBox,
              ],
            ),
          ),
        );
      },
      loading: () => CustomScaffold(
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => CustomScaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.info_circle,
                size: 64,
                color: AppColors.kErrorColor,
              ),
              16.heightBox,
              Text(
                'Error loading profile',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.kTextSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return AppColors.kErrorColor;
      case 'SECURITY':
        return AppColors.kInfoColor;
      default:
        return AppColors.kTextPrimaryColor;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kErrorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(signInProvider.notifier).signOut();
      if (context.mounted) {
        context.go(kSigninRoute);
      }
    }
  }
}

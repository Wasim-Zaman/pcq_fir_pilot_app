import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/providers/dashboard_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';

/// Dashboard screen displaying user statistics and quick actions
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data on screen load
    Future.microtask(
      () => ref.read(dashboardProvider.notifier).refreshDashboard(),
    );
  }

  Future<void> _handleRefresh() async {
    await ref.read(dashboardProvider.notifier).refreshDashboard();
  }

  void _handleScanQRCode() {
    // TODO: Navigate to QR code scanner
    CustomSnackbar.showNormal(context, 'QR Code scanner coming soon!');
  }

  void _handleNotifications() {
    // TODO: Navigate to notifications screen
    CustomSnackbar.showNormal(context, 'Notifications coming soon!');
  }

  void _handleProfile() {
    // TODO: Navigate to profile screen
    CustomSnackbar.showNormal(context, 'Profile screen coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: dashboardState.when(
            data: (state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                return Center(
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
                        'Error loading dashboard',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.heightBox,
                      Text(
                        state.error!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kTextSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      24.heightBox,
                      CustomButton(
                        text: 'Retry',
                        onPressed: _handleRefresh,
                        icon: const Icon(Iconsax.refresh),
                        width: 200,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeader(),

                      32.heightBox,

                      // Today's Scans Card
                      _buildStatCard(
                        title: 'Today\'s Scans',
                        value: state.stats?.todayScans.toString() ?? '0',
                        subtitle: 'documents verified',
                        icon: Iconsax.document,
                        color: AppColors.kPrimaryColor,
                      ),

                      16.heightBox,

                      // Pending Verifications Card
                      _buildStatCard(
                        title: 'Pending Verifications',
                        value:
                            state.stats?.pendingVerifications.toString() ?? '0',
                        subtitle: 'documents in progress',
                        icon: Iconsax.clock,
                        color: AppColors.kWarningColor,
                      ),

                      32.heightBox,

                      // Scan QR Code Button
                      CustomButton(
                        text: 'Scan QR Code',
                        onPressed: _handleScanQRCode,
                        icon: const Icon(Iconsax.scan_barcode),
                        useGradient: true,
                      ),

                      16.heightBox,
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
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
                    'Failed to load dashboard',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.heightBox,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.kTextSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  24.heightBox,
                  CustomButton(
                    text: 'Retry',
                    onPressed: _handleRefresh,
                    icon: const Icon(Iconsax.refresh),
                    width: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section with title and action buttons
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kSurfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.kShadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dashboard Title
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.kTextPrimaryColor,
            ),
          ),

          // Action Buttons
          Row(
            children: [
              // Notifications Button
              _buildIconButton(
                icon: Iconsax.notification,
                onTap: _handleNotifications,
              ),

              12.widthBox,

              // Profile Button
              _buildIconButton(icon: Iconsax.user, onTap: _handleProfile),
            ],
          ),
        ],
      ),
    );
  }

  /// Build icon button for header actions
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.kBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.kTextPrimaryColor),
      ),
    );
  }

  /// Build statistics card
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.kShadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              12.widthBox,
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextPrimaryColor,
                  ),
                ),
              ),
            ],
          ),

          16.heightBox,

          // Value
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          4.heightBox,

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.kTextSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

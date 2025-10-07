import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/providers/dashboard_provider.dart';

import 'widgets/dashboard_content.dart';
import 'widgets/dashboard_error_view.dart';

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
    // Navigate to QR code scanner
    context.push(kScanQrCodeRoute);
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
                return DashboardErrorView(
                  errorMessage: state.error!,
                  onRetry: _handleRefresh,
                );
              }

              return DashboardContent(
                state: state,
                onScanQRCode: _handleScanQRCode,
                onNotifications: _handleNotifications,
                onProfile: _handleProfile,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => DashboardErrorView(
              title: 'Failed to load dashboard',
              errorMessage: error.toString(),
              onRetry: _handleRefresh,
            ),
          ),
        ),
      ),
    );
  }
}

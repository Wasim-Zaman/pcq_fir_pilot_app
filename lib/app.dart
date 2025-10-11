import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_themes.dart';
import 'package:pcq_fir_pilot_app/presentation/features/connectivity/providers/connectivity_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/connectivity/view/no_internet_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import 'core/router/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PCQ FIR Pilot App',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(goRouterProvider),
      builder: (context, child) {
        // Wrap the entire app with connectivity monitoring
        return ConnectivityWrapper(child: child);
      },
    );
  }
}

/// Wrapper that monitors connectivity and shows no internet screen
/// as an overlay on top of the entire app
class ConnectivityWrapper extends ConsumerWidget {
  final Widget? child;

  const ConnectivityWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    return connectivityStatus.when(
      data: (status) {
        if (kDebugMode) {
          print('🔄 ConnectivityWrapper status: $status');
        }

        // Always maintain the same widget tree structure using Stack
        // This ensures the child widget's state is preserved
        return Stack(
          children: [
            // Always show the child widget (preserves its state)
            if (child != null) child!,
            // Conditionally overlay the no internet screen
            if (status == ConnectivityStatus.disconnected)
              Positioned.fill(child: const NoInternetScreen()),
          ],
        );
      },
      loading: () {
        if (kDebugMode) {
          print('⏳ ConnectivityWrapper loading...');
        }
        return CustomScaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Checking connectivity...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        if (kDebugMode) {
          print('⚠️ ConnectivityWrapper error: $error');
        }
        return CustomScaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.kErrorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error checking connectivity',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.kErrorColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    onPressed: () {
                      // Refresh the connectivity provider
                      ref.invalidate(connectivityStatusProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    text: 'Retry',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/router/app_router.dart';
import 'package:pcq_fir_pilot_app/presentation/features/no_internet/providers/connectivity_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/no_internet/view/no_internet_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PCQ FIR Pilot App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
        // Use a Stack to overlay no internet screen when disconnected
        if (status == ConnectivityStatus.disconnected) {
          return Stack(
            children: [
              // Keep the original app in background
              if (child != null) child!,
              // Overlay the no internet screen
              const Positioned.fill(child: NoInternetScreen()),
            ],
          );
        }
        // Show the normal app when connected
        return child ?? const SizedBox.shrink();
      },
      loading: () => Scaffold(
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
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error checking connectivity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
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
                ElevatedButton.icon(
                  onPressed: () {
                    // Refresh the connectivity provider
                    ref.invalidate(connectivityStatusProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

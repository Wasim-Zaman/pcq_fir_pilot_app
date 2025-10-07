import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/view/signin_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/view/dashboard_screen.dart';

import 'app_routes.dart';

var navigatorKey = GlobalKey<NavigatorState>();

/// GoRouter provider for app navigation
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: kSigninRoute,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: [
      // Auth Routes
      GoRoute(
        path: kSigninRoute,
        name: kSigninRouteName,
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const SignInScreen());
        },
      ),

      // Dashboard Route
      GoRoute(
        path: kDashboardRoute,
        name: 'dashboard',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const DashboardScreen(),
          );
        },
      ),

      // Add more routes as needed
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(kSigninRoute),
              child: const Text('Go to Sign In'),
            ),
          ],
        ),
      ),
    ),
  );
});

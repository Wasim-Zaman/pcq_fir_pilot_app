import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/main.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/view/signin_screen.dart';

import '../../presentation/features/no_internet/view/no_internet_screen.dart';
import 'app_routes.dart';

/// GoRouter provider for app navigation
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: kInitialRoute,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: kInitialRoute,
        name: kInitialRouteName,
        builder: (context, state) => const ConnectivityWrapper(),
        routes: [
          // Auth Routes
          GoRoute(
            path: kSigninRoute,
            name: kSigninRouteName,
            pageBuilder: (context, state) {
              // Replace with actual SignInScreen
              return MaterialPage(
                key: state.pageKey,
                child: const SignInScreen(),
              );
            },
          ),

          // Utility Routes
          GoRoute(
            path: kNoInternetRoute,
            name: 'no-internet',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const NoInternetScreen(),
            ),
          ),

          // Add more routes as needed
        ],
      ),
    ],
    redirect: (context, state) {
      return null;
    },
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

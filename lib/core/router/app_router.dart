import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/view/signin_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/view/dashboard_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/view/member_details_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/gatepass_details_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/scan_gatepass_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

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
      // Member Details Route
      GoRoute(
        path: kMemberDetailsRoute,
        name: kMemberDetailsRouteName,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const MemberDetailsScreen(),
          );
        },
      ),

      // Scan Barcode Route
      GoRoute(
        path: kScanGatepassRoute,
        name: kScanGatepassRouteName,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const ScanGatepassScreen(),
          );
        },
      ),

      // Gate Pass Details Route
      GoRoute(
        path: kGatePassDetailsRoute,
        name: 'gate-pass-details',
        pageBuilder: (context, state) {
          final passNumber = state.extra as String;
          return MaterialPage(
            key: state.pageKey,
            child: GatePassDetailsScreen(passNumber: passNumber),
          );
        },
      ),

      // Add more routes as needed
    ],
    errorBuilder: (context, state) => CustomScaffold(
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
            CustomButton(text: "Go Back", onPressed: () => context.pop()),
            12.heightBox,
            CustomOutlinedButton(
              text: "Go to Sign In",
              onPressed: () => context.go(kSigninRoute),
            ),
          ],
        ),
      ),
    ),
  );
});

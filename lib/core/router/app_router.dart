import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/view/signin_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/view/dashboard_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/view/member_details_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/gatepass_models.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/gatepass_details_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/gatepass_item_verification_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/gatepass_scan_items_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/gatepass_verification_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/view/scan_gatepass_screen.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';
import 'package:pcq_fir_pilot_app/services/shared_preferences_service.dart';

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
        name: kGatePassDetailsRouteName,
        pageBuilder: (context, state) {
          final passNumber = state.extra as String;
          return MaterialPage(
            key: state.pageKey,
            child: GatePassDetailsScreen(passNumber: passNumber),
          );
        },
      ),

      // Item Verification Route
      GoRoute(
        path: kGatePassScanItemRoute,
        name: kGatePassScanItemRouteName,
        pageBuilder: (context, state) {
          final gatePass = state.extra as GatePass;
          return MaterialPage(
            key: state.pageKey,
            child: GatePassScanItemsScreen(gatePass: gatePass),
          );
        },
      ),

      // Gate Pass Verification Route
      GoRoute(
        path: kGatePassVerificationRoute,
        name: kGatePassVerificationRouteName,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final gatePass = extra['gatePass'] as GatePass;

          return MaterialPage(
            key: state.pageKey,
            child: GatePassVerificationScreen(gatePass: gatePass),
          );
        },
      ),

      // Gate Pass Item Verification Route
      GoRoute(
        path: kGatePassItemVerificationRoute,
        name: kGatePassItemVerificationRouteName,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final gatePass = extra['gatePass'] as GatePass;
          final item = extra['item'] as VerifiedItem;
          return MaterialPage(
            key: state.pageKey,
            child: GatePassItemVerificationScreen(
              gatePass: gatePass,
              item: item,
            ),
          );
        },
      ),

      // Add more routes as needed
    ],
    redirect: (context, state) {
      //if not signed in, go to sign-in page
      final isLoggedIn = ref
          .read(sharedPreferencesServiceProvider)
          .isLoggedIn();
      final goingToSignIn = state.matchedLocation == kSigninRoute;

      if (!isLoggedIn && !goingToSignIn) {
        return kSigninRoute;
      } else if (isLoggedIn && goingToSignIn) {
        return kDashboardRoute;
      }
      return null; // No redirect
    },
    errorBuilder: (context, state) => CustomScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Iconsax.warning_2,
              size: 64,
              color: AppColors.kErrorColor,
            ),
            16.heightBox,
            Text(
              'Page not found: ${state.uri.path}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            16.heightBox,
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

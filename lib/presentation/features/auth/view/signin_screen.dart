import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/core/router/app_routes.dart';
import 'package:pcq_fir_pilot_app/core/utils/custom_snackbar.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/signin_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/validation_provider.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_button_widget.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_text_field.dart';

/// Sign-in screen that allows users to authenticate using username and password
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      // Call signin provider
      await ref
          .read(signInProvider.notifier)
          .signIn(
            username: _usernameController.text,
            password: _passwordController.text,
          );

      // Check for success and navigate to dashboard
      final signInState = ref.read(signInProvider);
      signInState.whenData((state) {
        if (mounted && state.isAuthenticated) {
          // Navigate to dashboard
          context.go(kDashboardRoute);

          // Show success message
          CustomSnackbar.showNormal(context, 'Sign in successful!');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final signInState = ref.watch(signInProvider);
    final validation = ref.read(validationProvider.notifier);

    // Get loading state from the provider
    final isLoading = signInState.isLoading;

    return CustomScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // QR Code Icon
                  if (!keyboardVisible) ...[
                    Icon(
                      Icons.qr_code_scanner,
                      size: 120,
                      color: AppColors.kPrimaryColor,
                    ),

                    32.heightBox,
                  ],

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kTextPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  8.heightBox,

                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.kTextSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  48.heightBox,

                  // Username Field
                  CustomTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.kIconSecondaryColor,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: validation.validateUsername,
                    enabled: !isLoading,
                  ),

                  16.heightBox,

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.kIconSecondaryColor,
                    ),
                    obscureText: true,
                    showPasswordToggle: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: validation.validatePassword,
                    enabled: !isLoading,
                    onSaved: (_) => _handleSignIn(),
                  ),

                  24.heightBox,

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // TODO: Navigate to forgot password screen
                              CustomSnackbar.showNormal(
                                context,
                                'Forgot password feature coming soon!',
                              );
                            },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  24.heightBox,

                  // Sign In Button
                  CustomButton(
                    text: 'Sign In',
                    onPressed: isLoading ? null : _handleSignIn,
                    isLoading: isLoading,
                    useGradient: true,
                    icon: const Icon(Iconsax.barcode),
                  ),

                  32.heightBox,

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: AppColors.kTextSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                // TODO: Navigate to sign up screen
                                CustomSnackbar.showNormal(
                                  context,
                                  'Sign up feature coming soon!',
                                );
                              },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.kPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

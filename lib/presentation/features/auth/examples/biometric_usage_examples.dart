// Example: How to use biometric authentication in other screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/presentation/features/auth/provider/biometric_provider.dart';
import 'package:pcq_fir_pilot_app/services/biometric_service.dart';

/// Example 1: Check if biometric is available before showing feature
class BiometricCheckExample extends ConsumerWidget {
  const BiometricCheckExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricState = ref.watch(biometricProvider);

    return biometricState.when(
      data: (state) {
        if (!state.isAvailable) {
          return const Text('Biometric authentication not available');
        }

        return ElevatedButton(
          onPressed: () => _authenticate(ref),
          child: const Text('Authenticate with Biometric'),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Error checking biometric availability'),
    );
  }

  Future<void> _authenticate(WidgetRef ref) async {
    final credentials = await ref
        .read(biometricProvider.notifier)
        .authenticateAndGetCredentials();

    if (credentials != null) {
      // Authentication successful, credentials retrieved
      print('Email: ${credentials.email}');
      // Use credentials...
    }
  }
}

/// Example 2: Direct biometric authentication without provider
class DirectBiometricExample extends StatelessWidget {
  const DirectBiometricExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _authenticateDirectly,
      child: const Text('Authenticate Directly'),
    );
  }

  Future<void> _authenticateDirectly() async {
    final biometricService = BiometricService();

    // Check availability first
    final isAvailable = await biometricService.isBiometricsAvailable();
    if (!isAvailable) {
      print('Biometric not available');
      return;
    }

    // Authenticate
    final result = await biometricService.authenticateWithBiometrics(
      localizedReason: 'Please authenticate to continue',
    );

    if (result.isSuccess) {
      print('Authentication successful');
      // Perform secure action...
    } else {
      print('Authentication failed: ${result.message}');
    }
  }
}

/// Example 3: Enable biometric in settings screen
class BiometricSettingsExample extends ConsumerWidget {
  const BiometricSettingsExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricState = ref.watch(biometricProvider);

    return biometricState.when(
      data: (state) {
        return SwitchListTile(
          title: const Text('Biometric Login'),
          subtitle: Text(
            state.isEnabled
                ? 'Enabled - Use fingerprint to sign in'
                : 'Enable quick sign in with fingerprint',
          ),
          value: state.isEnabled,
          onChanged: state.isAvailable
              ? (value) => _toggleBiometric(context, ref, value)
              : null,
          secondary: const Icon(Icons.fingerprint),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const ListTile(
        title: Text('Biometric Settings'),
        subtitle: Text('Error loading biometric settings'),
      ),
    );
  }

  Future<void> _toggleBiometric(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    if (value) {
      // Enable - requires email and password
      // In real scenario, get these from current user session
      const email = 'user@example.com';
      const password = 'password123';

      final success = await ref
          .read(biometricProvider.notifier)
          .enableBiometric(email: email, password: password);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Biometric login enabled'
                  : 'Failed to enable biometric login',
            ),
          ),
        );
      }
    } else {
      // Disable
      await ref.read(biometricProvider.notifier).disableBiometric();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric login disabled')),
        );
      }
    }
  }
}

/// Example 4: Check available biometric types
class BiometricTypesExample extends ConsumerWidget {
  const BiometricTypesExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricState = ref.watch(biometricProvider);

    return biometricState.when(
      data: (state) {
        return Column(
          children: [
            Text('Available Biometric Types:'),
            ...state.availableTypes.map((type) => Text('- ${type.name}')),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Error loading biometric types'),
    );
  }
}

/// Example 5: Authenticate with fallback to device credentials
class BiometricWithFallbackExample extends StatelessWidget {
  const BiometricWithFallbackExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _authenticateWithFallback,
      child: const Text('Authenticate (Biometric or PIN)'),
    );
  }

  Future<void> _authenticateWithFallback() async {
    final biometricService = BiometricService();

    // Authenticate with fallback to device PIN/Pattern
    final result = await biometricService
        .authenticateWithBiometricsOrCredentials(
          localizedReason: 'Authenticate to access secure content',
        );

    if (result.isSuccess) {
      print('Authentication successful');
    } else {
      print('Authentication failed: ${result.message}');
    }
  }
}

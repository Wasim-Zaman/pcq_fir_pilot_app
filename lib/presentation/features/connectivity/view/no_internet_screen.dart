import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';
import 'package:pcq_fir_pilot_app/core/extensions/sizedbox_extension.dart';
import 'package:pcq_fir_pilot_app/presentation/widgets/custom_scaffold.dart';

import '../providers/connectivity_provider.dart';

class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    return CustomScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // No internet icon
                Icon(
                  Icons.wifi_off_rounded,
                  size: 80,
                  color: AppColors.kErrorColor,
                ),

                24.heightBox,

                // Title
                Text(
                  'No Internet Connection',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kErrorColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                16.heightBox,

                // Description
                Text(
                  'Please check your internet connection and try again.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.kErrorColor),
                  textAlign: TextAlign.center,
                ),

                32.heightBox,

                // Connection status indicator
                connectivityStatus.when(
                  data: (status) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: status == ConnectivityStatus.connected
                            ? AppColors.kSuccessColor.withValues(alpha: 0.1)
                            : status == ConnectivityStatus.checking
                            ? AppColors.kWarningColor.withValues(alpha: 0.1)
                            : AppColors.kErrorColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: status == ConnectivityStatus.connected
                              ? AppColors.kSuccessColor
                              : status == ConnectivityStatus.checking
                              ? AppColors.kWarningColor
                              : AppColors.kErrorColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            status == ConnectivityStatus.connected
                                ? Icons.wifi_rounded
                                : status == ConnectivityStatus.checking
                                ? Icons.wifi_find_rounded
                                : Icons.wifi_off_rounded,
                            size: 16,
                            color: status == ConnectivityStatus.connected
                                ? AppColors.kSuccessColor
                                : status == ConnectivityStatus.checking
                                ? AppColors.kWarningColor
                                : AppColors.kErrorColor,
                          ),
                          8.widthBox,
                          Text(
                            status == ConnectivityStatus.connected
                                ? 'Connected'
                                : status == ConnectivityStatus.checking
                                ? 'Checking...'
                                : 'Disconnected',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: status == ConnectivityStatus.connected
                                  ? AppColors.kSuccessColor
                                  : status == ConnectivityStatus.checking
                                  ? AppColors.kWarningColor
                                  : AppColors.kErrorColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text(
                    'Error checking connectivity',
                    style: TextStyle(color: AppColors.kErrorColor),
                  ),
                ),

                24.heightBox,

                // Retry instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.kBorderColor),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.kIconSecondaryColor,
                        size: 20,
                      ),
                      8.heightBox,
                      Text(
                        'The app will automatically reconnect when internet is available.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          // color: AppColors.kTextSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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

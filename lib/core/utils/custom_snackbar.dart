import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Custom snackbar widget that matches the app's design
/// Handles different types: normal (info), warning, and error
class CustomSnackbar {
  CustomSnackbar._(); // Private constructor

  /// Shows a normal (info) snackbar
  static void showNormal(BuildContext context, String message) {
    _showSnackbar(context, message, CustomSnackbarType.normal);
  }

  /// Shows a warning snackbar
  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, CustomSnackbarType.warning);
  }

  /// Shows an error snackbar
  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, CustomSnackbarType.error);
  }

  static void _showSnackbar(
    BuildContext context,
    String message,
    CustomSnackbarType type,
  ) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(_getIcon(type), color: AppColors.kBackgroundColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.kBackgroundColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getBackgroundColor(type),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      action: type == CustomSnackbarType.error
          ? SnackBarAction(
              label: 'Dismiss',
              textColor: AppColors.kBackgroundColor,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static IconData _getIcon(CustomSnackbarType type) {
    switch (type) {
      case CustomSnackbarType.normal:
        return Icons.info_outline;
      case CustomSnackbarType.warning:
        return Icons.warning_amber_outlined;
      case CustomSnackbarType.error:
        return Icons.error_outline;
    }
  }

  static Color _getBackgroundColor(CustomSnackbarType type) {
    switch (type) {
      case CustomSnackbarType.normal:
        return AppColors.kInfoColor;
      case CustomSnackbarType.warning:
        return AppColors.kWarningColor;
      case CustomSnackbarType.error:
        return AppColors.kErrorColor;
    }
  }
}

enum CustomSnackbarType { normal, warning, error }

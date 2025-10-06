import 'package:flutter/material.dart';

/// App color constants following Dart naming conventions
/// Using k prefix for constant values as per Flutter/Dart best practices
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color kPrimaryColor = Color(0xFF2563EB); // Blue
  static const Color kPrimaryLightColor = Color(0xFF60A5FA);
  static const Color kPrimaryDarkColor = Color(0xFF1E40AF);

  // Secondary Colors
  static const Color kSecondaryColor = Color(0xFF10B981); // Green
  static const Color kSecondaryLightColor = Color(0xFF34D399);
  static const Color kSecondaryDarkColor = Color(0xFF059669);

  // Background Colors
  static const Color kBackgroundColor = Color(0xFFF9FAFB);
  static const Color kSurfaceColor = Color(0xFFFFFFFF);
  static const Color kCardColor = Color(0xFFFFFFFF);

  // Text Colors
  static const Color kTextPrimaryColor = Color(0xFF111827);
  static const Color kTextSecondaryColor = Color(0xFF6B7280);
  static const Color kTextTertiaryColor = Color(0xFF9CA3AF);
  static const Color kTextOnPrimaryColor = Color(0xFFFFFFFF);

  // Status Colors
  static const Color kSuccessColor = Color(0xFF10B981);
  static const Color kErrorColor = Color(0xFFEF4444);
  static const Color kWarningColor = Color(0xFFF59E0B);
  static const Color kInfoColor = Color(0xFF3B82F6);

  // Border Colors
  static const Color kBorderColor = Color(0xFFE5E7EB);
  static const Color kBorderLightColor = Color(0xFFF3F4F6);
  static const Color kDividerColor = Color(0xFFE5E7EB);

  // Icon Colors
  static const Color kIconPrimaryColor = Color(0xFF2563EB);
  static const Color kIconSecondaryColor = Color(0xFF6B7280);
  static const Color kIconOnPrimaryColor = Color(0xFFFFFFFF);

  // Shadow Colors
  static const Color kShadowColor = Color(0x1A000000);
  static const Color kShadowLightColor = Color(0x0D000000);

  // Overlay Colors
  static const Color kOverlayColor = Color(0x80000000);
  static const Color kOverlayLightColor = Color(0x40000000);

  // Special Colors
  static const Color kDisabledColor = Color(0xFFD1D5DB);
  static const Color kDisabledTextColor = Color(0xFF9CA3AF);
  static const Color kHighlightColor = Color(0xFFEFF6FF);
  static const Color kHoverColor = Color(0xFFF3F4F6);

  // Gradient Colors
  static const LinearGradient kPrimaryGradient = LinearGradient(
    colors: [kPrimaryColor, kPrimaryDarkColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kSuccessGradient = LinearGradient(
    colors: [kSuccessColor, kSecondaryDarkColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

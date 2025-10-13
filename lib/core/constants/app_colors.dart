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
  static const Color kPurpleColor = Color(0xFF9C27B0);
  static const Color kGreyColor = Color(0xFF9E9E9E);
  static const Color kOrangeColor = Color(0xFFFF9800);
  static const Color kBlueGreyColor = Color(0xFF607D8B);
  static const Color kGrey200Color = Color(0xFFEEEEEE);
  static const Color kGrey300Color = Color(0xFFE0E0E0);
  static const Color kGrey600Color = Color(0xFF757575);
  static const Color kBlack87Color = Color(0xffdd000000);

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

  // Dark Theme Colors
  static const Color kDarkBackgroundColor = Color(0xFF111827);
  static const Color kDarkSurfaceColor = Color(0xFF1F2937);
  static const Color kDarkTextPrimaryColor = Color(0xFFF9FAFB);
  static const Color kDarkTextSecondaryColor = Color(0xFFD1D5DB);
  static const Color kDarkTextTertiaryColor = Color(0xFF6B7280);
  static const Color kDarkBorderColor = Color(0xFF374151);
  static const Color kDarkBorderLightColor = Color(0xFF4B5563);
  static const Color kDarkShadowColor = Color(0x40000000);
  static const Color kDarkPrimaryColor = Color(0xFF60A5FA);
  static const Color kDarkPrimaryDarkColor = Color(0xFF1E40AF);
}

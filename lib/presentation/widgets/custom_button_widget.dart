import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';

/// A custom button widget using FilledButton with consistent styling
/// Provides different button styles and states for the app
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool useGradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool effectivelyDisabled =
        isDisabled || isLoading || onPressed == null;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.kTextOnPrimaryColor,
              ),
            ),
          )
        else ...[
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: foregroundColor ?? AppColors.kTextOnPrimaryColor,
            ),
          ),
        ],
      ],
    );

    Widget button = FilledButton(
      onPressed: effectivelyDisabled ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: effectivelyDisabled
            ? AppColors.kDisabledColor
            : (backgroundColor ?? AppColors.kPrimaryColor),
        foregroundColor: effectivelyDisabled
            ? AppColors.kDisabledTextColor
            : (foregroundColor ?? AppColors.kTextOnPrimaryColor),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: effectivelyDisabled ? 0 : 2,
        shadowColor: AppColors.kShadowColor,
        minimumSize: Size(width ?? double.infinity, height ?? 52),
      ),
      child: buttonChild,
    );

    // Wrap with gradient container if useGradient is true
    if (useGradient && !effectivelyDisabled) {
      return Container(
        width: width,
        height: height ?? 52,
        decoration: BoxDecoration(
          gradient: AppColors.kPrimaryGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.kShadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: foregroundColor ?? AppColors.kTextOnPrimaryColor,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: buttonChild,
        ),
      );
    }

    return SizedBox(width: width, height: height, child: button);
  }
}

/// A secondary variant of the custom button with outlined style
class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.borderColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final bool effectivelyDisabled =
        isDisabled || isLoading || onPressed == null;

    return SizedBox(
      width: width,
      height: height ?? 52,
      child: OutlinedButton(
        onPressed: effectivelyDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectivelyDisabled
              ? AppColors.kDisabledTextColor
              : (foregroundColor ?? AppColors.kPrimaryColor),
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(
            color: effectivelyDisabled
                ? AppColors.kDisabledColor
                : (borderColor ?? AppColors.kPrimaryColor),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? AppColors.kPrimaryColor,
                  ),
                ),
              )
            else ...[
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor ?? AppColors.kPrimaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

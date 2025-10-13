import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pcq_fir_pilot_app/core/constants/app_colors.dart';

/// A custom cached network image widget with loading and error states
class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.placeholderWidget,
    this.errorWidget,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!.startsWith('http')
                    ? imageUrl!
                    : 'https://pcq.gstsa1.org$imageUrl',
                fit: fit,
                placeholder: (context, url) => Container(
                  color: backgroundColor ?? AppColors.kBackgroundColor,
                  child: Center(
                    child:
                        placeholderWidget ??
                        const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.kPrimaryColor,
                          ),
                        ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: backgroundColor ?? AppColors.kBackgroundColor,
                  child:
                      errorWidget ??
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.kTextSecondaryColor,
                      ),
                ),
              )
            : Container(
                color: backgroundColor ?? AppColors.kBackgroundColor,
                child:
                    errorWidget ??
                    const Icon(
                      Icons.image_not_supported,
                      color: AppColors.kTextSecondaryColor,
                    ),
              ),
      ),
    );
  }
}

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
            ? Image.network(
                'https://pcq.gstsa1.org/api$imageUrl',
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: backgroundColor ?? AppColors.kBackgroundColor,
                    child:
                        errorWidget ??
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.kTextSecondaryColor,
                        ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: backgroundColor ?? AppColors.kBackgroundColor,
                    child: Center(
                      child:
                          placeholderWidget ??
                          CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.kPrimaryColor,
                            ),
                          ),
                    ),
                  );
                },
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

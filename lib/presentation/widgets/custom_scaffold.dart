import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';

/// Custom Scaffold Widget for consistent app-wide UI
/// Provides a reusable scaffold with customizable properties
class CustomScaffold extends StatelessWidget {
  /// The primary content of the scaffold
  final Widget body;

  /// App bar configuration
  final PreferredSizeWidget? appBar;

  /// Custom title for the app bar (used if appBar is null)
  final String? title;

  /// Show back button in app bar
  final bool showBackButton;

  /// Background color of the scaffold
  final Color? backgroundColor;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Position of the floating action button
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Bottom sheet
  final Widget? bottomSheet;

  /// Drawer widget
  final Widget? drawer;

  /// End drawer widget
  final Widget? endDrawer;

  /// Whether to resize body when keyboard appears
  final bool resizeToAvoidBottomInset;

  /// Whether the body should extend behind the app bar
  final bool extendBodyBehindAppBar;

  /// Whether the body should extend behind the bottom navigation bar
  final bool extendBody;

  /// Custom app bar actions
  final List<Widget>? actions;

  /// Leading widget for app bar
  final Widget? leading;

  /// Center title in app bar
  final bool centerTitle;

  /// Safe area configuration
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;

  /// System UI overlay style (status bar configuration)
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Padding for the body content
  final EdgeInsetsGeometry? padding;

  /// Enable scroll for body content
  final bool enableScroll;

  /// Custom scroll physics
  final ScrollPhysics? scrollPhysics;

  /// On back button pressed callback
  final VoidCallback? onBackPressed;

  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.title,
    this.showBackButton = false,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.systemOverlayStyle,
    this.padding,
    this.enableScroll = false,
    this.scrollPhysics,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // check if it is dartmode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          systemOverlayStyle ??
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
      child: Scaffold(
        backgroundColor:
            backgroundColor ??
            (isDarkMode
                ? AppColors.kDarkBackgroundColor
                : AppColors.kBackgroundColor),
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar ?? _buildDefaultAppBar(context),
        drawer: drawer,
        endDrawer: endDrawer,
        body: SafeArea(
          top: safeAreaTop,
          bottom: safeAreaBottom,
          left: safeAreaLeft,
          right: safeAreaRight,
          child: _buildBody(),
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
      ),
    );
  }

  /// Build the body with optional scroll and padding
  Widget _buildBody() {
    Widget content = body;

    // Add padding if specified
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Add scroll functionality if enabled
    if (enableScroll) {
      content = SingleChildScrollView(
        physics: scrollPhysics ?? const ClampingScrollPhysics(),
        child: content,
      );
    }

    return content;
  }

  /// Build default app bar if not provided
  PreferredSizeWidget? _buildDefaultAppBar(BuildContext context) {
    if (appBar != null) return appBar;
    if (title == null && !showBackButton) return null;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.kDarkTextPrimaryColor
                    : AppColors.kTextPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: centerTitle,
      backgroundColor: isDarkMode
          ? AppColors.kDarkSurfaceColor
          : AppColors.kSurfaceColor,
      surfaceTintColor: Colors.transparent,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDarkMode
              ? AppColors.kDarkBorderColor
              : AppColors.kBorderLightColor,
        ),
      ),
    );
  }

  /// Build back button
  Widget _buildBackButton(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: isDarkMode
            ? AppColors.kDarkTextPrimaryColor
            : AppColors.kTextPrimaryColor,
        size: 20,
      ),
      onPressed: () {
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

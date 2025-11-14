import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// Responsive layout widget that displays different layouts based on screen size
///
/// Automatically selects the appropriate layout based on device breakpoints:
/// - Mobile: < 600px
/// - Tablet: 600px - 1023px
/// - Desktop: >= 1024px
///
/// Example:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  /// Layout for mobile devices (< 600px)
  final Widget mobile;

  /// Optional layout for tablet devices (600px - 1023px)
  /// Falls back to mobile if not provided
  final Widget? tablet;

  /// Optional layout for desktop devices (>= 1024px)
  /// Falls back to tablet or mobile if not provided
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop layout (>= 1024px)
        if (constraints.maxWidth >= AppSizes.breakpointDesktop) {
          return desktop ?? tablet ?? mobile;
        }
        // Tablet layout (600px - 1023px)
        else if (constraints.maxWidth >= AppSizes.breakpointTablet) {
          return tablet ?? mobile;
        }
        // Mobile layout (< 600px)
        else {
          return mobile;
        }
      },
    );
  }
}

/// Responsive widget with orientation awareness
///
/// Allows different layouts for portrait and landscape orientations
/// in addition to device size breakpoints
///
/// Example:
/// ```dart
/// ResponsiveOrientationLayout(
///   mobilePortrait: MobilePortraitLayout(),
///   mobileLandscape: MobileLandscapeLayout(),
///   tabletPortrait: TabletPortraitLayout(),
///   tabletLandscape: TabletLandscapeLayout(),
/// )
/// ```
class ResponsiveOrientationLayout extends StatelessWidget {
  final Widget mobilePortrait;
  final Widget? mobileLandscape;
  final Widget? tabletPortrait;
  final Widget? tabletLandscape;
  final Widget? desktopPortrait;
  final Widget? desktopLandscape;

  const ResponsiveOrientationLayout({
    super.key,
    required this.mobilePortrait,
    this.mobileLandscape,
    this.tabletPortrait,
    this.tabletLandscape,
    this.desktopPortrait,
    this.desktopLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isPortrait = orientation == Orientation.portrait;
            final width = constraints.maxWidth;

            // Desktop
            if (width >= AppSizes.breakpointDesktop) {
              if (isPortrait) {
                return desktopPortrait ??
                    tabletPortrait ??
                    mobilePortrait;
              } else {
                return desktopLandscape ??
                    mobileLandscape ??
                    tabletLandscape ??
                    mobilePortrait;
              }
            }
            // Tablet
            else if (width >= AppSizes.breakpointTablet) {
              if (isPortrait) {
                return tabletPortrait ?? mobilePortrait;
              } else {
                return tabletLandscape ??
                    mobileLandscape ??
                    mobilePortrait;
              }
            }
            // Mobile
            else {
              if (isPortrait) {
                return mobilePortrait;
              } else {
                return mobileLandscape ?? mobilePortrait;
              }
            }
          },
        );
      },
    );
  }
}

/// Responsive centered container with max width constraints
///
/// Useful for creating centered content layouts that don't stretch
/// too wide on large screens
///
/// Example:
/// ```dart
/// ResponsiveCenteredContainer(
///   child: MyContent(),
/// )
/// ```
class ResponsiveCenteredContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidthMobile;
  final double? maxWidthTablet;
  final double? maxWidthDesktop;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenteredContainer({
    super.key,
    required this.child,
    this.maxWidthMobile,
    this.maxWidthTablet,
    this.maxWidthDesktop,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth;

        if (constraints.maxWidth >= AppSizes.breakpointDesktop) {
          maxWidth = maxWidthDesktop ?? 1200;
        } else if (constraints.maxWidth >= AppSizes.breakpointTablet) {
          maxWidth = maxWidthTablet ?? 768;
        } else {
          maxWidth = maxWidthMobile ?? double.infinity;
        }

        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: padding,
            child: child,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

/// Responsive builder widget that adapts layout based on screen size
///
/// Usage:
/// ```dart
/// ResponsiveBuilder(
///   mobile: MobileWidget(),
///   tablet: TabletWidget(),
///   desktop: DesktopWidget(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Widget for mobile layout (< 600dp)
  final Widget mobile;

  /// Widget for tablet layout (600dp - 1024dp)
  /// If not provided, uses mobile layout
  final Widget? tablet;

  /// Widget for desktop layout (> 1024dp)
  /// If not provided, uses tablet or mobile layout
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop layout
        if (constraints.maxWidth >= AppSizes.breakpointDesktop) {
          return desktop ?? tablet ?? mobile;
        }
        // Tablet layout
        else if (constraints.maxWidth >= AppSizes.breakpointTablet) {
          return tablet ?? mobile;
        }
        // Mobile layout
        else {
          return mobile;
        }
      },
    );
  }
}

/// Helper extension for responsive values
extension ResponsiveExtension on BuildContext {
  /// Returns true if screen width is mobile size
  bool get isMobile =>
      MediaQuery.of(this).size.width < AppSizes.breakpointTablet;

  /// Returns true if screen width is tablet size
  bool get isTablet =>
      MediaQuery.of(this).size.width >= AppSizes.breakpointTablet &&
      MediaQuery.of(this).size.width < AppSizes.breakpointDesktop;

  /// Returns true if screen width is desktop size
  bool get isDesktop =>
      MediaQuery.of(this).size.width >= AppSizes.breakpointDesktop;

  /// Returns the appropriate value based on screen size
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? mobilePadding;
  final EdgeInsetsGeometry? tabletPadding;
  final EdgeInsetsGeometry? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveValue(
      mobile: mobilePadding ?? EdgeInsets.all(AppSizes.paddingMD),
      tablet: tabletPadding,
      desktop: desktopPadding,
    );

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Responsive container with max width constraints
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;
  final double? desktopMaxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobileMaxWidth,
    this.tabletMaxWidth = 800,
    this.desktopMaxWidth = 1200,
    this.padding,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.responsiveValue<double?>(
      mobile: mobileMaxWidth,
      tablet: tabletMaxWidth,
      desktop: desktopMaxWidth,
    );

    return Align(
      alignment: alignment,
      child: Container(
        constraints:
            maxWidth != null ? BoxConstraints(maxWidth: maxWidth) : null,
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Device orientation helper
class OrientationBuilder extends StatelessWidget {
  final Widget portrait;
  final Widget? landscape;

  const OrientationBuilder({
    super.key,
    required this.portrait,
    this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        return isLandscape ? (landscape ?? portrait) : portrait;
      },
    );
  }
}

/// Responsive grid builder
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.responsiveValue(
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

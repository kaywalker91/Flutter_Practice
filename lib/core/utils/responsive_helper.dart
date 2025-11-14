import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive utility helper for device type detection and adaptive values
///
/// Provides helper functions for:
/// - Device type detection (phone, tablet, desktop)
/// - Responsive value calculations
/// - Layout breakpoint utilities
class ResponsiveHelper {
  ResponsiveHelper._(); // Private constructor to prevent instantiation

  /// Tablet breakpoint (Material Design standard)
  static const double _tabletBreakpoint = 600;

  /// Desktop breakpoint
  static const double _desktopBreakpoint = 1024;

  /// Large desktop breakpoint
  static const double _largeDesktopBreakpoint = 1440;

  // ============================================================
  // Device Type Detection
  // ============================================================

  /// Check if current device is a phone (shortest side < 600)
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide < _tabletBreakpoint;
  }

  /// Check if current device is a tablet (600 <= shortest side < 1024)
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= _tabletBreakpoint &&
        shortestSide < _desktopBreakpoint;
  }

  /// Check if current device is a desktop (shortest side >= 1024)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= _desktopBreakpoint;
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // ============================================================
  // Screen Dimensions
  // ============================================================

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get shortest side (useful for device type detection)
  static double shortestSide(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide;
  }

  /// Get longest side
  static double longestSide(BuildContext context) {
    return MediaQuery.of(context).size.longestSide;
  }

  // ============================================================
  // Adaptive Values
  // ============================================================

  /// Get value based on device type
  ///
  /// Example:
  /// ```dart
  /// final padding = ResponsiveHelper.valueByDevice(
  ///   context,
  ///   phone: 16.0,
  ///   tablet: 24.0,
  ///   desktop: 32.0,
  /// );
  /// ```
  static T valueByDevice<T>(
    BuildContext context, {
    required T phone,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? phone;
    } else if (isTablet(context)) {
      return tablet ?? phone;
    } else {
      return phone;
    }
  }

  /// Get value based on orientation
  ///
  /// Example:
  /// ```dart
  /// final columns = ResponsiveHelper.valueByOrientation(
  ///   context,
  ///   portrait: 2,
  ///   landscape: 3,
  /// );
  /// ```
  static T valueByOrientation<T>(
    BuildContext context, {
    required T portrait,
    required T landscape,
  }) {
    return isLandscape(context) ? landscape : portrait;
  }

  /// Get value based on screen width breakpoints
  ///
  /// Example:
  /// ```dart
  /// final fontSize = ResponsiveHelper.valueByWidth(
  ///   context,
  ///   sm: 12.0,
  ///   md: 14.0,
  ///   lg: 16.0,
  ///   xl: 18.0,
  /// );
  /// ```
  static T valueByWidth<T>(
    BuildContext context, {
    required T sm,
    T? md,
    T? lg,
    T? xl,
  }) {
    final width = screenWidth(context);

    if (width >= _largeDesktopBreakpoint) {
      return xl ?? lg ?? md ?? sm;
    } else if (width >= _desktopBreakpoint) {
      return lg ?? md ?? sm;
    } else if (width >= _tabletBreakpoint) {
      return md ?? sm;
    } else {
      return sm;
    }
  }

  // ============================================================
  // Grid Layout Helpers
  // ============================================================

  /// Get adaptive grid column count based on device type and orientation
  ///
  /// Default values:
  /// - Phone portrait: 2 columns
  /// - Phone landscape: 3 columns
  /// - Tablet portrait: 3 columns
  /// - Tablet landscape: 4 columns
  /// - Desktop: 4-6 columns
  static int getGridColumnCount(BuildContext context) {
    if (isDesktop(context)) {
      return isLandscape(context) ? 6 : 4;
    } else if (isTablet(context)) {
      return isLandscape(context) ? 4 : 3;
    } else {
      return isLandscape(context) ? 3 : 2;
    }
  }

  /// Get custom grid column count with full control
  static int getCustomGridColumnCount(
    BuildContext context, {
    required int phonePortrait,
    required int phoneLandscape,
    required int tabletPortrait,
    required int tabletLandscape,
    int? desktopPortrait,
    int? desktopLandscape,
  }) {
    if (isDesktop(context)) {
      return isLandscape(context)
          ? (desktopLandscape ?? tabletLandscape)
          : (desktopPortrait ?? tabletPortrait);
    } else if (isTablet(context)) {
      return isLandscape(context) ? tabletLandscape : tabletPortrait;
    } else {
      return isLandscape(context) ? phoneLandscape : phonePortrait;
    }
  }

  // ============================================================
  // Spacing Helpers
  // ============================================================

  /// Get adaptive horizontal padding based on device type
  static double getHorizontalPadding(BuildContext context) {
    return valueByDevice(
      context,
      phone: 16.w,
      tablet: 24.w,
      desktop: 32.w,
    );
  }

  /// Get adaptive vertical padding based on device type
  static double getVerticalPadding(BuildContext context) {
    return valueByDevice(
      context,
      phone: 16.h,
      tablet: 24.h,
      desktop: 32.h,
    );
  }

  /// Get adaptive content max width for centered layouts
  ///
  /// Useful for creating centered content containers with max width
  static double getContentMaxWidth(BuildContext context) {
    return valueByDevice(
      context,
      phone: double.infinity,
      tablet: 768,
      desktop: 1200,
    );
  }

  // ============================================================
  // Typography Helpers
  // ============================================================

  /// Get adaptive font scale factor
  ///
  /// Returns a multiplier for base font sizes based on device type
  static double getFontScale(BuildContext context) {
    return valueByDevice(
      context,
      phone: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
  }

  // ============================================================
  // Safe Area Helpers
  // ============================================================

  /// Get safe area padding (top, bottom, left, right)
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get safe area top padding (for status bar)
  static double getSafeAreaTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get safe area bottom padding (for navigation bar)
  static double getSafeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  // ============================================================
  // Debug Helpers
  // ============================================================

  /// Get device information as a formatted string (for debugging)
  static String getDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final deviceType = isDesktop(context)
        ? 'Desktop'
        : isTablet(context)
            ? 'Tablet'
            : 'Phone';

    return '''
Device Type: $deviceType
Screen Size: ${size.width.toStringAsFixed(0)} x ${size.height.toStringAsFixed(0)}
Shortest Side: ${size.shortestSide.toStringAsFixed(0)}
Orientation: ${orientation.name}
ScreenUtil Scale: ${ScreenUtil().scaleWidth.toStringAsFixed(2)}
''';
  }
}

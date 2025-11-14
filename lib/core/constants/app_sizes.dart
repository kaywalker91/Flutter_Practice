import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Application size constants using flutter_screenutil
/// All sizes are based on design spec: 375 x 812 (iPhone X)
class AppSizes {
  AppSizes._(); // Private constructor to prevent instantiation

  // Spacing constants
  static double spaceXS = 4.w;
  static double spaceSM = 8.w;
  static double spaceMD = 16.w;
  static double spaceLG = 24.w;
  static double spaceXL = 32.w;
  static double spaceXXL = 48.w;

  // Padding constants
  static double paddingXS = 4.w;
  static double paddingSM = 8.w;
  static double paddingMD = 16.w;
  static double paddingLG = 24.w;
  static double paddingXL = 32.w;

  // Border radius constants
  static double radiusXS = 4.r;
  static double radiusSM = 8.r;
  static double radiusMD = 12.r;
  static double radiusLG = 16.r;
  static double radiusXL = 24.r;
  static double radiusCircle = 999.r;

  // Icon sizes
  static double iconXS = 16.w;
  static double iconSM = 20.w;
  static double iconMD = 24.w;
  static double iconLG = 32.w;
  static double iconXL = 48.w;

  // Button sizes
  static double buttonHeightSM = 32.h;
  static double buttonHeightMD = 40.h;
  static double buttonHeightLG = 48.h;
  static double buttonHeightXL = 56.h;

  // Input field sizes
  static double inputHeightSM = 40.h;
  static double inputHeightMD = 48.h;
  static double inputHeightLG = 56.h;

  // AppBar height
  static double appBarHeight = 56.h;

  // Bottom navigation bar height
  static double bottomNavHeight = 60.h;

  // Divider thickness
  static double dividerThickness = 1.w;

  // Image sizes
  static double imageXS = 40.w;
  static double imageSM = 60.w;
  static double imageMD = 80.w;
  static double imageLG = 120.w;
  static double imageXL = 160.w;

  // Card sizes
  static double cardElevation = 2;
  static double cardElevationHover = 4;

  // Screen breakpoints for responsive design
  static double breakpointTablet = 600;
  static double breakpointDesktop = 1024;
  static double breakpointLargeDesktop = 1440;

  // Animation durations (in milliseconds)
  static const int animationDurationFast = 200;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;
}

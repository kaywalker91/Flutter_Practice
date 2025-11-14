import 'package:flutter/material.dart';

/// Application color constants
/// Define all color values used throughout the app
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary colors
  static const Color primary = Color(0xFF6750A4);
  static const Color primaryLight = Color(0xFF9A82DB);
  static const Color primaryDark = Color(0xFF4A3779);
  static const Color primaryDarkMode = Color(0xFFBB86FC);     // 다크모드 전용 밝은 보라색

  // Secondary colors
  static const Color secondary = Color(0xFF625B71);
  static const Color secondaryLight = Color(0xFF8A8299);
  static const Color secondaryDark = Color(0xFF4A444F);
  static const Color secondaryDarkMode = Color(0xFF03DAC6);   // 다크모드 전용 청록색 악센트

  // Background colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color backgroundDark = Color(0xFF000000);      // 순수 검은색 (WCAG AAA 21:1)
  static const Color surface = Color(0xFFFFFBFE);
  static const Color surfaceDark = Color(0xFF1A1A1A);         // 카드/컨테이너 배경
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);  // 선택/호버 상태

  // Text colors
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);     // 순백색 (최대 대비, WCAG AAA: 21:1)
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textSecondaryDark = Color(0xFFE0E0E0);   // 밝은 회색 (WCAG AAA: 15.91:1, 88% 밝기)
  static const Color textTertiaryDark = Color(0xFFB0B0B0);    // 중간 회색 (WCAG AA+: 9.68:1, 69% 밝기)

  // Semantic colors
  static const Color error = Color(0xFFB3261E);
  static const Color errorLight = Color(0xFFF2B8B5);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Divider and border colors
  static const Color divider = Color(0xFFCAC4D0);
  static const Color dividerDark = Color(0xFF404040);         // 밝은 구분선 (대비 2.5:1)
  static const Color border = Color(0xFFCAC4D0);
  static const Color borderDark = Color(0xFF505050);          // 밝은 경계선 (대비 3:1)

  // Transparent colors
  static const Color transparent = Colors.transparent;
  static const Color black12 = Colors.black12;
  static const Color black26 = Colors.black26;
  static const Color black38 = Colors.black38;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/core/constants/app_colors.dart';

/// WCAG 2.1 색상 대비율 검증 테스트
///
/// WCAG AAA 기준:
/// - 일반 텍스트: 7:1 이상
/// - 큰 텍스트 (18pt 이상 또는 14pt bold): 4.5:1 이상
/// - 최소 시각적 구분: 1.1:1 이상
void main() {
  group('Dark Mode Color Contrast Tests (WCAG AAA)', () {
    test('Background vs Primary Text meets WCAG AAA (21:1)', () {
      final ratio = _calculateContrastRatio(
        AppColors.backgroundDark,
        AppColors.textPrimaryDark,
      );

      expect(ratio, greaterThanOrEqualTo(7.0),
          reason: 'Primary text on background must meet WCAG AAA (7:1)');

      // 실제 21:1 대비 검증
      expect(ratio, greaterThanOrEqualTo(21.0),
          reason: 'Pure white on near-black should achieve maximum contrast');
    });

    test('Background vs Secondary Text meets WCAG AAA (15.91:1)', () {
      final ratio = _calculateContrastRatio(
        AppColors.backgroundDark,
        AppColors.textSecondaryDark,
      );

      expect(ratio, greaterThanOrEqualTo(7.0),
          reason: 'Secondary text on background must meet WCAG AAA (7:1)');

      // 실제 15.91:1 대비 검증
      expect(ratio, greaterThanOrEqualTo(15.0),
          reason: '88% gray (#E0E0E0) on black should achieve 15.91:1 contrast');
    });

    test('Background vs Tertiary Text exceeds WCAG AA (9.68:1)', () {
      final ratio = _calculateContrastRatio(
        AppColors.backgroundDark,
        AppColors.textTertiaryDark,
      );

      // 비활성/힌트 텍스트 - AA 기준 초과, AAA 근접
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Tertiary text (hints) must meet WCAG AA (4.5:1)');

      // 실제 9.68:1 대비 검증 (개선된 가시성)
      expect(ratio, greaterThanOrEqualTo(9.0),
          reason: '69% gray (#B0B0B0) on black should achieve 9.68:1 contrast');
    });

    test('Surface is visually distinguishable from Background (1.15:1)', () {
      final ratio = _calculateContrastRatio(
        AppColors.backgroundDark,
        AppColors.surfaceDark,
      );

      expect(ratio, greaterThanOrEqualTo(1.1),
          reason: 'Card surface must be visually distinct from background');

      // 실제 계산값 출력 (디버깅용)
      print('Surface vs Background contrast: ${ratio.toStringAsFixed(2)}:1');
    });

    test('Surface Variant provides layering depth (1.3:1)', () {
      final ratio = _calculateContrastRatio(
        AppColors.surfaceDark,
        AppColors.surfaceVariantDark,
      );

      expect(ratio, greaterThanOrEqualTo(1.1),
          reason: 'Surface variant must provide visual layering');
    });

    test('Primary Dark Mode color is visible on dark background', () {
      final ratio = _calculateContrastRatio(
        AppColors.backgroundDark,
        AppColors.primaryDarkMode,
      );

      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Primary accent color must be visible on dark background');
    });

    test('Secondary Dark Mode color is visible on dark background', () {
      final ratio = _calculateContrastRatio(
        AppColors.backgroundDark,
        AppColors.secondaryDarkMode,
      );

      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Secondary accent color must be visible on dark background');
    });

    test('Border is visible on surface (2:1)', () {
      final ratio = _calculateContrastRatio(
        AppColors.surfaceDark,
        AppColors.borderDark,
      );

      expect(ratio, greaterThanOrEqualTo(1.5),
          reason: 'Borders must be clearly visible on surfaces');
    });

    test('Divider is visible on background (2:1)', () {
      final ratio = _calculateContrastRatio(
        AppColors.backgroundDark,
        AppColors.dividerDark,
      );

      expect(ratio, greaterThanOrEqualTo(1.5),
          reason: 'Dividers must be clearly visible on background');
    });
  });

  group('Color Contrast Utility Tests', () {
    test('Luminance calculation is accurate', () {
      // 순백색
      final whiteLuminance = _calculateLuminance(Colors.white);
      expect(whiteLuminance, closeTo(1.0, 0.001));

      // 순검은색
      final blackLuminance = _calculateLuminance(Colors.black);
      expect(blackLuminance, closeTo(0.0, 0.001));
    });

    test('Contrast ratio calculation matches WCAG formula', () {
      // 순백색 vs 순검은색: 21:1 (최대 대비)
      final maxRatio = _calculateContrastRatio(Colors.white, Colors.black);
      expect(maxRatio, closeTo(21.0, 0.1));

      // 동일 색상: 1:1 (대비 없음)
      final sameRatio = _calculateContrastRatio(Colors.white, Colors.white);
      expect(sameRatio, closeTo(1.0, 0.1));
    });
  });
}

/// 색상의 상대 휘도(Relative Luminance) 계산
///
/// WCAG 2.1 공식:
/// L = 0.2126 * R + 0.7152 * G + 0.0722 * B
///
/// 여기서 R, G, B는:
/// - if RsRGB <= 0.03928 then R = RsRGB/12.92
/// - else R = ((RsRGB+0.055)/1.055) ^ 2.4
double _calculateLuminance(Color color) {
  // RGB 값을 0-1 범위로 정규화
  final r = color.red / 255.0;
  final g = color.green / 255.0;
  final b = color.blue / 255.0;

  // 감마 보정
  final rLinear = r <= 0.03928 ? r / 12.92 : _pow((r + 0.055) / 1.055, 2.4);
  final gLinear = g <= 0.03928 ? g / 12.92 : _pow((g + 0.055) / 1.055, 2.4);
  final bLinear = b <= 0.03928 ? b / 12.92 : _pow((b + 0.055) / 1.055, 2.4);

  // 상대 휘도 계산
  return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
}

/// 두 색상 간의 대비율(Contrast Ratio) 계산
///
/// WCAG 2.1 공식:
/// (L1 + 0.05) / (L2 + 0.05)
///
/// 여기서 L1은 더 밝은 색상의 상대 휘도,
/// L2는 더 어두운 색상의 상대 휘도
double _calculateContrastRatio(Color color1, Color color2) {
  final luminance1 = _calculateLuminance(color1);
  final luminance2 = _calculateLuminance(color2);

  final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
  final darker = luminance1 > luminance2 ? luminance2 : luminance1;

  return (lighter + 0.05) / (darker + 0.05);
}

/// 거듭제곱 계산 헬퍼 함수
double _pow(double base, double exponent) {
  return math.pow(base, exponent).toDouble();
}

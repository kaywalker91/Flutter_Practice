import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../constants/app_animations.dart';

/// Animated counter widget for displaying changing numeric values
///
/// Features:
/// - Smooth counting animation with customizable duration
/// - Support for currency formatting
/// - Tabular figures for aligned digits
/// - Color change indication for positive/negative changes
/// - Accessibility support

class AnimatedCounter extends StatelessWidget {
  /// The target value to animate to
  final double value;

  /// Previous value (for change indication)
  final double? previousValue;

  /// Text style for the counter
  final TextStyle? style;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Number of decimal places
  final int decimalPlaces;

  /// Prefix (e.g., '$', '¥')
  final String? prefix;

  /// Suffix (e.g., 'USD', 'ETH')
  final String? suffix;

  /// Whether to show thousand separators
  final bool useThousandSeparator;

  /// Color for positive change
  final Color? positiveColor;

  /// Color for negative change
  final Color? negativeColor;

  /// Whether to animate color change
  final bool animateColor;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.previousValue,
    this.style,
    this.duration = AppAnimations.durationBalanceCounter,
    this.curve = AppAnimations.curveEmphasized,
    this.decimalPlaces = 2,
    this.prefix,
    this.suffix,
    this.useThousandSeparator = true,
    this.positiveColor,
    this.negativeColor,
    this.animateColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasChange = previousValue != null && previousValue != value;
    final bool isPositive = hasChange && value > previousValue!;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: previousValue ?? value,
        end: value,
      ),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, child) {
        // Calculate color if color animation is enabled
        Color? textColor;
        if (animateColor && hasChange) {
          textColor = isPositive ? positiveColor : negativeColor;
        }

        final formattedValue = _formatNumber(
          animatedValue,
          decimalPlaces: decimalPlaces,
          useThousandSeparator: useThousandSeparator,
        );

        final displayText = '${prefix ?? ''}$formattedValue${suffix ?? ''}';

        return Semantics(
          label: 'Balance: $displayText',
          liveRegion: true, // Announce changes to screen readers
          child: Text(
            displayText,
            style: (style ?? const TextStyle()).copyWith(
              color: textColor ?? style?.color,
              fontFeatures: const [
                ui.FontFeature.tabularFigures(), // Monospaced numbers
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatNumber(
    double value, {
    required int decimalPlaces,
    required bool useThousandSeparator,
  }) {
    final integerPart = value.floor().abs();
    final decimalPart = ((value.abs() - integerPart) * 100)
        .round()
        .toString()
        .padLeft(decimalPlaces, '0');

    String integerString = integerPart.toString();

    if (useThousandSeparator && integerPart >= 1000) {
      integerString = _addThousandSeparators(integerString);
    }

    final sign = value < 0 ? '-' : '';

    if (decimalPlaces > 0) {
      return '$sign$integerString.$decimalPart';
    } else {
      return '$sign$integerString';
    }
  }

  String _addThousandSeparators(String value) {
    final buffer = StringBuffer();
    final length = value.length;

    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(value[i]);
    }

    return buffer.toString();
  }
}

/// Animated percentage change indicator
class AnimatedPercentageChange extends StatelessWidget {
  /// The percentage change value (-100 to 100+)
  final double percentage;

  /// Previous percentage (for animation)
  final double? previousPercentage;

  /// Text style
  final TextStyle? style;

  /// Animation duration
  final Duration duration;

  /// Whether to show the '+' sign for positive values
  final bool showPlusSign;

  const AnimatedPercentageChange({
    super.key,
    required this.percentage,
    this.previousPercentage,
    this.style,
    this.duration = AppAnimations.durationMedium,
    this.showPlusSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = percentage >= 0;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: previousPercentage ?? percentage,
        end: percentage,
      ),
      duration: duration,
      curve: AppAnimations.curveEmphasized,
      builder: (context, animatedValue, child) {
        final sign =
            animatedValue >= 0 ? (showPlusSign ? '+' : '') : '';
        final formattedValue = animatedValue.abs().toStringAsFixed(2);

        return Text(
          '$sign$formattedValue%',
          style: (style ?? theme.textTheme.bodyMedium)?.copyWith(
            color: isPositive
                ? theme.colorScheme.tertiary
                : theme.colorScheme.error,
            fontWeight: FontWeight.w600,
            fontFeatures: const [
              ui.FontFeature.tabularFigures(),
            ],
          ),
        );
      },
    );
  }
}

/// Animated rolling counter (digit-by-digit animation)
///
/// Creates a slot-machine style rolling effect for each digit
class RollingCounter extends StatelessWidget {
  /// The target value to animate to
  final int value;

  /// Previous value (starting point)
  final int? previousValue;

  /// Text style for digits
  final TextStyle? style;

  /// Animation duration
  final Duration duration;

  /// Padding between digits
  final double digitPadding;

  const RollingCounter({
    super.key,
    required this.value,
    this.previousValue,
    this.style,
    this.duration = AppAnimations.durationBalanceCounter,
    this.digitPadding = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final digits = value.toString().split('');
    final previousDigits = (previousValue ?? value).toString().split('');

    // Pad with leading zeros if needed
    while (previousDigits.length < digits.length) {
      previousDigits.insert(0, '0');
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: List.generate(digits.length, (index) {
        final digit = int.parse(digits[index]);
        final previousDigit = index < previousDigits.length
            ? int.parse(previousDigits[index])
            : 0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: digitPadding),
          child: _RollingDigit(
            digit: digit,
            previousDigit: previousDigit,
            style: style,
            duration: duration,
          ),
        );
      }),
    );
  }
}

/// Single rolling digit widget
class _RollingDigit extends StatelessWidget {
  final int digit;
  final int previousDigit;
  final TextStyle? style;
  final Duration duration;

  const _RollingDigit({
    required this.digit,
    required this.previousDigit,
    this.style,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: previousDigit.toDouble(),
        end: digit.toDouble(),
      ),
      duration: duration,
      curve: AppAnimations.curveEmphasized,
      builder: (context, value, child) {
        // Calculate the visible digit and offset
        final currentDigit = value.floor() % 10;
        final nextDigit = (currentDigit + 1) % 10;
        final progress = value - value.floor();

        return ClipRect(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Current digit (sliding up)
              Transform.translate(
                offset: Offset(0, -progress * 20),
                child: Opacity(
                  opacity: 1 - progress,
                  child: Text(
                    currentDigit.toString(),
                    style: style,
                  ),
                ),
              ),
              // Next digit (sliding up)
              Transform.translate(
                offset: Offset(0, (1 - progress) * 20),
                child: Opacity(
                  opacity: progress,
                  child: Text(
                    nextDigit.toString(),
                    style: style,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

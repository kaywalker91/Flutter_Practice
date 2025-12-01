import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// Animation constants and configurations for the wallet app
///
/// Defines standardized durations, curves, and configurations
/// following Material 3 motion guidelines
class AppAnimations {
  AppAnimations._();

  // ============================================================================
  // DURATIONS
  // ============================================================================

  /// Very fast animations (100ms) - subtle feedback
  static const Duration durationFast = Duration(milliseconds: 100);

  /// Normal animations (200ms) - standard interactions
  static const Duration durationNormal = Duration(milliseconds: 200);

  /// Medium animations (300ms) - standard transitions
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Slow animations (400ms) - complex transitions
  static const Duration durationSlow = Duration(milliseconds: 400);

  /// Very slow animations (600ms) - page transitions
  static const Duration durationVerySlow = Duration(milliseconds: 600);

  /// Balance counter animation (800ms)
  static const Duration durationBalanceCounter = Duration(milliseconds: 800);

  /// Shimmer cycle (1500ms)
  static const Duration durationShimmer = Duration(milliseconds: 1500);

  /// Stagger delay between list items (50ms)
  static const Duration durationStagger = Duration(milliseconds: 50);

  // ============================================================================
  // CURVES
  // ============================================================================

  /// Standard ease-out curve - most common
  static const Curve curveEaseOut = Curves.easeOutCubic;

  /// Standard ease-in curve
  static const Curve curveEaseIn = Curves.easeInCubic;

  /// Emphasized ease curve - Material 3 standard
  static const Curve curveEmphasized = Curves.easeInOutCubic;

  /// Spring curve - bouncy effect
  static const Curve curveSpring = Curves.elasticOut;

  /// Linear curve - constant speed
  static const Curve curveLinear = Curves.linear;

  /// Decelerate curve - fast start, slow end
  static const Curve curveDecelerate = Curves.decelerate;

  // ============================================================================
  // OFFSET ANIMATIONS
  // ============================================================================

  /// Slide from bottom (for modals, bottom sheets)
  static const Offset offsetSlideFromBottom = Offset(0, 1);

  /// Slide from top
  static const Offset offsetSlideFromTop = Offset(0, -1);

  /// Slide from right
  static const Offset offsetSlideFromRight = Offset(1, 0);

  /// Slide from left
  static const Offset offsetSlideFromLeft = Offset(-1, 0);

  /// No offset (starting position)
  static const Offset offsetZero = Offset.zero;

  // ============================================================================
  // SCALE ANIMATIONS
  // ============================================================================

  /// Scale from small (0.8)
  static const double scaleFrom = 0.8;

  /// Scale to normal (1.0)
  static const double scaleTo = 1.0;

  /// Scale pressed (0.95) - button feedback
  static const double scalePressed = 0.95;

  // ============================================================================
  // OPACITY ANIMATIONS
  // ============================================================================

  /// Fully transparent
  static const double opacityTransparent = 0.0;

  /// Fully opaque
  static const double opacityOpaque = 1.0;

  /// Semi-transparent (50%)
  static const double opacitySemi = 0.5;

  // ============================================================================
  // STAGGER CONFIGURATIONS
  // ============================================================================

  /// Maximum stagger duration (prevent excessive delays)
  static const Duration maxStaggerDuration = Duration(milliseconds: 500);

  /// Stagger delay multiplier
  static int getStaggerDelay(int index, {int maxItems = 10}) {
    // Limit stagger to first N items to prevent long delays
    final cappedIndex = index > maxItems ? maxItems : index;
    return cappedIndex * durationStagger.inMilliseconds;
  }

  // ============================================================================
  // SHIMMER CONFIGURATIONS
  // ============================================================================

  /// Shimmer gradient begin alignment
  static const shimmerBegin = Alignment(-1.0, -0.3);

  /// Shimmer gradient end alignment
  static const shimmerEnd = Alignment(1.0, 0.3);

  // ============================================================================
  // HERO TAGS
  // ============================================================================

  /// Generate unique hero tag for token icons
  static String heroTagToken(String tokenSymbol) => 'token_icon_$tokenSymbol';

  /// Generate unique hero tag for balance
  static String heroTagBalance(String tokenSymbol) =>
      'token_balance_$tokenSymbol';

  /// Hero tag for app logo
  static const String heroTagLogo = 'app_logo';

  // ============================================================================
  // MOTION PRESETS
  // ============================================================================

  /// Standard fade-in animation config
  static AnimationConfig get fadeIn => const AnimationConfig(
        duration: durationMedium,
        curve: curveEaseOut,
        beginOpacity: opacityTransparent,
        endOpacity: opacityOpaque,
      );

  /// Standard fade-out animation config
  static AnimationConfig get fadeOut => const AnimationConfig(
        duration: durationMedium,
        curve: curveEaseIn,
        beginOpacity: opacityOpaque,
        endOpacity: opacityTransparent,
      );

  /// Slide up animation (for bottom sheets)
  static AnimationConfig get slideUp => const AnimationConfig(
        duration: durationMedium,
        curve: curveEmphasized,
        beginOffset: offsetSlideFromBottom,
        endOffset: offsetZero,
      );

  /// Slide down animation
  static AnimationConfig get slideDown => const AnimationConfig(
        duration: durationMedium,
        curve: curveEmphasized,
        beginOffset: offsetSlideFromTop,
        endOffset: offsetZero,
      );

  /// Scale up animation (for dialogs)
  static AnimationConfig get scaleUp => const AnimationConfig(
        duration: durationMedium,
        curve: curveEmphasized,
        beginScale: scaleFrom,
        endScale: scaleTo,
      );

  /// Button press animation
  static AnimationConfig get buttonPress => const AnimationConfig(
        duration: durationFast,
        curve: curveEaseOut,
        beginScale: scaleTo,
        endScale: scalePressed,
      );
}

/// Animation configuration class
class AnimationConfig {
  final Duration duration;
  final Curve curve;
  final Offset? beginOffset;
  final Offset? endOffset;
  final double? beginScale;
  final double? endScale;
  final double? beginOpacity;
  final double? endOpacity;

  const AnimationConfig({
    required this.duration,
    required this.curve,
    this.beginOffset,
    this.endOffset,
    this.beginScale,
    this.endScale,
    this.beginOpacity,
    this.endOpacity,
  });
}

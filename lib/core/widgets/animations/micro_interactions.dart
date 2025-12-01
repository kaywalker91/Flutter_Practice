import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_animations.dart';

/// Animated button with scale and haptic feedback
///
/// Provides visual and tactile feedback on press

class AnimatedButton extends StatefulWidget {
  /// Child widget (typically Text or Icon)
  final Widget child;

  /// On tap callback
  final VoidCallback? onTap;

  /// On long press callback
  final VoidCallback? onLongPress;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Scale factor when pressed (0.0 to 1.0)
  final double pressScale;

  /// Enable haptic feedback
  final bool enableHaptic;

  /// Haptic feedback type
  final HapticFeedbackType hapticType;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.pressScale = AppAnimations.scalePressed,
    this.enableHaptic = true,
    this.hapticType = HapticFeedbackType.light,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.durationFast,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.curveEaseOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.enableHaptic) {
      _triggerHaptic();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _triggerHaptic() {
    switch (widget.hapticType) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

/// Animated card with press effect
class AnimatedCard extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// On tap callback
  final VoidCallback? onTap;

  /// Margin
  final EdgeInsetsGeometry? margin;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Elevation
  final double elevation;

  /// Enable press animation
  final bool enablePressAnimation;

  /// Enable haptic feedback
  final bool enableHaptic;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = 2.0,
    this.enablePressAnimation = true,
    this.enableHaptic = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.durationFast,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.curveEaseOut,
      ),
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.curveEaseOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressAnimation) {
      _controller.forward();
    }
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressAnimation) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePressAnimation) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      margin: widget.margin,
      color: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(16),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: widget.enablePressAnimation
            ? AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Material(
                      elevation: _elevationAnimation.value,
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(16),
                      color: Colors.transparent,
                      child: child,
                    ),
                  );
                },
                child: card,
              )
            : card,
      );
    }

    return card;
  }
}

/// Ripple effect widget
class RippleEffect extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// On tap callback
  final VoidCallback? onTap;

  /// Ripple color
  final Color? rippleColor;

  /// Border radius
  final BorderRadius? borderRadius;

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.borderRadius,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        splashColor: widget.rippleColor ??
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
        highlightColor: widget.rippleColor ??
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        child: widget.child,
      ),
    );
  }
}

/// Bounce animation widget
class BounceAnimation extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// On tap callback
  final VoidCallback? onTap;

  /// Bounce scale factor
  final double bounceScale;

  /// Enable haptic feedback
  final bool enableHaptic;

  const BounceAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.bounceScale = 1.1,
    this.enableHaptic = true,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.durationFast,
    );

    // Use simple Tween with spring curve for bounce effect
    // TweenSequence cannot be used with overshooting curves (elasticOut)
    // as they produce t values outside 0.0-1.0 range
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.bounceScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.curveSpring,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Shake animation widget (for error feedback)
class ShakeAnimation extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Trigger shake animation
  final bool shake;

  /// Shake offset
  final double offset;

  /// Number of shakes
  final int shakeCount;

  const ShakeAnimation({
    super.key,
    required this.child,
    required this.shake,
    this.offset = 10.0,
    this.shakeCount = 3,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.durationMedium,
    );

    // TweenSequence requires t values in 0.0-1.0 range
    // elasticIn curve produces values outside this range, causing assertion errors
    // Use easeInOut curve instead for smooth shake effect
    _offsetAnimation = TweenSequence<double>(
      List.generate(widget.shakeCount * 2, (index) {
        return TweenSequenceItem(
          tween: Tween<double>(
            begin: index.isEven ? 0 : widget.offset,
            end: index.isEven ? -widget.offset : 0,
          ),
          weight: 1,
        );
      }),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0);
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Pulse animation widget (for notifications)
class PulseAnimation extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Whether to pulse
  final bool pulse;

  /// Pulse scale
  final double pulseScale;

  /// Pulse duration
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.pulse = true,
    this.pulseScale = 1.05,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.pulseScale),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.pulseScale, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.pulse) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !oldWidget.pulse) {
      _controller.repeat();
    } else if (!widget.pulse && oldWidget.pulse) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';
import '../../constants/app_animations.dart';

/// Staggered animation wrapper for list items
///
/// Creates a sequential animation effect where items
/// appear one after another with a slight delay

class StaggeredListAnimation extends StatelessWidget {
  /// Index of the item in the list
  final int index;

  /// Child widget to animate
  final Widget child;

  /// Base delay before animation starts
  final Duration baseDelay;

  /// Delay between each item
  final Duration staggerDelay;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Animation type
  final StaggerAnimationType type;

  const StaggeredListAnimation({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = Duration.zero,
    this.staggerDelay = AppAnimations.durationStagger,
    this.duration = AppAnimations.durationMedium,
    this.curve = AppAnimations.curveEmphasized,
    this.type = StaggerAnimationType.slideAndFade,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total delay for this item
    final totalDelay = baseDelay +
        Duration(
          milliseconds: AppAnimations.getStaggerDelay(index),
        );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + totalDelay,
      curve: Interval(
        totalDelay.inMilliseconds / (duration + totalDelay).inMilliseconds,
        1.0,
        curve: curve,
      ),
      builder: (context, value, child) {
        switch (type) {
          case StaggerAnimationType.fade:
            return Opacity(
              opacity: value,
              child: child,
            );

          case StaggerAnimationType.slideFromRight:
            return Transform.translate(
              offset: Offset((1 - value) * 50, 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case StaggerAnimationType.slideFromLeft:
            return Transform.translate(
              offset: Offset((value - 1) * 50, 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case StaggerAnimationType.slideFromBottom:
            return Transform.translate(
              offset: Offset(0, (1 - value) * 30),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case StaggerAnimationType.slideAndFade:
            return Transform.translate(
              offset: Offset(0, (1 - value) * 20),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case StaggerAnimationType.scale:
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );

          case StaggerAnimationType.scaleAndFade:
            return Transform.scale(
              scale: 0.9 + (value * 0.1),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
        }
      },
      child: child,
    );
  }
}

/// Types of stagger animations
enum StaggerAnimationType {
  fade,
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  slideAndFade,
  scale,
  scaleAndFade,
}

/// ListView with automatic staggered animations
class StaggeredListView extends StatelessWidget {
  /// List of items to display
  final List<Widget> children;

  /// Animation type
  final StaggerAnimationType animationType;

  /// Animation duration
  final Duration duration;

  /// Stagger delay between items
  final Duration staggerDelay;

  /// Scroll direction
  final Axis scrollDirection;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Whether the list should shrink-wrap
  final bool shrinkWrap;

  const StaggeredListView({
    super.key,
    required this.children,
    this.animationType = StaggerAnimationType.slideAndFade,
    this.duration = AppAnimations.durationMedium,
    this.staggerDelay = AppAnimations.durationStagger,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return StaggeredListAnimation(
          index: index,
          duration: duration,
          staggerDelay: staggerDelay,
          type: animationType,
          child: children[index],
        );
      },
    );
  }
}

/// Grid with automatic staggered animations
class StaggeredGridView extends StatelessWidget {
  /// List of items to display
  final List<Widget> children;

  /// Cross-axis count
  final int crossAxisCount;

  /// Animation type
  final StaggerAnimationType animationType;

  /// Animation duration
  final Duration duration;

  /// Stagger delay between items
  final Duration staggerDelay;

  /// Cross-axis spacing
  final double crossAxisSpacing;

  /// Main-axis spacing
  final double mainAxisSpacing;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Child aspect ratio
  final double childAspectRatio;

  const StaggeredGridView({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.animationType = StaggerAnimationType.scaleAndFade,
    this.duration = AppAnimations.durationMedium,
    this.staggerDelay = AppAnimations.durationStagger,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.padding,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return StaggeredListAnimation(
          index: index,
          duration: duration,
          staggerDelay: staggerDelay,
          type: animationType,
          child: children[index],
        );
      },
    );
  }
}

/// Animated list item wrapper with automatic animation
class AnimatedListItem extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Animation duration
  final Duration duration;

  /// Animation delay
  final Duration delay;

  /// Animation type
  final StaggerAnimationType type;

  const AnimatedListItem({
    super.key,
    required this.child,
    this.duration = AppAnimations.durationMedium,
    this.delay = Duration.zero,
    this.type = StaggerAnimationType.slideAndFade,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.curveEmphasized,
    );

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        switch (widget.type) {
          case StaggerAnimationType.fade:
            return Opacity(
              opacity: _animation.value,
              child: child,
            );

          case StaggerAnimationType.slideFromRight:
            return Transform.translate(
              offset: Offset((1 - _animation.value) * 50, 0),
              child: Opacity(
                opacity: _animation.value,
                child: child,
              ),
            );

          case StaggerAnimationType.slideFromLeft:
            return Transform.translate(
              offset: Offset((_animation.value - 1) * 50, 0),
              child: Opacity(
                opacity: _animation.value,
                child: child,
              ),
            );

          case StaggerAnimationType.slideFromBottom:
            return Transform.translate(
              offset: Offset(0, (1 - _animation.value) * 30),
              child: Opacity(
                opacity: _animation.value,
                child: child,
              ),
            );

          case StaggerAnimationType.slideAndFade:
            return Transform.translate(
              offset: Offset(0, (1 - _animation.value) * 20),
              child: Opacity(
                opacity: _animation.value,
                child: child,
              ),
            );

          case StaggerAnimationType.scale:
            return Transform.scale(
              scale: 0.8 + (_animation.value * 0.2),
              child: Opacity(
                opacity: _animation.value,
                child: child,
              ),
            );

          case StaggerAnimationType.scaleAndFade:
            return Transform.scale(
              scale: 0.9 + (_animation.value * 0.1),
              child: Opacity(
                opacity: _animation.value,
                child: child,
              ),
            );
        }
      },
    );
  }
}

/// Reveal animation for cards
class RevealAnimation extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Animation duration
  final Duration duration;

  /// Animation delay
  final Duration delay;

  /// Whether to start automatically
  final bool autoStart;

  const RevealAnimation({
    super.key,
    required this.child,
    this.duration = AppAnimations.durationSlow,
    this.delay = Duration.zero,
    this.autoStart = true,
  });

  @override
  State<RevealAnimation> createState() => _RevealAnimationState();
}

class _RevealAnimationState extends State<RevealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.curveEmphasized,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.curveEmphasized,
      ),
    );

    if (widget.autoStart) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Trigger the reveal animation manually
  void reveal() {
    _controller.forward();
  }

  /// Reset the animation
  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';
import '../../constants/app_animations.dart';

/// Enhanced Hero animation widgets for smooth transitions
///
/// Provides pre-configured hero animations for common wallet app scenarios

/// Token icon hero animation
class TokenIconHero extends StatelessWidget {
  /// Token symbol (used for unique tag)
  final String tokenSymbol;

  /// Icon widget to animate
  final Widget child;

  /// Optional custom tag
  final String? customTag;

  const TokenIconHero({
    super.key,
    required this.tokenSymbol,
    required this.child,
    this.customTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: customTag ?? AppAnimations.heroTagToken(tokenSymbol),
      flightShuttleBuilder: _flightShuttleBuilder,
      child: child,
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    // Use circular clip during flight for smooth transition
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipOval(
          child: child,
        );
      },
      child: toHeroContext.widget as Hero,
    );
  }
}

/// Balance text hero animation
class BalanceHero extends StatelessWidget {
  /// Token symbol or unique identifier
  final String identifier;

  /// Balance widget to animate
  final Widget child;

  const BalanceHero({
    super.key,
    required this.identifier,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: AppAnimations.heroTagBalance(identifier),
      flightShuttleBuilder: _flightShuttleBuilder,
      // Prevent Material from wrapping the hero
      createRectTween: (begin, end) {
        return MaterialRectArcTween(begin: begin, end: end);
      },
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    // Smoothly transition text style during flight
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget as Hero,
    );
  }
}

/// Card hero animation with rounded corners
class CardHero extends StatelessWidget {
  /// Unique tag for the hero
  final String tag;

  /// Card widget to animate
  final Widget child;

  /// Border radius for the card
  final BorderRadius? borderRadius;

  const CardHero({
    super.key,
    required this.tag,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      createRectTween: _createRectTween,
      flightShuttleBuilder: _flightShuttleBuilder,
      child: child,
    );
  }

  RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(16);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: child,
        );
      },
      child: toHeroContext.widget as Hero,
    );
  }
}

/// Image hero animation with fade
class ImageHero extends StatelessWidget {
  /// Unique tag for the hero
  final String tag;

  /// Image widget to animate
  final Widget image;

  /// Border radius for the image
  final BorderRadius? borderRadius;

  const ImageHero({
    super.key,
    required this.tag,
    required this.image,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      createRectTween: _createRectTween,
      flightShuttleBuilder: _flightShuttleBuilder,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: image,
      ),
    );
  }

  RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final tween = ColorTween(
      begin: Colors.transparent,
      end: Colors.black.withOpacity(0.1),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            tween.evaluate(animation) ?? Colors.transparent,
            BlendMode.darken,
          ),
          child: child,
        );
      },
      child: toHeroContext.widget as Hero,
    );
  }
}

/// Custom hero flight shuttle builder utilities
class HeroFlightShuttleBuilders {
  HeroFlightShuttleBuilders._();

  /// Standard fade transition during flight
  static Widget fade(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return FadeTransition(
      opacity: animation,
      child: toHeroContext.widget as Hero,
    );
  }

  /// Scale transition during flight
  static Widget scale(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: AppAnimations.curveEmphasized,
        ),
      ),
      child: toHeroContext.widget as Hero,
    );
  }

  /// Rotation transition during flight
  static Widget rotate(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.0,
        end: 0.25,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: AppAnimations.curveEmphasized,
        ),
      ),
      child: toHeroContext.widget as Hero,
    );
  }

  /// Material elevation transition during flight
  static Widget elevate(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Material(
          elevation: Tween<double>(
            begin: 2.0,
            end: 8.0,
          ).evaluate(animation),
          child: child,
        );
      },
      child: toHeroContext.widget as Hero,
    );
  }
}

/// Hero page route with custom transition
class HeroPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Duration _transitionDuration;
  final Color? _barrierColor;

  HeroPageRoute({
    required this.builder,
    Duration transitionDuration = AppAnimations.durationMedium,
    Color? barrierColor,
    super.settings,
  })  : _transitionDuration = transitionDuration,
        _barrierColor = barrierColor;

  @override
  Color? get barrierColor => _barrierColor;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Fade background during hero transition
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

/// Navigate with hero animation
Future<T?> navigateWithHero<T>(
  BuildContext context,
  Widget page, {
  Duration? duration,
  Color? barrierColor,
}) {
  return Navigator.of(context).push<T>(
    HeroPageRoute<T>(
      builder: (_) => page,
      transitionDuration: duration ?? AppAnimations.durationMedium,
      barrierColor: barrierColor,
    ),
  );
}

/// Placeholder widget for hero animations
class HeroPlaceholder extends StatelessWidget {
  /// Tag for the hero
  final String tag;

  /// Width of the placeholder
  final double? width;

  /// Height of the placeholder
  final double? height;

  /// Child widget (optional)
  final Widget? child;

  const HeroPlaceholder({
    super.key,
    required this.tag,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: SizedBox(
        width: width,
        height: height,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

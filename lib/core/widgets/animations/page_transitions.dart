import 'package:flutter/material.dart';
import '../../constants/app_animations.dart';

/// Custom page route transitions for wallet app navigation
///
/// Provides Material 3 compliant page transitions with
/// consistent animations throughout the app

// ============================================================================
// SLIDE TRANSITIONS
// ============================================================================

/// Slide transition from bottom (for modal-style pages)
class SlideFromBottomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  SlideFromBottomPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: AppAnimations.durationMedium,
          reverseTransitionDuration: AppAnimations.durationMedium,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: AppAnimations.offsetSlideFromBottom,
                end: AppAnimations.offsetZero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEmphasized,
                  reverseCurve: AppAnimations.curveEmphasized,
                ),
              ),
              child: child,
            );
          },
        );
}

/// Slide transition from right (standard navigation)
class SlideFromRightPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  SlideFromRightPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: AppAnimations.durationMedium,
          reverseTransitionDuration: AppAnimations.durationMedium,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: AppAnimations.offsetSlideFromRight,
                end: AppAnimations.offsetZero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEmphasized,
                  reverseCurve: AppAnimations.curveEmphasized,
                ),
              ),
              child: child,
            );
          },
        );
}

// ============================================================================
// FADE TRANSITIONS
// ============================================================================

/// Fade transition (for subtle page changes)
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: AppAnimations.durationMedium,
          reverseTransitionDuration: AppAnimations.durationMedium,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

// ============================================================================
// SCALE TRANSITIONS
// ============================================================================

/// Scale transition (for dialog-style pages)
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  ScalePageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: AppAnimations.durationMedium,
          reverseTransitionDuration: AppAnimations.durationMedium,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: AppAnimations.scaleFrom,
                end: AppAnimations.scaleTo,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEmphasized,
                  reverseCurve: AppAnimations.curveEmphasized,
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}

// ============================================================================
// SHARED AXIS TRANSITIONS (Material 3)
// ============================================================================

/// Shared axis transition (Z-axis) - for related content
class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  SharedAxisPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: AppAnimations.durationMedium,
          reverseTransitionDuration: AppAnimations.durationMedium,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Forward animation (incoming page)
            final incomingScale = Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
              ),
            );

            final incomingFade = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
              ),
            );

            // Reverse animation (outgoing page)
            final outgoingScale = Tween<double>(
              begin: 1.0,
              end: 1.1,
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
              ),
            );

            final outgoingFade = Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
              ),
            );

            return Stack(
              children: [
                // Outgoing page (if exists)
                if (secondaryAnimation.status != AnimationStatus.dismissed)
                  FadeTransition(
                    opacity: outgoingFade,
                    child: ScaleTransition(
                      scale: outgoingScale,
                      child: Container(),
                    ),
                  ),
                // Incoming page
                FadeTransition(
                  opacity: incomingFade,
                  child: ScaleTransition(
                    scale: incomingScale,
                    child: child,
                  ),
                ),
              ],
            );
          },
        );
}

// ============================================================================
// CUSTOM TRANSITIONS
// ============================================================================

/// Slide and fade transition (combined effect)
class SlideAndFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Offset beginOffset;

  SlideAndFadePageRoute({
    required this.child,
    this.beginOffset = AppAnimations.offsetSlideFromBottom,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: AppAnimations.durationMedium,
          reverseTransitionDuration: AppAnimations.durationMedium,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: AppAnimations.offsetZero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.curveEmphasized,
                  reverseCurve: AppAnimations.curveEmphasized,
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}

/// Custom page transition builder for MaterialApp
class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Use slide from right for standard navigation
    return SlideTransition(
      position: Tween<Offset>(
        begin: AppAnimations.offsetSlideFromRight,
        end: AppAnimations.offsetZero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: AppAnimations.curveEmphasized,
          reverseCurve: AppAnimations.curveEmphasized,
        ),
      ),
      child: child,
    );
  }
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/// Navigate with slide from bottom transition
Future<T?> navigateSlideFromBottom<T>(
  BuildContext context,
  Widget page,
) {
  return Navigator.of(context).push(
    SlideFromBottomPageRoute<T>(child: page),
  );
}

/// Navigate with slide from right transition
Future<T?> navigateSlideFromRight<T>(
  BuildContext context,
  Widget page,
) {
  return Navigator.of(context).push(
    SlideFromRightPageRoute<T>(child: page),
  );
}

/// Navigate with fade transition
Future<T?> navigateFade<T>(
  BuildContext context,
  Widget page,
) {
  return Navigator.of(context).push(
    FadePageRoute<T>(child: page),
  );
}

/// Navigate with scale transition
Future<T?> navigateScale<T>(
  BuildContext context,
  Widget page,
) {
  return Navigator.of(context).push(
    ScalePageRoute<T>(child: page),
  );
}

/// Navigate with shared axis transition
Future<T?> navigateSharedAxis<T>(
  BuildContext context,
  Widget page,
) {
  return Navigator.of(context).push(
    SharedAxisPageRoute<T>(child: page),
  );
}

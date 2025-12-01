import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_animations.dart';

/// Shimmer loading animation widget
///
/// Creates a smooth shimmer effect for skeleton screens
/// following Material 3 design guidelines

class ShimmerLoader extends StatefulWidget {
  /// Child widget to apply shimmer effect to
  final Widget child;

  /// Base color (background)
  final Color? baseColor;

  /// Highlight color (shimmer)
  final Color? highlightColor;

  /// Animation duration
  final Duration duration;

  /// Whether the shimmer is enabled
  final bool enabled;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = AppAnimations.durationShimmer,
    this.enabled = true,
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final baseColor = widget.baseColor ??
        (theme.brightness == Brightness.light
            ? Colors.grey[300]!
            : Colors.grey[700]!);
    final highlightColor = widget.highlightColor ??
        (theme.brightness == Brightness.light
            ? Colors.grey[100]!
            : Colors.grey[600]!);

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: AppAnimations.shimmerBegin,
              end: AppAnimations.shimmerEnd,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * 2 * (slidePercent - 0.5),
      0.0,
      0.0,
    );
  }
}

/// Pre-built shimmer skeleton shapes

/// Rectangular shimmer skeleton
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[700]!;

    return ShimmerLoader(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Circular shimmer skeleton
class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({
    super.key,
    required this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[700]!;

    return ShimmerLoader(
      child: Container(
        width: size,
        height: size,
        margin: margin,
        decoration: BoxDecoration(
          color: baseColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Shimmer text placeholder
class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerText({
    super.key,
    required this.width,
    this.height = 16.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width,
      height: height,
      borderRadius: 4.0,
      margin: margin,
    );
  }
}

// ============================================================================
// PRE-BUILT SKELETON SCREENS
// ============================================================================

/// Token list item skeleton
class TokenListItemSkeleton extends StatelessWidget {
  const TokenListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Token icon
          ShimmerCircle(size: 48.w),
          SizedBox(width: 12.w),

          // Token info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerText(width: 100.w, height: 18.h),
                SizedBox(height: 4.h),
                ShimmerText(width: 60.w, height: 14.h),
              ],
            ),
          ),

          // Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerText(width: 80.w, height: 18.h),
              SizedBox(height: 4.h),
              ShimmerText(width: 50.w, height: 14.h),
            ],
          ),
        ],
      ),
    );
  }
}

/// Transaction list item skeleton
class TransactionListItemSkeleton extends StatelessWidget {
  const TransactionListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Icon
          ShimmerCircle(size: 40.w),
          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerText(width: 120.w, height: 16.h),
                SizedBox(height: 4.h),
                ShimmerText(width: 80.w, height: 12.h),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerText(width: 70.w, height: 16.h),
              SizedBox(height: 4.h),
              ShimmerBox(width: 40.w, height: 16.h, borderRadius: 8.r),
            ],
          ),
        ],
      ),
    );
  }
}

/// Card skeleton
class CardSkeleton extends StatelessWidget {
  final double? height;

  const CardSkeleton({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            ShimmerText(width: 120.w, height: 20.h),
            SizedBox(height: 16.h),

            // Content lines
            ShimmerText(width: double.infinity, height: 14.h),
            SizedBox(height: 8.h),
            ShimmerText(width: double.infinity, height: 14.h),
            SizedBox(height: 8.h),
            ShimmerText(width: 200.w, height: 14.h),

            if (height != null) ...[
              SizedBox(height: 16.h),
              ShimmerBox(
                width: double.infinity,
                height: height! - 120.h,
                borderRadius: 8.r,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Chart skeleton
class ChartSkeleton extends StatelessWidget {
  final double height;

  const ChartSkeleton({
    super.key,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: double.infinity,
      height: height,
      borderRadius: 12.r,
    );
  }
}

/// Full page skeleton with multiple components
class PageSkeleton extends StatelessWidget {
  final int itemCount;

  const PageSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header with balance
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerText(width: 100.w, height: 14.h),
                SizedBox(height: 8.h),
                ShimmerText(width: 200.w, height: 36.h),
                SizedBox(height: 4.h),
                ShimmerText(width: 80.w, height: 16.h),
              ],
            ),
          );
        }
        return const TokenListItemSkeleton();
      },
    );
  }
}

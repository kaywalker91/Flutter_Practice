import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/responsive_helper.dart';

/// Responsive grid view that automatically adjusts column count based on screen size
///
/// Example:
/// ```dart
/// ResponsiveGrid(
///   children: [
///     GridItem1(),
///     GridItem2(),
///     GridItem3(),
///   ],
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// Optional custom column counts for different device types
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    final int columnCount = _getColumnCount(context);

    return GridView.builder(
      padding: padding ?? EdgeInsets.all(16.w),
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: crossAxisSpacing ?? 12.w,
        mainAxisSpacing: mainAxisSpacing ?? 12.h,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  int _getColumnCount(BuildContext context) {
    // Use custom column counts if provided
    if (mobileColumns != null ||
        tabletColumns != null ||
        desktopColumns != null) {
      return ResponsiveHelper.valueByDevice(
        context,
        phone: mobileColumns ?? 2,
        tablet: tabletColumns ?? 3,
        desktop: desktopColumns ?? 4,
      );
    }

    // Use default adaptive column count
    return ResponsiveHelper.getGridColumnCount(context);
  }
}

/// Responsive grid view with custom builder for infinite scrolling
///
/// Example:
/// ```dart
/// ResponsiveGridBuilder(
///   itemCount: 100,
///   itemBuilder: (context, index) => GridItem(index: index),
/// )
/// ```
class ResponsiveGridBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// Optional custom column counts for different device types
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGridBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    final int columnCount = _getColumnCount(context);

    return GridView.builder(
      padding: padding ?? EdgeInsets.all(16.w),
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: crossAxisSpacing ?? 12.w,
        mainAxisSpacing: mainAxisSpacing ?? 12.h,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  int _getColumnCount(BuildContext context) {
    // Use custom column counts if provided
    if (mobileColumns != null ||
        tabletColumns != null ||
        desktopColumns != null) {
      return ResponsiveHelper.valueByDevice(
        context,
        phone: mobileColumns ?? 2,
        tablet: tabletColumns ?? 3,
        desktop: desktopColumns ?? 4,
      );
    }

    // Use default adaptive column count
    return ResponsiveHelper.getGridColumnCount(context);
  }
}

/// Responsive staggered grid for items with varying heights
///
/// Useful for masonry-style layouts
///
/// Example:
/// ```dart
/// ResponsiveStaggeredGrid(
///   children: [
///     StaggeredItem(height: 200),
///     StaggeredItem(height: 300),
///     StaggeredItem(height: 150),
///   ],
/// )
/// ```
class ResponsiveStaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// Optional custom column counts for different device types
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveStaggeredGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    final int columnCount = _getColumnCount(context);
    final double spacing = crossAxisSpacing ?? 12.w;

    return Padding(
      padding: padding ?? EdgeInsets.all(16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate column width
          final totalSpacing = spacing * (columnCount - 1);
          final availableWidth = constraints.maxWidth - totalSpacing;
          final columnWidth = availableWidth / columnCount;

          // Distribute children across columns
          final columns = List.generate(
            columnCount,
            (index) => <Widget>[],
          );

          for (int i = 0; i < children.length; i++) {
            final columnIndex = i % columnCount;
            columns[columnIndex].add(children[i]);
          }

          // Build column layout
          final columnWidgets = <Widget>[];
          for (int i = 0; i < columnCount; i++) {
            columnWidgets.add(
              SizedBox(
                width: columnWidth,
                child: Column(
                  children: columns[i]
                      .map((child) => Padding(
                            padding: EdgeInsets.only(
                              bottom: mainAxisSpacing ?? 12.h,
                            ),
                            child: child,
                          ))
                      .toList(),
                ),
              ),
            );

            // Add spacing between columns (except for the last column)
            if (i < columnCount - 1) {
              columnWidgets.add(SizedBox(width: spacing));
            }
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnWidgets,
          );
        },
      ),
    );
  }

  int _getColumnCount(BuildContext context) {
    // Use custom column counts if provided
    if (mobileColumns != null ||
        tabletColumns != null ||
        desktopColumns != null) {
      return ResponsiveHelper.valueByDevice(
        context,
        phone: mobileColumns ?? 2,
        tablet: tabletColumns ?? 3,
        desktop: desktopColumns ?? 4,
      );
    }

    // Use default adaptive column count
    return ResponsiveHelper.getGridColumnCount(context);
  }
}

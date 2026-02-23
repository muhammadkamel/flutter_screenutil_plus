import 'package:flutter/material.dart';

import '../utils/breakpoints.dart';
import '../utils/responsive_query.dart';

/// A container that adapts its properties based on breakpoints.
///
/// Similar to CSS media queries, this widget automatically adjusts
/// width, height, padding, and margin based on the current breakpoint.
///
/// Example:
/// ```dart
/// AdaptiveContainer(
///   width: {Breakpoint.xs: 100, Breakpoint.md: 200, Breakpoint.lg: 300},
///   padding: {Breakpoint.xs: EdgeInsets.all(8), Breakpoint.md: EdgeInsets.all(16)},
///   child: Text('Adaptive Container'),
/// )
/// ```
class AdaptiveContainer extends StatelessWidget {
  /// Creates an [AdaptiveContainer] with adaptive properties.
  ///
  /// All properties can be specified as maps of breakpoints to values,
  /// allowing different values for different screen sizes.
  const AdaptiveContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
    this.child,
    this.constraints,
    this.transform,
    this.breakpoints,
    this.color,
  }) : assert(
         color == null || decoration == null,
         'Cannot provide both a color and a decoration\n'
         'To provide both, use "decoration: BoxDecoration(color: color)".',
       );

  /// Width values for different breakpoints
  final Map<Breakpoint, num>? width;

  /// Height values for different breakpoints
  final Map<Breakpoint, num>? height;

  /// Padding values for different breakpoints
  final Map<Breakpoint, EdgeInsets>? padding;

  /// Margin values for different breakpoints
  final Map<Breakpoint, EdgeInsets>? margin;

  /// Decoration
  final BoxDecoration? decoration;

  /// Alignment
  final AlignmentGeometry? alignment;

  /// Child widget
  final Widget? child;

  /// Constraints
  final BoxConstraints? constraints;

  /// Transform
  final Matrix4? transform;

  /// Custom breakpoints
  final Breakpoints? breakpoints;

  /// Color (convenience property)
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final query = ResponsiveQuery.of(context, breakpoints: breakpoints);
    final Breakpoint breakpoint = query.breakpoint;

    // Get values for current breakpoint, falling back to smaller breakpoints
    double? resolvedWidth;
    if (width != null) {
      resolvedWidth = _getValueForBreakpoint(width!, breakpoint)?.toDouble();
    }

    double? resolvedHeight;
    if (height != null) {
      resolvedHeight = _getValueForBreakpoint(height!, breakpoint)?.toDouble();
    }

    EdgeInsets? resolvedPadding;
    if (padding != null) {
      resolvedPadding = _getValueForBreakpoint(padding!, breakpoint);
    }

    EdgeInsets? resolvedMargin;
    if (margin != null) {
      resolvedMargin = _getValueForBreakpoint(margin!, breakpoint);
    }

    final Widget container = Container(
      width: resolvedWidth,
      height: resolvedHeight,
      padding: resolvedPadding,
      margin: resolvedMargin,
      decoration:
          decoration ?? (color != null ? BoxDecoration(color: color) : null),
      alignment: alignment,
      constraints: constraints,
      transform: transform,
      child: child,
    );

    return container;
  }

  /// Gets the value for the current breakpoint, falling back to smaller breakpoints
  T? _getValueForBreakpoint<T>(Map<Breakpoint, T> values, Breakpoint current) {
    // Try current breakpoint first
    if (values.containsKey(current)) {
      return values[current];
    }

    // Try smaller breakpoints in reverse order
    for (final Breakpoint bp in Breakpoint.values.reversed) {
      if (bp.index < current.index && values.containsKey(bp)) {
        return values[bp];
      }
    }

    // Try larger breakpoints as fallback
    for (final Breakpoint bp in Breakpoint.values) {
      if (bp.index > current.index && values.containsKey(bp)) {
        return values[bp];
      }
    }

    return null;
  }
}

/// A simplified adaptive container with common breakpoint values.
///
/// Example:
/// ```dart
/// SimpleAdaptiveContainer(
///   widthXs: 100,
///   widthMd: 200,
///   widthLg: 300,
///   paddingXs: 8,
///   paddingMd: 16,
///   child: Text('Simple Adaptive'),
/// )
/// ```
class SimpleAdaptiveContainer extends StatelessWidget {
  /// Creates a [SimpleAdaptiveContainer] with simplified breakpoint properties.
  ///
  /// Instead of using maps, this widget provides individual properties
  /// for each breakpoint, making it easier to use for common cases.
  const SimpleAdaptiveContainer({
    super.key,
    this.widthXs,
    this.widthSm,
    this.widthMd,
    this.widthLg,
    this.widthXl,
    this.heightXs,
    this.heightSm,
    this.heightMd,
    this.heightLg,
    this.heightXl,
    this.paddingXs,
    this.paddingSm,
    this.paddingMd,
    this.paddingLg,
    this.paddingXl,
    this.marginXs,
    this.marginSm,
    this.marginMd,
    this.marginLg,
    this.marginXl,
    this.child,
    this.color,
    this.decoration,
    this.breakpoints,
  }) : assert(
         color == null || decoration == null,
         'Cannot provide both a color and a decoration\n'
         'To provide both, use "decoration: BoxDecoration(color: color)".',
       );

  /// Width for extra small screens
  final num? widthXs;

  /// Width for small screens
  final num? widthSm;

  /// Width for medium screens
  final num? widthMd;

  /// Width for large screens
  final num? widthLg;

  /// Width for extra large screens
  final num? widthXl;

  /// Height for extra small screens
  final num? heightXs;

  /// Height for small screens
  final num? heightSm;

  /// Height for medium screens
  final num? heightMd;

  /// Height for large screens
  final num? heightLg;

  /// Height for extra large screens
  final num? heightXl;

  /// Padding for extra small screens
  final EdgeInsets? paddingXs;

  /// Padding for small screens
  final EdgeInsets? paddingSm;

  /// Padding for medium screens
  final EdgeInsets? paddingMd;

  /// Padding for large screens
  final EdgeInsets? paddingLg;

  /// Padding for extra large screens
  final EdgeInsets? paddingXl;

  /// Margin for extra small screens
  final EdgeInsets? marginXs;

  /// Margin for small screens
  final EdgeInsets? marginSm;

  /// Margin for medium screens
  final EdgeInsets? marginMd;

  /// Margin for large screens
  final EdgeInsets? marginLg;

  /// Margin for extra large screens
  final EdgeInsets? marginXl;

  /// Child widget
  final Widget? child;

  /// Color
  final Color? color;

  /// Decoration
  final BoxDecoration? decoration;

  /// Custom breakpoints
  final Breakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    final adaptive = AdaptiveContainer(
      width: _createBreakpointMap(
        xs: widthXs,
        sm: widthSm,
        md: widthMd,
        lg: widthLg,
        xl: widthXl,
      ),
      height: _createBreakpointMap(
        xs: heightXs,
        sm: heightSm,
        md: heightMd,
        lg: heightLg,
        xl: heightXl,
      ),
      padding: _createBreakpointMap(
        xs: paddingXs,
        sm: paddingSm,
        md: paddingMd,
        lg: paddingLg,
        xl: paddingXl,
      ),
      margin: _createBreakpointMap(
        xs: marginXs,
        sm: marginSm,
        md: marginMd,
        lg: marginLg,
        xl: marginXl,
      ),
      color: color,
      decoration: decoration,
      breakpoints: breakpoints,
      child: child,
    );

    return adaptive;
  }

  Map<Breakpoint, T>? _createBreakpointMap<T>({
    T? xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
  }) {
    if (xs == null && sm == null && md == null && lg == null && xl == null) {
      return null;
    }
    return {
      Breakpoint.xs: ?xs,
      Breakpoint.sm: ?sm,
      Breakpoint.md: ?md,
      Breakpoint.lg: ?lg,
      Breakpoint.xl: ?xl,
    };
  }
}

import 'package:flutter/material.dart';

import '../extensions/size_extension.dart';
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
  });

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
      resolvedWidth = _getValueForBreakpoint(width!, breakpoint)?.w;
    }

    double? resolvedHeight;
    if (height != null) {
      resolvedHeight = _getValueForBreakpoint(height!, breakpoint)?.h;
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
    this.child,
    this.color,
    this.decoration,
    this.breakpoints,
  });

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
  final num? paddingXs;

  /// Padding for small screens
  final num? paddingSm;

  /// Padding for medium screens
  final num? paddingMd;

  /// Padding for large screens
  final num? paddingLg;

  /// Padding for extra large screens
  final num? paddingXl;

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
      width: {
        if (widthXs != null) Breakpoint.xs: widthXs!,
        if (widthSm != null) Breakpoint.sm: widthSm!,
        if (widthMd != null) Breakpoint.md: widthMd!,
        if (widthLg != null) Breakpoint.lg: widthLg!,
        if (widthXl != null) Breakpoint.xl: widthXl!,
      },
      height: {
        if (heightXs != null) Breakpoint.xs: heightXs!,
        if (heightSm != null) Breakpoint.sm: heightSm!,
        if (heightMd != null) Breakpoint.md: heightMd!,
        if (heightLg != null) Breakpoint.lg: heightLg!,
        if (heightXl != null) Breakpoint.xl: heightXl!,
      },
      padding: {
        if (paddingXs != null)
          Breakpoint.xs: EdgeInsets.all(paddingXs!.toDouble()),
        if (paddingSm != null)
          Breakpoint.sm: EdgeInsets.all(paddingSm!.toDouble()),
        if (paddingMd != null)
          Breakpoint.md: EdgeInsets.all(paddingMd!.toDouble()),
        if (paddingLg != null)
          Breakpoint.lg: EdgeInsets.all(paddingLg!.toDouble()),
        if (paddingXl != null)
          Breakpoint.xl: EdgeInsets.all(paddingXl!.toDouble()),
      },
      color: color,
      decoration: decoration,
      breakpoints: breakpoints,
      child: child,
    );

    return adaptive;
  }
}

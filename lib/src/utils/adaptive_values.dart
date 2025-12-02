import 'package:flutter/widgets.dart';

import '../extensions/size_extension.dart';
import 'breakpoints.dart';
import 'responsive_query.dart';

/// Adaptive value utilities that combine breakpoints with responsive sizing.
///
/// Provides a convenient way to get responsive values that adapt
/// based on breakpoints, similar to CSS media queries.
class AdaptiveValues {
  final BuildContext context;
  final Breakpoints breakpoints;

  AdaptiveValues._(this.context, this.breakpoints);

  /// Creates adaptive values from context
  factory AdaptiveValues.of(BuildContext context, {Breakpoints? breakpoints}) {
    return AdaptiveValues._(context, breakpoints ?? Breakpoints.bootstrap);
  }

  /// Gets responsive width value based on breakpoint
  ///
  /// Example:
  /// ```dart
  /// final width = AdaptiveValues.of(context).width(
  ///   xs: 50,
  ///   sm: 100,
  ///   md: 150,
  ///   lg: 200,
  /// );
  /// ```
  double width({num? xs, num? sm, num? md, num? lg, num? xl, num? xxl}) {
    final value = ResponsiveQuery.of(
      context,
      breakpoints: breakpoints,
    ).value(xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);
    return value.w;
  }

  /// Gets responsive height value based on breakpoint
  double height({num? xs, num? sm, num? md, num? lg, num? xl, num? xxl}) {
    final value = ResponsiveQuery.of(
      context,
      breakpoints: breakpoints,
    ).value(xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);
    return value.h;
  }

  /// Gets responsive font size value based on breakpoint
  double fontSize({num? xs, num? sm, num? md, num? lg, num? xl, num? xxl}) {
    final value = ResponsiveQuery.of(
      context,
      breakpoints: breakpoints,
    ).value(xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);
    return value.sp;
  }

  /// Gets responsive radius value based on breakpoint
  double radius({num? xs, num? sm, num? md, num? lg, num? xl, num? xxl}) {
    final value = ResponsiveQuery.of(
      context,
      breakpoints: breakpoints,
    ).value(xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);
    return value.r;
  }

  /// Gets responsive padding based on breakpoint
  EdgeInsets padding({
    EdgeInsets? xs,
    EdgeInsets? sm,
    EdgeInsets? md,
    EdgeInsets? lg,
    EdgeInsets? xl,
    EdgeInsets? xxl,
  }) {
    final value = ResponsiveQuery.of(
      context,
      breakpoints: breakpoints,
    ).value(xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);
    return value;
  }

  /// Gets responsive margin based on breakpoint
  EdgeInsets margin({
    EdgeInsets? xs,
    EdgeInsets? sm,
    EdgeInsets? md,
    EdgeInsets? lg,
    EdgeInsets? xl,
    EdgeInsets? xxl,
  }) {
    return padding(xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl);
  }
}

/// Extension on [BuildContext] for adaptive values
extension AdaptiveValuesExtension on BuildContext {
  /// Gets adaptive values instance
  AdaptiveValues adaptive({Breakpoints? breakpoints}) {
    return AdaptiveValues.of(this, breakpoints: breakpoints);
  }
}

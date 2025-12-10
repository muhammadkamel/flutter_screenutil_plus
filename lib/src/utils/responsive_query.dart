import 'package:flutter/widgets.dart';

import 'breakpoints.dart';
import 'size_class.dart';

/// Responsive query utilities similar to CSS media queries.
///
/// Provides methods to check breakpoints and size classes,
/// making it easy to create adaptive UIs.
class ResponsiveQuery {
  ResponsiveQuery._(this.context, this.breakpoints);

  /// Creates a responsive query from context
  factory ResponsiveQuery.of(BuildContext context, {Breakpoints? breakpoints}) {
    return ResponsiveQuery._(context, breakpoints ?? Breakpoints.bootstrap);
  }

  /// The build context used for media queries.
  final BuildContext context;

  /// The breakpoints configuration used for responsive design.
  final Breakpoints breakpoints;

  /// Gets the current screen width
  double get width => MediaQuery.of(context).size.width;

  /// Gets the current screen height
  double get height => MediaQuery.of(context).size.height;

  /// Gets the current breakpoint
  Breakpoint get breakpoint => breakpoints.getBreakpoint(width);

  /// Gets the current size classes
  SizeClasses get sizeClasses =>
      SizeClasses.fromMediaQuery(MediaQuery.of(context));

  /// Checks if current width is at least the specified breakpoint
  bool isAtLeast(Breakpoint breakpoint) {
    return breakpoints.isAtLeast(breakpoint, width);
  }

  /// Checks if current width is less than the specified breakpoint
  bool isLessThan(Breakpoint breakpoint) {
    return breakpoints.isLessThan(breakpoint, width);
  }

  /// Checks if current width is between two breakpoints (inclusive)
  bool isBetween(Breakpoint min, Breakpoint max) {
    return breakpoints.isBetween(min, max, width);
  }

  /// Checks if current breakpoint is exactly the specified one
  bool isExactly(Breakpoint breakpoint) {
    return this.breakpoint == breakpoint;
  }

  /// Returns a value based on the current breakpoint
  ///
  /// Example:
  /// ```dart
  /// final padding = ResponsiveQuery.of(context).value(
  ///   xs: 8.0,
  ///   sm: 12.0,
  ///   md: 16.0,
  ///   lg: 24.0,
  /// );
  /// ```
  T value<T>({T? xs, T? sm, T? md, T? lg, T? xl, T? xxl}) {
    return switch (breakpoint) {
      Breakpoint.xs => xs ?? sm ?? md ?? lg ?? xl ?? xxl!,
      Breakpoint.sm => sm ?? md ?? lg ?? xl ?? xxl ?? xs!,
      Breakpoint.md => md ?? lg ?? xl ?? xxl ?? sm ?? xs!,
      Breakpoint.lg => lg ?? xl ?? xxl ?? md ?? sm ?? xs!,
      Breakpoint.xl => xl ?? xxl ?? lg ?? md ?? sm ?? xs!,
      Breakpoint.xxl => xxl ?? xl ?? lg ?? md ?? sm ?? xs!,
    };
  }

  /// Returns a value based on size class
  ///
  /// Example:
  /// ```dart
  /// final columns = ResponsiveQuery.of(context).valueBySizeClass(
  ///   compact: 1,
  ///   regular: 3,
  /// );
  /// ```
  T valueBySizeClass<T>({required T compact, required T regular}) {
    return sizeClasses.isRegular ? regular : compact;
  }

  /// Returns a value based on horizontal size class
  T valueByHorizontalSizeClass<T>({required T compact, required T regular}) {
    return sizeClasses.isRegularHorizontal ? regular : compact;
  }

  /// Returns a value based on vertical size class
  T valueByVerticalSizeClass<T>({required T compact, required T regular}) {
    return sizeClasses.isRegularVertical ? regular : compact;
  }
}

/// Extension on [BuildContext] for convenient responsive queries
extension ResponsiveQueryExtension on BuildContext {
  /// Gets a responsive query instance
  ResponsiveQuery responsive({Breakpoints? breakpoints}) {
    return ResponsiveQuery.of(this, breakpoints: breakpoints);
  }

  /// Gets the current breakpoint
  Breakpoint get breakpoint => responsive().breakpoint;

  /// Checks if current width is at least the specified breakpoint
  bool isAtLeast(Breakpoint breakpoint) {
    return responsive().isAtLeast(breakpoint);
  }

  /// Checks if current width is less than the specified breakpoint
  bool isLessThan(Breakpoint breakpoint) {
    return responsive().isLessThan(breakpoint);
  }

  /// Checks if current width is between two breakpoints
  bool isBetween(Breakpoint min, Breakpoint max) {
    return responsive().isBetween(min, max);
  }

  /// Checks if current breakpoint is exactly the specified one
  bool isExactly(Breakpoint breakpoint) {
    return responsive().isExactly(breakpoint);
  }
}

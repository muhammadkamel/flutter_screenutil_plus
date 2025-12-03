import 'package:flutter/widgets.dart';

import '../utils/breakpoints.dart';
import '../utils/responsive_query.dart';
import '../utils/size_class.dart';

/// A builder widget that rebuilds based on breakpoint changes.
///
/// Similar to CSS media queries, this widget provides different
/// widgets based on the current breakpoint.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   xs: (context) => MobileLayout(),
///   md: (context) => TabletLayout(),
///   lg: (context) => DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Widget builder for extra small screens
  final Widget Function(BuildContext)? xs;

  /// Widget builder for small screens
  final Widget Function(BuildContext)? sm;

  /// Widget builder for medium screens
  final Widget Function(BuildContext)? md;

  /// Widget builder for large screens
  final Widget Function(BuildContext)? lg;

  /// Widget builder for extra large screens
  final Widget Function(BuildContext)? xl;

  /// Widget builder for 2XL screens
  final Widget Function(BuildContext)? xxl;

  /// Custom breakpoints (defaults to Bootstrap breakpoints)
  final Breakpoints? breakpoints;

  /// Fallback widget if no breakpoint matches
  final Widget? fallback;

  const ResponsiveBuilder({
    super.key,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.breakpoints,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final query = ResponsiveQuery.of(context, breakpoints: breakpoints);
    final breakpoint = query.breakpoint;

    final builder = switch (breakpoint) {
      Breakpoint.xs => xs ?? sm ?? md ?? lg ?? xl ?? xxl,
      Breakpoint.sm => sm ?? md ?? lg ?? xl ?? xxl ?? xs,
      Breakpoint.md => md ?? lg ?? xl ?? xxl ?? sm ?? xs,
      Breakpoint.lg => lg ?? xl ?? xxl ?? md ?? sm ?? xs,
      Breakpoint.xl => xl ?? xxl ?? lg ?? md ?? sm ?? xs,
      Breakpoint.xxl => xxl ?? xl ?? lg ?? md ?? sm ?? xs,
    };

    if (builder != null) {
      return builder(context);
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// A builder widget that rebuilds based on size class changes.
///
/// Similar to SwiftUI's size class system, this widget provides
/// different widgets based on the current size class.
///
/// Example:
/// ```dart
/// SizeClassBuilder(
///   compact: (context) => CompactLayout(),
///   regular: (context) => RegularLayout(),
/// )
/// ```
class SizeClassBuilder extends StatelessWidget {
  /// Widget builder for compact size class
  final Widget Function(BuildContext)? compact;

  /// Widget builder for regular size class
  final Widget Function(BuildContext)? regular;

  /// Widget builder based on horizontal size class
  final Widget Function(BuildContext, SizeClass horizontal)? horizontal;

  /// Widget builder based on vertical size class
  final Widget Function(BuildContext, SizeClass vertical)? vertical;

  /// Widget builder with full size class information
  final Widget Function(BuildContext, SizeClasses sizeClasses)? builder;

  /// Size class threshold (default: 600)
  final double threshold;

  const SizeClassBuilder({
    super.key,
    this.compact,
    this.regular,
    this.horizontal,
    this.vertical,
    this.builder,
    this.threshold = 600,
  });

  @override
  Widget build(BuildContext context) {
    final sizeClasses = SizeClasses.fromMediaQuery(
      MediaQuery.of(context),
      threshold: threshold,
    );

    // Use builder if provided
    if (builder != null) {
      return builder!(context, sizeClasses);
    }

    // Use horizontal builder if provided
    if (horizontal != null) {
      return horizontal!(context, sizeClasses.horizontal);
    }

    // Use vertical builder if provided
    if (vertical != null) {
      return vertical!(context, sizeClasses.vertical);
    }

    // Use compact/regular builders
    if (sizeClasses.isRegular && regular != null) {
      return regular!(context);
    }

    if (sizeClasses.isCompact && compact != null) {
      return compact!(context);
    }

    // Fallback to regular if compact not provided
    if (regular != null) {
      return regular!(context);
    }

    // Fallback to compact if regular not provided
    if (compact != null) {
      return compact!(context);
    }

    return const SizedBox.shrink();
  }
}

/// A widget that shows different widgets based on breakpoint conditions.
///
/// Similar to CSS media queries with conditional rendering.
///
/// Example:
/// ```dart
/// ConditionalBuilder(
///   condition: (context) => context.isAtLeast(Breakpoint.md),
///   builder: (context) => DesktopLayout(),
///   fallback: (context) => MobileLayout(),
/// )
/// ```
class ConditionalBuilder extends StatelessWidget {
  /// Condition function that determines which widget to show
  final bool Function(BuildContext) condition;

  /// Widget builder when condition is true
  final Widget Function(BuildContext) builder;

  /// Widget builder when condition is false (optional)
  final Widget Function(BuildContext)? fallback;

  const ConditionalBuilder({
    super.key,
    required this.condition,
    required this.builder,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (condition(context)) {
      return builder(context);
    }
    if (fallback != null) {
      return fallback!(context);
    }
    return const SizedBox.shrink();
  }
}

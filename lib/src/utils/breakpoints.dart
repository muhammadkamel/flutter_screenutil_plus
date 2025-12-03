/// Breakpoint definitions similar to CSS media queries.
///
/// Defines standard breakpoints for responsive design:
/// - xs: Extra small devices (phones in portrait)
/// - sm: Small devices (phones in landscape, small tablets)
/// - md: Medium devices (tablets)
/// - lg: Large devices (desktops)
/// - xl: Extra large devices (large desktops)
class Breakpoints {
  /// Creates a [Breakpoints] instance with custom breakpoint values.
  ///
  /// All breakpoints default to standard Bootstrap 5 values if not specified.
  const Breakpoints({
    this.xs = 0,
    this.sm = 576,
    this.md = 768,
    this.lg = 992,
    this.xl = 1200,
    this.xxl = 1400,
  });

  /// Extra small devices (phones in portrait mode)
  /// Default: 0px
  final double xs;

  /// Small devices (phones in landscape, small tablets)
  /// Default: 576px
  final double sm;

  /// Medium devices (tablets)
  /// Default: 768px
  final double md;

  /// Large devices (desktops)
  /// Default: 992px
  final double lg;

  /// Extra large devices (large desktops)
  /// Default: 1200px
  final double xl;

  /// 2XL devices (extra large desktops)
  /// Default: 1400px
  final double xxl;

  /// Bootstrap 5 breakpoints
  static const Breakpoints bootstrap = Breakpoints();

  /// Tailwind CSS breakpoints
  static const Breakpoints tailwind = Breakpoints(
    sm: 640,
    lg: 1024,
    xl: 1280,
    xxl: 1536,
  );

  /// Material Design breakpoints
  static const Breakpoints material = Breakpoints(
    sm: 600,
    md: 960,
    lg: 1280,
    xl: 1920,
    xxl: 2560,
  );

  /// Custom breakpoints for mobile-first design
  static const Breakpoints mobileFirst = Breakpoints(
    sm: 480,
    lg: 1024,
    xl: 1440,
    xxl: 1920,
  );

  /// Gets the current breakpoint based on width
  Breakpoint getBreakpoint(double width) {
    if (width >= xxl) {
      return Breakpoint.xxl;
    }
    if (width >= xl) {
      return Breakpoint.xl;
    }
    if (width >= lg) {
      return Breakpoint.lg;
    }
    if (width >= md) {
      return Breakpoint.md;
    }
    if (width >= sm) {
      return Breakpoint.sm;
    }
    return Breakpoint.xs;
  }

  /// Checks if width is at least the specified breakpoint
  bool isAtLeast(Breakpoint breakpoint, double width) {
    final double breakpointValue = _getBreakpointValue(breakpoint);
    return width >= breakpointValue;
  }

  /// Checks if width is less than the specified breakpoint
  bool isLessThan(Breakpoint breakpoint, double width) {
    final double breakpointValue = _getBreakpointValue(breakpoint);
    return width < breakpointValue;
  }

  /// Checks if width is between two breakpoints (inclusive)
  bool isBetween(Breakpoint min, Breakpoint max, double width) {
    final double minValue = _getBreakpointValue(min);
    final double maxValue = _getBreakpointValue(max);
    return width >= minValue && width < maxValue;
  }

  double _getBreakpointValue(Breakpoint breakpoint) {
    switch (breakpoint) {
      case Breakpoint.xs:
        return xs;
      case Breakpoint.sm:
        return sm;
      case Breakpoint.md:
        return md;
      case Breakpoint.lg:
        return lg;
      case Breakpoint.xl:
        return xl;
      case Breakpoint.xxl:
        return xxl;
    }
  }
}

/// Breakpoint enum representing different screen sizes
enum Breakpoint {
  /// Extra small devices (phones in portrait)
  xs,

  /// Small devices (phones in landscape, small tablets)
  sm,

  /// Medium devices (tablets)
  md,

  /// Large devices (desktops)
  lg,

  /// Extra large devices (large desktops)
  xl,

  /// 2XL devices (extra large desktops)
  xxl,
}

/// Extension on [Breakpoint] for convenient comparisons
extension BreakpointExtension on Breakpoint {
  /// Checks if this breakpoint is at least as large as [other]
  bool isAtLeast(Breakpoint other) {
    return index >= other.index;
  }

  /// Checks if this breakpoint is smaller than [other]
  bool isSmallerThan(Breakpoint other) {
    return index < other.index;
  }

  /// Gets the next larger breakpoint
  Breakpoint? get next {
    if (index < Breakpoint.values.length - 1) {
      return Breakpoint.values[index + 1];
    }
    return null;
  }

  /// Gets the previous smaller breakpoint
  Breakpoint? get previous {
    if (index > 0) {
      return Breakpoint.values[index - 1];
    }
    return null;
  }
}

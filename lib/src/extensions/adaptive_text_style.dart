import 'package:flutter/material.dart';

import '../extensions/size_extension.dart';
import '../utils/breakpoints.dart';
import '../utils/responsive_query.dart';

/// Extension on [BuildContext] for creating adaptive text styles.
///
/// This extension provides methods to create text styles that adapt to
/// different screen breakpoints, making it easy to implement responsive typography.
extension AdaptiveTextStyleExtension on BuildContext {
  /// Creates an adaptive [TextStyle] based on the current breakpoint.
  ///
  /// You can specify different values for each breakpoint (xs, sm, md, lg, xl).
  /// If a value is not provided for the current breakpoint, it falls back to
  /// the next smaller breakpoint.
  ///
  /// Font sizes are automatically scaled using the `.sp` extension.
  ///
  /// Example:
  /// ```dart
  /// Text(
  ///   'Responsive Text',
  ///   style: context.adaptiveTextStyle(
  ///     fontSizeXs: 14,
  ///     fontSizeMd: 16,
  ///     fontSizeLg: 18,
  ///     lineHeightXs: 1.2,
  ///     lineHeightMd: 1.5,
  ///     fontWeightLg: FontWeight.bold,
  ///   ),
  /// )
  /// ```
  TextStyle adaptiveTextStyle({
    double? fontSizeXs,
    double? fontSizeSm,
    double? fontSizeMd,
    double? fontSizeLg,
    double? fontSizeXl,
    double? fontSizeXxl,
    double? lineHeightXs,
    double? lineHeightSm,
    double? lineHeightMd,
    double? lineHeightLg,
    double? lineHeightXl,
    double? lineHeightXxl,
    FontWeight? fontWeightXs,
    FontWeight? fontWeightSm,
    FontWeight? fontWeightMd,
    FontWeight? fontWeightLg,
    FontWeight? fontWeightXl,
    FontWeight? fontWeightXxl,
    Color? colorXs,
    Color? colorSm,
    Color? colorMd,
    Color? colorLg,
    Color? colorXl,
    Color? colorXxl,
    double? letterSpacingXs,
    double? letterSpacingSm,
    double? letterSpacingMd,
    double? letterSpacingLg,
    double? letterSpacingXl,
    double? letterSpacingXxl,
    TextStyle? baseStyle,
  }) {
    final Breakpoint breakpoint = this.breakpoint;

    // Determine adaptive values based on current breakpoint
    final double? fontSize = _getAdaptiveValue(
      breakpoint,
      fontSizeXs,
      fontSizeSm,
      fontSizeMd,
      fontSizeLg,
      fontSizeXl,
      fontSizeXxl,
    );

    final double? lineHeight = _getAdaptiveValue(
      breakpoint,
      lineHeightXs,
      lineHeightSm,
      lineHeightMd,
      lineHeightLg,
      lineHeightXl,
      lineHeightXxl,
    );

    final FontWeight? fontWeight = _getAdaptiveValue(
      breakpoint,
      fontWeightXs,
      fontWeightSm,
      fontWeightMd,
      fontWeightLg,
      fontWeightXl,
      fontWeightXxl,
    );

    final Color? color = _getAdaptiveValue(
      breakpoint,
      colorXs,
      colorSm,
      colorMd,
      colorLg,
      colorXl,
      colorXxl,
    );

    final double? letterSpacing = _getAdaptiveValue(
      breakpoint,
      letterSpacingXs,
      letterSpacingSm,
      letterSpacingMd,
      letterSpacingLg,
      letterSpacingXl,
      letterSpacingXxl,
    );

    // Build the adaptive text style
    TextStyle style = baseStyle ?? const TextStyle();

    if (fontSize != null) {
      style = style.copyWith(fontSize: fontSize.sp);
    }

    if (lineHeight != null) {
      style = style.copyWith(height: lineHeight);
    }

    if (fontWeight != null) {
      style = style.copyWith(fontWeight: fontWeight);
    }

    if (color != null) {
      style = style.copyWith(color: color);
    }

    if (letterSpacing != null) {
      style = style.copyWith(letterSpacing: letterSpacing);
    }

    return style;
  }

  /// Gets the appropriate value for the current breakpoint.
  ///
  /// Falls back to the next smaller breakpoint if the current one is not defined.
  T? _getAdaptiveValue<T>(
    Breakpoint breakpoint,
    T? xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
    T? xxl,
  ) {
    switch (breakpoint) {
      case Breakpoint.xs:
        return xs ?? sm ?? md ?? lg ?? xl ?? xxl;
      case Breakpoint.sm:
        return sm ?? xs ?? md ?? lg ?? xl ?? xxl;
      case Breakpoint.md:
        return md ?? sm ?? xs ?? lg ?? xl ?? xxl;
      case Breakpoint.lg:
        return lg ?? md ?? sm ?? xs ?? xl ?? xxl;
      case Breakpoint.xl:
        return xl ?? lg ?? md ?? sm ?? xs ?? xxl;
      case Breakpoint.xxl:
        return xxl ?? xl ?? lg ?? md ?? sm ?? xs;
    }
  }
}

import 'package:flutter/material.dart';

import '../extensions/size_extension.dart';
import '../utils/breakpoints.dart';
import '../utils/responsive_query.dart';

/// A text widget that adapts its style based on screen breakpoints.
///
/// [AdaptiveText] allows you to specify different text properties for different
/// screen sizes, making it easy to create responsive typography.
///
/// Example:
/// ```dart
/// AdaptiveText(
///   'Responsive Heading',
///   fontSizeXs: 16,
///   fontSizeMd: 20,
///   fontSizeLg: 24,
///   lineHeightXs: 1.2,
///   lineHeightMd: 1.5,
///   fontWeightXs: FontWeight.normal,
///   fontWeightLg: FontWeight.bold,
/// )
/// ```
class AdaptiveText extends StatelessWidget {
  const AdaptiveText(
    this.data, {
    super.key,
    this.fontSizeXs,
    this.fontSizeSm,
    this.fontSizeMd,
    this.fontSizeLg,
    this.fontSizeXl,
    this.fontSizeXxl,
    this.lineHeightXs,
    this.lineHeightSm,
    this.lineHeightMd,
    this.lineHeightLg,
    this.lineHeightXl,
    this.lineHeightXxl,
    this.fontWeightXs,
    this.fontWeightSm,
    this.fontWeightMd,
    this.fontWeightLg,
    this.fontWeightXl,
    this.fontWeightXxl,
    this.colorXs,
    this.colorSm,
    this.colorMd,
    this.colorLg,
    this.colorXl,
    this.colorXxl,
    this.letterSpacingXs,
    this.letterSpacingSm,
    this.letterSpacingMd,
    this.letterSpacingLg,
    this.letterSpacingXl,
    this.letterSpacingXxl,
    this.baseStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  final String data;

  // Font size for each breakpoint
  final double? fontSizeXs;
  final double? fontSizeSm;
  final double? fontSizeMd;
  final double? fontSizeLg;
  final double? fontSizeXl;
  final double? fontSizeXxl;

  // Line height for each breakpoint
  final double? lineHeightXs;
  final double? lineHeightSm;
  final double? lineHeightMd;
  final double? lineHeightLg;
  final double? lineHeightXl;
  final double? lineHeightXxl;

  // Font weight for each breakpoint
  final FontWeight? fontWeightXs;
  final FontWeight? fontWeightSm;
  final FontWeight? fontWeightMd;
  final FontWeight? fontWeightLg;
  final FontWeight? fontWeightXl;
  final FontWeight? fontWeightXxl;

  // Color for each breakpoint
  final Color? colorXs;
  final Color? colorSm;
  final Color? colorMd;
  final Color? colorLg;
  final Color? colorXl;
  final Color? colorXxl;

  // Letter spacing for each breakpoint
  final double? letterSpacingXs;
  final double? letterSpacingSm;
  final double? letterSpacingMd;
  final double? letterSpacingLg;
  final double? letterSpacingXl;
  final double? letterSpacingXxl;

  // Base style to merge with adaptive properties
  final TextStyle? baseStyle;

  // Text widget properties
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;

    // Determine adaptive values based on current breakpoint
    final fontSize = _getAdaptiveValue(
      breakpoint,
      fontSizeXs,
      fontSizeSm,
      fontSizeMd,
      fontSizeLg,
      fontSizeXl,
      fontSizeXxl,
    );

    final lineHeight = _getAdaptiveValue(
      breakpoint,
      lineHeightXs,
      lineHeightSm,
      lineHeightMd,
      lineHeightLg,
      lineHeightXl,
      lineHeightXxl,
    );

    final fontWeight = _getAdaptiveValue(
      breakpoint,
      fontWeightXs,
      fontWeightSm,
      fontWeightMd,
      fontWeightLg,
      fontWeightXl,
      fontWeightXxl,
    );

    final color = _getAdaptiveValue(
      breakpoint,
      colorXs,
      colorSm,
      colorMd,
      colorLg,
      colorXl,
      colorXxl,
    );

    final letterSpacing = _getAdaptiveValue(
      breakpoint,
      letterSpacingXs,
      letterSpacingSm,
      letterSpacingMd,
      letterSpacingLg,
      letterSpacingXl,
      letterSpacingXxl,
    );

    // Build the adaptive text style
    TextStyle adaptiveStyle = baseStyle ?? const TextStyle();

    if (fontSize != null) {
      adaptiveStyle = adaptiveStyle.copyWith(fontSize: fontSize.sp);
    }

    if (lineHeight != null) {
      adaptiveStyle = adaptiveStyle.copyWith(height: lineHeight);
    }

    if (fontWeight != null) {
      adaptiveStyle = adaptiveStyle.copyWith(fontWeight: fontWeight);
    }

    if (color != null) {
      adaptiveStyle = adaptiveStyle.copyWith(color: color);
    }

    if (letterSpacing != null) {
      adaptiveStyle = adaptiveStyle.copyWith(letterSpacing: letterSpacing);
    }

    return Text(
      data,
      style: adaptiveStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
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

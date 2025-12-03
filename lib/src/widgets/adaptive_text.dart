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
  /// Creates an [AdaptiveText] widget with adaptive text properties.
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

  /// The text string to display.
  final String data;

  // Font size for each breakpoint
  /// Font size for extra small screens (xs breakpoint).
  final double? fontSizeXs;

  /// Font size for small screens (sm breakpoint).
  final double? fontSizeSm;

  /// Font size for medium screens (md breakpoint).
  final double? fontSizeMd;

  /// Font size for large screens (lg breakpoint).
  final double? fontSizeLg;

  /// Font size for extra large screens (xl breakpoint).
  final double? fontSizeXl;

  /// Font size for 2XL screens (xxl breakpoint).
  final double? fontSizeXxl;

  // Line height for each breakpoint
  /// Line height for extra small screens (xs breakpoint).
  final double? lineHeightXs;

  /// Line height for small screens (sm breakpoint).
  final double? lineHeightSm;

  /// Line height for medium screens (md breakpoint).
  final double? lineHeightMd;

  /// Line height for large screens (lg breakpoint).
  final double? lineHeightLg;

  /// Line height for extra large screens (xl breakpoint).
  final double? lineHeightXl;

  /// Line height for 2XL screens (xxl breakpoint).
  final double? lineHeightXxl;

  // Font weight for each breakpoint
  /// Font weight for extra small screens (xs breakpoint).
  final FontWeight? fontWeightXs;

  /// Font weight for small screens (sm breakpoint).
  final FontWeight? fontWeightSm;

  /// Font weight for medium screens (md breakpoint).
  final FontWeight? fontWeightMd;

  /// Font weight for large screens (lg breakpoint).
  final FontWeight? fontWeightLg;

  /// Font weight for extra large screens (xl breakpoint).
  final FontWeight? fontWeightXl;

  /// Font weight for 2XL screens (xxl breakpoint).
  final FontWeight? fontWeightXxl;

  // Color for each breakpoint
  /// Text color for extra small screens (xs breakpoint).
  final Color? colorXs;

  /// Text color for small screens (sm breakpoint).
  final Color? colorSm;

  /// Text color for medium screens (md breakpoint).
  final Color? colorMd;

  /// Text color for large screens (lg breakpoint).
  final Color? colorLg;

  /// Text color for extra large screens (xl breakpoint).
  final Color? colorXl;

  /// Text color for 2XL screens (xxl breakpoint).
  final Color? colorXxl;

  // Letter spacing for each breakpoint
  /// Letter spacing for extra small screens (xs breakpoint).
  final double? letterSpacingXs;

  /// Letter spacing for small screens (sm breakpoint).
  final double? letterSpacingSm;

  /// Letter spacing for medium screens (md breakpoint).
  final double? letterSpacingMd;

  /// Letter spacing for large screens (lg breakpoint).
  final double? letterSpacingLg;

  /// Letter spacing for extra large screens (xl breakpoint).
  final double? letterSpacingXl;

  /// Letter spacing for 2XL screens (xxl breakpoint).
  final double? letterSpacingXxl;

  // Base style to merge with adaptive properties
  /// Base text style that adaptive properties will be merged with.
  final TextStyle? baseStyle;

  // Text widget properties
  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The scaling factor for the text.
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text to span.
  final int? maxLines;

  /// An alternative semantics label for this text.
  final String? semanticsLabel;

  /// Defines how the width of the text is determined.
  final TextWidthBasis? textWidthBasis;

  /// Controls how the text will be painted vertically.
  final TextHeightBehavior? textHeightBehavior;

  /// The color to use when painting the selection.
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final Breakpoint breakpoint = context.breakpoint;

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

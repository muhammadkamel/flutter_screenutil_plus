import 'package:flutter/material.dart';

import '../../flutter_screenutil_plus.dart';

/// A responsive text widget that automatically scales font size.
///
/// [RText] wraps the standard [Text] widget and applies responsive scaling
/// to the font size using the `.sp` extension.
///
/// If [TextStyle.height] is not provided, a default line height will be
/// automatically calculated based on the font size (default: 1.2x font size).
class RText extends StatelessWidget {
  /// Creates a responsive text widget with the given data and style.
  const RText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
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

  /// Default line height multiplier when height is not explicitly provided.
  /// This value represents the ratio of line height to font size.
  /// A value of 1.2 means the line height will be 20% larger than the font size.
  static const double defaultLineHeightMultiplier = 1.2;

  /// The text to display.
  final String data;

  /// If non-null, the style to use for this text.
  final TextStyle? style;

  /// The strut style to use.
  final StrutStyle? strutStyle;

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
    // Register dependency on ScreenUtilPlusScope for efficient reactivity
    context.su;

    TextStyle? responsiveStyle = style;

    if (responsiveStyle != null) {
      // Use the extension to scale font size and apply auto line height
      responsiveStyle = responsiveStyle.withAutoLineHeight();
    } else {
      // Use default text style from theme and scale it
      final TextStyle defaultStyle = DefaultTextStyle.of(context).style;
      responsiveStyle = defaultStyle.withAutoLineHeight();
    }

    return Text(
      data,
      style: responsiveStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow ?? TextOverflow.visible,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

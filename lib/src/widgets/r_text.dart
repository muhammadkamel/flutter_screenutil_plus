import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// A responsive text widget that automatically scales font size.
///
/// [RText] wraps the standard [Text] widget and applies responsive scaling
/// to the font size using the `.sp` extension.
///
/// If [TextStyle.height] is not provided, a default line height will be
/// automatically calculated based on the font size (default: 1.2x font size).
class RText extends StatelessWidget {
  /// Default line height multiplier when height is not explicitly provided.
  /// This value represents the ratio of line height to font size.
  /// A value of 1.2 means the line height will be 20% larger than the font size.
  static const double defaultLineHeightMultiplier = 1.2;
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

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
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
    TextStyle? responsiveStyle = style;

    if (responsiveStyle != null) {
      // Use the extension to scale font size and apply auto line height
      responsiveStyle = responsiveStyle.withAutoLineHeight(
        defaultLineHeightMultiplier,
      );
    } else {
      // Use default text style from theme and scale it
      final defaultStyle = DefaultTextStyle.of(context).style;
      responsiveStyle = defaultStyle.withAutoLineHeight(
        defaultLineHeightMultiplier,
      );
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

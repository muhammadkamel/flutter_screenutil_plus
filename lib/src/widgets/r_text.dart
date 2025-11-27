import 'package:flutter/material.dart';

import '../extensions/size_extension.dart';

/// A responsive text widget that automatically scales font size.
///
/// [RText] wraps the standard [Text] widget and applies responsive scaling
/// to the font size using the `.sp` extension.
class RText extends StatelessWidget {
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

    if (responsiveStyle != null && responsiveStyle.fontSize != null) {
      responsiveStyle = responsiveStyle.copyWith(
        fontSize: responsiveStyle.fontSize!.sp,
      );
    } else if (responsiveStyle == null) {
      // Use default text style from theme and scale it
      final defaultStyle = DefaultTextStyle.of(context).style;
      if (defaultStyle.fontSize != null) {
        responsiveStyle = defaultStyle.copyWith(
          fontSize: defaultStyle.fontSize!.sp,
        );
      }
    }

    return Text(
      data,
      style: responsiveStyle,
      strutStyle: strutStyle,
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
}

import 'package:flutter/material.dart';

import 'size_extension.dart';

/// Extension on [TextStyle] to create responsive text styles.
///
/// This extension provides methods to adapt text styles based on screen size,
/// ensuring consistent typography across different devices.
extension TextStyleExtension on TextStyle {
  /// Creates a responsive [TextStyle] by scaling the font size.
  ///
  /// The font size is scaled using the `.sp` extension, while the height
  /// multiplier is preserved. This ensures that line height scales
  /// proportionally with the font size.
  ///
  /// If the original style has no fontSize, it returns the style unchanged.
  ///
  /// Example:
  /// ```dart
  /// TextStyle(fontSize: 16, height: 1.5).r
  /// // Results in: fontSize: 16.sp, height: 1.5 (multiplier preserved)
  /// ```
  TextStyle get r {
    if (fontSize == null) {
      return this;
    }

    return copyWith(
      fontSize: fontSize?.sp ?? 0,
      // height is a multiplier, so we preserve it as-is
      // The absolute line height will scale proportionally with fontSize
    );
  }

  /// Creates a responsive [TextStyle] with a custom line height multiplier.
  ///
  /// This method scales the font size using `.sp` and sets a new height
  /// multiplier based on the provided value.
  ///
  /// The [lineHeight] parameter represents the desired line height as a
  /// multiple of the font size. For example, 1.5 means the line height
  /// will be 1.5 times the font size.
  ///
  /// Example:
  /// ```dart
  /// TextStyle(fontSize: 16).withLineHeight(1.5)
  /// // Results in: fontSize: 16.sp, height: 1.5
  /// ```
  TextStyle withLineHeight(double lineHeight) {
    if (fontSize == null) {
      return copyWith(height: lineHeight);
    }

    return copyWith(fontSize: fontSize!.sp, height: lineHeight);
  }

  /// Creates a responsive [TextStyle] with automatic line height.
  ///
  /// This method scales the font size using `.sp` and applies a default
  /// line height multiplier if one is not already set.
  ///
  /// The default multiplier is 1.2, which provides good readability for
  /// most text. If the style already has a height set, it will be preserved.
  ///
  /// Example:
  /// ```dart
  /// TextStyle(fontSize: 16).withAutoLineHeight()
  /// // Results in: fontSize: 16.sp, height: 1.2 (if not already set)
  /// ```
  TextStyle withAutoLineHeight([double defaultMultiplier = 1.2]) {
    if (fontSize == null) {
      return copyWith(height: height ?? defaultMultiplier);
    }

    return copyWith(
      fontSize: fontSize!.sp,
      height: height ?? defaultMultiplier,
    );
  }

  /// Creates a responsive [TextStyle] with line height calculated from Figma values.
  ///
  /// This method is useful when you have absolute line height values from Figma
  /// and want to convert them to Flutter's height multiplier format.
  ///
  /// The calculation is: height = figmaLineHeight / figmaFontSize
  ///
  /// Example from Figma:
  /// - Font size: 20px
  /// - Line height: 14px
  /// - Calculation: height = 14 / 20 = 0.7
  ///
  /// ```dart
  /// TextStyle(fontSize: 20).withLineHeightFromFigma(14)
  /// // Results in: fontSize: 20.sp, height: 0.7
  /// ```
  ///
  /// If [figmaLineHeight] is not provided, it will use the default multiplier (1.2).
  ///
  /// If the style already has a height set, it will be preserved unless
  /// [overrideExisting] is true.
  TextStyle withLineHeightFromFigma(
    double figmaLineHeight, {
    bool overrideExisting = false,
  }) {
    if (fontSize == null) {
      throw ArgumentError(
        'Font size must be set to calculate line height from Figma values',
      );
    }

    // Calculate height multiplier: height = lineHeight / fontSize
    final double calculatedHeight = figmaLineHeight / fontSize!;

    // If height is already set and we shouldn't override, preserve it
    if (height != null && !overrideExisting) {
      return copyWith(fontSize: fontSize!.sp);
    }

    return copyWith(fontSize: fontSize!.sp, height: calculatedHeight);
  }
}

import 'package:flutter/material.dart';
import '../../flutter_screenutil_plus.dart';

/// Utility class for creating responsive themes.
///
/// [ResponsiveTheme] helps convert standard Flutter themes into responsive ones
/// by automatically scaling all text styles and other size-related properties.
class ResponsiveTheme {
  /// Creates a responsive [ThemeData] from the provided theme.
  ///
  /// All font sizes in [textTheme] will be scaled using `.sp`.
  static ThemeData fromTheme(ThemeData theme) {
    return theme.copyWith(
      textTheme: _scaleTextTheme(theme.textTheme),
      primaryTextTheme: _scaleTextTheme(theme.primaryTextTheme),
    );
  }

  /// Scales all text styles in a [TextTheme].
  static TextTheme _scaleTextTheme(TextTheme textTheme) {
    return TextTheme(
      displayLarge: _scaleTextStyle(textTheme.displayLarge),
      displayMedium: _scaleTextStyle(textTheme.displayMedium),
      displaySmall: _scaleTextStyle(textTheme.displaySmall),
      headlineLarge: _scaleTextStyle(textTheme.headlineLarge),
      headlineMedium: _scaleTextStyle(textTheme.headlineMedium),
      headlineSmall: _scaleTextStyle(textTheme.headlineSmall),
      titleLarge: _scaleTextStyle(textTheme.titleLarge),
      titleMedium: _scaleTextStyle(textTheme.titleMedium),
      titleSmall: _scaleTextStyle(textTheme.titleSmall),
      bodyLarge: _scaleTextStyle(textTheme.bodyLarge),
      bodyMedium: _scaleTextStyle(textTheme.bodyMedium),
      bodySmall: _scaleTextStyle(textTheme.bodySmall),
      labelLarge: _scaleTextStyle(textTheme.labelLarge),
      labelMedium: _scaleTextStyle(textTheme.labelMedium),
      labelSmall: _scaleTextStyle(textTheme.labelSmall),
    );
  }

  /// Scales the font size of a [TextStyle] using `.sp`.
  ///
  /// The height multiplier is preserved, ensuring line height scales
  /// proportionally with the font size.
  static TextStyle? _scaleTextStyle(TextStyle? style) {
    return style?.r;
  }
}

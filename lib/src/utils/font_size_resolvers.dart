import '../core/screen_util_plus.dart';

/// Abstract class providing static font size resolver functions.
///
/// These resolvers determine how font sizes are scaled based on different
/// screen dimensions. Each resolver uses a different scaling strategy from
/// [ScreenUtilPlus].
abstract class FontSizeResolvers {
  /// Resolves font size based on screen width.
  ///
  /// Uses [ScreenUtilPlus.setWidth] to scale the font size proportionally
  /// to the screen width.
  static double width(num fontSize, ScreenUtilPlus instance) {
    return instance.setWidth(fontSize);
  }

  /// Resolves font size based on screen height.
  ///
  /// Uses [ScreenUtilPlus.setHeight] to scale the font size proportionally
  /// to the screen height.
  static double height(num fontSize, ScreenUtilPlus instance) {
    return instance.setHeight(fontSize);
  }

  /// Resolves font size based on the smaller of width or height.
  ///
  /// Uses [ScreenUtilPlus.radius] to scale the font size based on the
  /// minimum dimension, ensuring consistent scaling for circular/square shapes.
  static double radius(num fontSize, ScreenUtilPlus instance) {
    return instance.radius(fontSize);
  }

  /// Resolves font size based on the maximum of width or height.
  ///
  /// Uses [ScreenUtilPlus.diameter] to scale the font size based on the
  /// maximum dimension.
  static double diameter(num fontSize, ScreenUtilPlus instance) {
    return instance.diameter(fontSize);
  }

  /// Resolves font size based on both width and height.
  ///
  /// Uses [ScreenUtilPlus.diagonal] to scale the font size using both
  /// width and height scaling factors.
  static double diagonal(num fontSize, ScreenUtilPlus instance) {
    return instance.diagonal(fontSize);
  }
}

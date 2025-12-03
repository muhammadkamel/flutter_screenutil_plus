import 'package:flutter/widgets.dart';

/// Common [RebuildFactor] implementations for controlling when widgets rebuild.
///
/// These functions can be used with [ScreenUtilPlusInit.rebuildFactor] to
/// control when responsive widgets should rebuild based on [MediaQueryData] changes.
abstract class RebuildFactors {
  /// Rebuilds when screen size changes.
  static bool size(MediaQueryData old, MediaQueryData data) {
    return old.size != data.size;
  }

  /// Rebuilds when screen orientation changes.
  static bool orientation(MediaQueryData old, MediaQueryData data) {
    return old.orientation != data.orientation;
  }

  /// Rebuilds when view insets change (e.g., keyboard appears).
  static bool sizeAndViewInsets(MediaQueryData old, MediaQueryData data) {
    return old.viewInsets != data.viewInsets;
  }

  /// Rebuilds when any [MediaQueryData] property changes.
  static bool change(MediaQueryData old, MediaQueryData data) {
    return old != data;
  }

  /// Always rebuilds, regardless of changes.
  static bool always(MediaQueryData _, MediaQueryData _) {
    return true;
  }

  /// Never rebuilds automatically.
  static bool none(MediaQueryData _, MediaQueryData _) {
    return false;
  }
}

import 'package:flutter/widgets.dart';

import '../extensions/context_extension.dart';

/// Size class system similar to SwiftUI's size classes.
///
/// Size classes provide a way to describe the approximate size of a view
/// in a way that's independent of the specific device or screen size.
///
/// - [compact]: A compact size class indicates a constrained space
/// - [regular]: A regular size class indicates a more expansive space
enum SizeClass {
  /// Compact size class - constrained space (e.g., iPhone in portrait)
  compact,

  /// Regular size class - expansive space (e.g., iPad, iPhone in landscape)
  regular,
}

/// Represents the size classes for both horizontal and vertical dimensions.
///
/// Similar to SwiftUI's `UserInterfaceSizeClass` which has both
/// horizontal and vertical size classes.
///
/// This class is immutable and can be safely used in equality comparisons.
@immutable
class SizeClasses {
  /// Creates size classes with the specified horizontal and vertical values.
  const SizeClasses({required this.horizontal, required this.vertical});

  /// Creates size classes from screen dimensions
  ///
  /// Uses standard thresholds:
  /// - Width < 600: compact horizontal
  /// - Width >= 600: regular horizontal
  /// - Height < 600: compact vertical
  /// - Height >= 600: regular vertical
  factory SizeClasses.fromSize(Size size, {double threshold = 600}) {
    return SizeClasses(
      horizontal: size.width >= threshold
          ? SizeClass.regular
          : SizeClass.compact,
      vertical: size.height >= threshold
          ? SizeClass.regular
          : SizeClass.compact,
    );
  }

  /// Creates size classes from MediaQuery
  factory SizeClasses.fromMediaQuery(
    MediaQueryData mediaQuery, {
    double threshold = 600,
  }) {
    return SizeClasses.fromSize(mediaQuery.size, threshold: threshold);
  }

  /// Horizontal size class
  final SizeClass horizontal;

  /// Vertical size class
  final SizeClass vertical;

  /// Checks if both dimensions are regular
  bool get isRegular =>
      horizontal == SizeClass.regular && vertical == SizeClass.regular;

  /// Checks if both dimensions are compact
  bool get isCompact =>
      horizontal == SizeClass.compact && vertical == SizeClass.compact;

  /// Checks if horizontal is regular
  bool get isRegularHorizontal => horizontal == SizeClass.regular;

  /// Checks if vertical is regular
  bool get isRegularVertical => vertical == SizeClass.regular;

  /// Checks if horizontal is compact
  bool get isCompactHorizontal => horizontal == SizeClass.compact;

  /// Checks if vertical is compact
  bool get isCompactVertical => vertical == SizeClass.compact;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeClasses &&
          runtimeType == other.runtimeType &&
          horizontal == other.horizontal &&
          vertical == other.vertical;

  @override
  int get hashCode => horizontal.hashCode ^ vertical.hashCode;

  @override
  String toString() =>
      'SizeClasses(horizontal: $horizontal, vertical: $vertical)';
}

/// Extension on [BuildContext] to easily access size classes
extension SizeClassExtension on BuildContext {
  /// Gets the current size classes from MediaQuery
  SizeClasses get sizeClasses {
    final MediaQueryData mediaQuery = mediaQueryData ?? const MediaQueryData();
    return SizeClasses.fromMediaQuery(mediaQuery);
  }

  /// Gets the horizontal size class
  SizeClass get horizontalSizeClass => sizeClasses.horizontal;

  /// Gets the vertical size class
  SizeClass get verticalSizeClass => sizeClasses.vertical;
}

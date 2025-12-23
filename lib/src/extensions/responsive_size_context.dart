import 'dart:math' show min;

import 'package:flutter/widgets.dart';

import '../core/screen_util_plus.dart';

/// Context-aware responsive sizing extensions.
///
/// These extensions register InheritedWidget dependencies and work
/// efficiently with `autoRebuild: false`.
///
/// Example:
/// ```dart
/// Container(
///   width: context.w(100),
///   height: context.h(50),
///   child: Text('Hello', style: TextStyle(fontSize: context.sp(16))),
/// )
/// ```
extension ResponsiveSizeContext on BuildContext {
  /// Get ScreenUtilPlus instance (registers InheritedWidget dependency)
  ScreenUtilPlus get _su => ScreenUtilPlus.of(this);

  // Width/Height

  /// Adapted width based on screen size.
  ///
  /// Equivalent to `ScreenUtilPlus.of(context).setWidth(value)`
  double w(num value) => _su.setWidth(value);

  /// Adapted height based on screen size.
  ///
  /// Equivalent to `ScreenUtilPlus.of(context).setHeight(value)`
  double h(num value) => _su.setHeight(value);

  // Radius/Diagonal/Diameter

  /// Adapted radius based on screen size.
  ///
  /// Uses the minimum of width and height scale factors.
  double r(num value) => _su.radius(value);

  /// Adapted diagonal based on screen size.
  double dg(num value) => _su.diagonal(value);

  /// Adapted diameter based on screen size.
  double dm(num value) => _su.diameter(value);

  // Font sizes

  /// Adapted font size based on screen size.
  ///
  /// Equivalent to `ScreenUtilPlus.of(context).setSp(value)`
  double sp(num value) => _su.setSp(value);

  /// Smart font size that never exceeds the original value.
  ///
  /// Returns the minimum of the original value and the scaled font size.
  /// Useful for maintaining size balance on larger screens.
  double spMin(num value) => min(value.toDouble(), sp(value));

  // Spacing helpers

  /// Creates a vertical space with adapted height.
  ///
  /// Equivalent to `SizedBox(height: context.h(height))`
  SizedBox verticalSpace(num height) => SizedBox(height: h(height));

  /// Creates a horizontal space with adapted width.
  ///
  /// Equivalent to `SizedBox(width: context.w(width))`
  SizedBox horizontalSpace(num width) => SizedBox(width: w(width));

  // EdgeInsets helper

  /// Creates adapted EdgeInsets.
  ///
  /// Example:
  /// ```dart
  /// padding: context.edgeInsets(all: 16)
  /// padding: context.edgeInsets(horizontal: 20, vertical: 10)
  /// padding: context.edgeInsets(left: 10, top: 20, right: 10, bottom: 20)
  /// ```
  EdgeInsets edgeInsets({
    num? all,
    num? horizontal,
    num? vertical,
    num? left,
    num? top,
    num? right,
    num? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(r(all));
    }
    return EdgeInsets.only(
      left: left != null ? w(left) : (horizontal != null ? w(horizontal) : 0),
      top: top != null ? h(top) : (vertical != null ? h(vertical) : 0),
      right: right != null
          ? w(right)
          : (horizontal != null ? w(horizontal) : 0),
      bottom: bottom != null ? h(bottom) : (vertical != null ? h(vertical) : 0),
    );
  }

  // BorderRadius helper

  /// Creates adapted BorderRadius.
  ///
  /// Example:
  /// ```dart
  /// borderRadius: context.borderRadius(all: 12)
  /// borderRadius: context.borderRadius(
  ///   topLeft: 12,
  ///   topRight: 12,
  ///   bottomLeft: 0,
  ///   bottomRight: 0,
  /// )
  /// ```
  BorderRadius borderRadius({
    num? all,
    num? topLeft,
    num? topRight,
    num? bottomLeft,
    num? bottomRight,
  }) {
    if (all != null) {
      return BorderRadius.circular(r(all));
    }
    return BorderRadius.only(
      topLeft: Radius.circular(r(topLeft ?? 0)),
      topRight: Radius.circular(r(topRight ?? 0)),
      bottomLeft: Radius.circular(r(bottomLeft ?? 0)),
      bottomRight: Radius.circular(r(bottomRight ?? 0)),
    );
  }
}

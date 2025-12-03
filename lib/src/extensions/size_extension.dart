import 'dart:math';

import 'package:flutter/material.dart';

import '../core/screen_util_plus.dart';

/// Extension on [num] to provide responsive sizing methods.
///
/// This extension adds convenient getters to numeric values for adapting
/// dimensions, spacing, and font sizes based on screen size. All methods
/// delegate to [ScreenUtilPlus] for the actual calculations.
///
/// Example usage:
/// ```dart
/// Container(
///   width: 100.w,  // Width adapted to screen
///   height: 50.h,  // Height adapted to screen
///   child: Text('Hello', style: TextStyle(fontSize: 16.sp)),
/// )
/// ```
extension SizeExtension on num {
  /// [ScreenUtilPlus.setWidth]
  double get w => ScreenUtilPlus().setWidth(this);

  /// [ScreenUtilPlus.setHeight]
  double get h => ScreenUtilPlus().setHeight(this);

  /// [ScreenUtilPlus.radius]
  double get r => ScreenUtilPlus().radius(this);

  /// [ScreenUtilPlus.diagonal]
  double get dg => ScreenUtilPlus().diagonal(this);

  /// [ScreenUtilPlus.diameter]
  double get dm => ScreenUtilPlus().diameter(this);

  /// [ScreenUtilPlus.setSp]
  double get sp => ScreenUtilPlus().setSp(this);

  /// Smart size: it checks your value - if it is bigger than your value it will set your value.
  /// For example, if you have set 16.sm, if for your screen 16.sp is bigger than 16, then it will set 16, not 16.sp.
  /// I think that it is good for saving size balance on big sizes of screen.
  double get spMin => min(toDouble(), sp);

  /// Returns the minimum of the original value and the scaled font size.
  ///
  /// This ensures that the font size never exceeds the original design value,
  /// which is useful for maintaining size balance on larger screens.
  ///
  /// Deprecated: Use [spMin] instead.
  @Deprecated('use spMin instead')
  double get sm => min(toDouble(), sp);

  /// Returns the maximum of the original value and the scaled font size.
  ///
  /// This ensures that the font size is at least as large as the original
  /// design value, which can be useful for ensuring minimum readability
  /// on smaller screens.
  double get spMax => max(toDouble(), sp);

  /// Multiple of screen width.
  double get sw => ScreenUtilPlus().screenWidth * this;

  /// Multiple of screen height.
  double get sh => ScreenUtilPlus().screenHeight * this;

  /// [ScreenUtilPlus.setHeight]
  SizedBox get verticalSpace => ScreenUtilPlus().setVerticalSpacing(this);

  /// [ScreenUtilPlus.setVerticalSpacingFromWidth]
  SizedBox get verticalSpaceFromWidth =>
      ScreenUtilPlus().setVerticalSpacingFromWidth(this);

  /// [ScreenUtilPlus.setWidth]
  SizedBox get horizontalSpace => ScreenUtilPlus().setHorizontalSpacing(this);

  /// [ScreenUtilPlus.radius]
  SizedBox get horizontalSpaceRadius =>
      ScreenUtilPlus().setHorizontalSpacingRadius(this);

  /// [ScreenUtilPlus.radius]
  SizedBox get verticalSpacingRadius =>
      ScreenUtilPlus().setVerticalSpacingRadius(this);

  /// [ScreenUtilPlus.diameter]
  SizedBox get horizontalSpaceDiameter =>
      ScreenUtilPlus().setHorizontalSpacingDiameter(this);

  /// [ScreenUtilPlus.diameter]
  SizedBox get verticalSpacingDiameter =>
      ScreenUtilPlus().setVerticalSpacingDiameter(this);

  /// [ScreenUtilPlus.diagonal]
  SizedBox get horizontalSpaceDiagonal =>
      ScreenUtilPlus().setHorizontalSpacingDiagonal(this);

  /// [ScreenUtilPlus.diagonal]
  SizedBox get verticalSpacingDiagonal =>
      ScreenUtilPlus().setVerticalSpacingDiagonal(this);
}

/// Extension on [EdgeInsets] to create responsive padding and margin values.
///
/// This extension provides methods to adapt edge insets based on screen size,
/// ensuring consistent spacing across different devices. Each method uses
/// a different scaling strategy (width, height, radius, diameter, or diagonal).
extension EdgeInsetsExtension on EdgeInsets {
  /// Creates adapt insets using r [SizeExtension].
  ///
  /// Adapts all edge insets using the `.r` extension, which scales based on
  /// the smaller of width or height. Ideal for maintaining consistent spacing
  /// that works well for both portrait and landscape orientations.
  EdgeInsets get r =>
      copyWith(top: top.r, bottom: bottom.r, right: right.r, left: left.r);

  /// Creates responsive insets using the `.dm` (diameter) extension.
  ///
  /// Adapts all edge insets using the diameter scaling method, which uses
  /// the maximum of scale width and scale height.
  EdgeInsets get dm =>
      copyWith(top: top.dm, bottom: bottom.dm, right: right.dm, left: left.dm);

  /// Creates responsive insets using the `.dg` (diagonal) extension.
  ///
  /// Adapts all edge insets using the diagonal scaling method, which uses
  /// both width and height scaling factors.
  EdgeInsets get dg =>
      copyWith(top: top.dg, bottom: bottom.dg, right: right.dg, left: left.dg);

  /// Creates responsive insets using the `.w` (width) extension.
  ///
  /// Adapts all edge insets based on screen width, ensuring consistent
  /// horizontal scaling across different devices.
  EdgeInsets get w =>
      copyWith(top: top.w, bottom: bottom.w, right: right.w, left: left.w);

  /// Creates responsive insets using the `.h` (height) extension.
  ///
  /// Adapts all edge insets based on screen height, ensuring consistent
  /// vertical scaling across different devices.
  EdgeInsets get h =>
      copyWith(top: top.h, bottom: bottom.h, right: right.h, left: left.h);
}

/// Extension on [BorderRadius] to create responsive border radius values.
///
/// This extension provides methods to adapt border radius values based on
/// screen size, ensuring consistent appearance across different devices.
extension BorderRadiusExtension on BorderRadius {
  /// Creates a responsive [BorderRadius] using the `.r` extension.
  ///
  /// The `.r` extension adapts values based on the smaller of width or height,
  /// which is ideal for creating circular or square shapes that maintain their
  /// aspect ratio across different screen sizes.
  ///
  /// Example:
  /// ```dart
  /// BorderRadius.circular(16).r
  /// ```
  BorderRadius get r => copyWith(
    bottomLeft: bottomLeft.r,
    bottomRight: bottomRight.r,
    topLeft: topLeft.r,
    topRight: topRight.r,
  );

  /// Creates a responsive [BorderRadius] using the `.w` extension.
  ///
  /// The `.w` extension adapts values based on screen width, ensuring
  /// consistent horizontal scaling across different devices.
  ///
  /// Example:
  /// ```dart
  /// BorderRadius.circular(16).w
  /// ```
  BorderRadius get w => copyWith(
    bottomLeft: bottomLeft.w,
    bottomRight: bottomRight.w,
    topLeft: topLeft.w,
    topRight: topRight.w,
  );

  /// Creates a responsive [BorderRadius] using the `.h` extension.
  ///
  /// The `.h` extension adapts values based on screen height, ensuring
  /// consistent vertical scaling across different devices.
  ///
  /// Example:
  /// ```dart
  /// BorderRadius.circular(16).h
  /// ```
  BorderRadius get h => copyWith(
    bottomLeft: bottomLeft.h,
    bottomRight: bottomRight.h,
    topLeft: topLeft.h,
    topRight: topRight.h,
  );
}

/// Extension on [Radius] to create responsive radius values.
///
/// This extension provides methods to adapt radius values based on screen size,
/// ensuring consistent border radius appearance across different devices.
/// Each method uses a different scaling strategy for the elliptical radius.
extension RadiusExtension on Radius {
  /// Creates adapt Radius using r [SizeExtension].
  ///
  /// Adapts both x and y radius values using the `.r` extension, which scales
  /// based on the smaller of width or height. Ideal for maintaining circular
  /// or square shapes across different screen sizes.
  Radius get r => Radius.elliptical(x.r, y.r);

  /// Creates responsive radius using the `.dm` (diameter) extension.
  ///
  /// Adapts both x and y radius values using the diameter scaling method,
  /// which uses the maximum of scale width and scale height.
  Radius get dm => Radius.elliptical(x.dm, y.dm);

  /// Creates responsive radius using the `.dg` (diagonal) extension.
  ///
  /// Adapts both x and y radius values using the diagonal scaling method,
  /// which uses both width and height scaling factors.
  Radius get dg => Radius.elliptical(x.dg, y.dg);

  /// Creates responsive radius using the `.w` (width) extension.
  ///
  /// Adapts both x and y radius values based on screen width, ensuring
  /// consistent horizontal scaling.
  Radius get w => Radius.elliptical(x.w, y.w);

  /// Creates responsive radius using the `.h` (height) extension.
  ///
  /// Adapts both x and y radius values based on screen height, ensuring
  /// consistent vertical scaling.
  Radius get h => Radius.elliptical(x.h, y.h);
}

/// Extension on [BoxConstraints] to create responsive constraint values.
///
/// This extension provides methods to adapt box constraints based on screen size,
/// ensuring consistent layout behavior across different devices.
extension BoxConstraintsExtension on BoxConstraints {
  /// Creates responsive [BoxConstraints] using the `.r` extension.
  ///
  /// The `.r` extension adapts values based on the smaller of width or height,
  /// which is ideal for maintaining aspect ratios.
  ///
  /// Example:
  /// ```dart
  /// BoxConstraints(maxWidth: 100, minHeight: 50).r
  /// ```
  BoxConstraints get r => copyWith(
    maxHeight: maxHeight.r,
    maxWidth: maxWidth.r,
    minHeight: minHeight.r,
    minWidth: minWidth.r,
  );

  /// Creates responsive [BoxConstraints] using height-width adaptation.
  ///
  /// Height values use `.h` extension and width values use `.w` extension,
  /// providing independent scaling for vertical and horizontal dimensions.
  ///
  /// Example:
  /// ```dart
  /// BoxConstraints(maxWidth: 100, minHeight: 50).hw
  /// ```
  BoxConstraints get hw => copyWith(
    maxHeight: maxHeight.h,
    maxWidth: maxWidth.w,
    minHeight: minHeight.h,
    minWidth: minWidth.w,
  );

  /// Creates responsive [BoxConstraints] using the `.w` extension.
  ///
  /// All constraint values are adapted based on screen width.
  ///
  /// Example:
  /// ```dart
  /// BoxConstraints(maxWidth: 100, minHeight: 50).w
  /// ```
  BoxConstraints get w => copyWith(
    maxHeight: maxHeight.w,
    maxWidth: maxWidth.w,
    minHeight: minHeight.w,
    minWidth: minWidth.w,
  );

  /// Creates responsive [BoxConstraints] using the `.h` extension.
  ///
  /// All constraint values are adapted based on screen height.
  ///
  /// Example:
  /// ```dart
  /// BoxConstraints(maxWidth: 100, minHeight: 50).h
  /// ```
  BoxConstraints get h => copyWith(
    maxHeight: maxHeight.h,
    maxWidth: maxWidth.h,
    minHeight: minHeight.h,
    minWidth: minWidth.h,
  );
}

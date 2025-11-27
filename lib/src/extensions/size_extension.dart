import 'dart:math';

import 'package:flutter/material.dart';

import '../core/screen_util_plus.dart';

extension SizeExtension on num {
  ///[ScreenUtilPlus.setWidth]
  double get w => ScreenUtilPlus().setWidth(this);

  ///[ScreenUtilPlus.setHeight]
  double get h => ScreenUtilPlus().setHeight(this);

  ///[ScreenUtilPlus.radius]
  double get r => ScreenUtilPlus().radius(this);

  ///[ScreenUtilPlus.diagonal]
  double get dg => ScreenUtilPlus().diagonal(this);

  ///[ScreenUtilPlus.diameter]
  double get dm => ScreenUtilPlus().diameter(this);

  ///[ScreenUtilPlus.setSp]
  double get sp => ScreenUtilPlus().setSp(this);

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get spMin => min(toDouble(), sp);

  @Deprecated('use spMin instead')
  double get sm => min(toDouble(), sp);

  double get spMax => max(toDouble(), sp);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => ScreenUtilPlus().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => ScreenUtilPlus().screenHeight * this;

  ///[ScreenUtilPlus.setHeight]
  SizedBox get verticalSpace => ScreenUtilPlus().setVerticalSpacing(this);

  ///[ScreenUtilPlus.setVerticalSpacingFromWidth]
  SizedBox get verticalSpaceFromWidth =>
      ScreenUtilPlus().setVerticalSpacingFromWidth(this);

  ///[ScreenUtilPlus.setWidth]
  SizedBox get horizontalSpace => ScreenUtilPlus().setHorizontalSpacing(this);

  ///[ScreenUtilPlus.radius]
  SizedBox get horizontalSpaceRadius =>
      ScreenUtilPlus().setHorizontalSpacingRadius(this);

  ///[ScreenUtilPlus.radius]
  SizedBox get verticalSpacingRadius =>
      ScreenUtilPlus().setVerticalSpacingRadius(this);

  ///[ScreenUtilPlus.diameter]
  SizedBox get horizontalSpaceDiameter =>
      ScreenUtilPlus().setHorizontalSpacingDiameter(this);

  ///[ScreenUtilPlus.diameter]
  SizedBox get verticalSpacingDiameter =>
      ScreenUtilPlus().setVerticalSpacingDiameter(this);

  ///[ScreenUtilPlus.diagonal]
  SizedBox get horizontalSpaceDiagonal =>
      ScreenUtilPlus().setHorizontalSpacingDiagonal(this);

  ///[ScreenUtilPlus.diagonal]
  SizedBox get verticalSpacingDiagonal =>
      ScreenUtilPlus().setVerticalSpacingDiagonal(this);
}

extension EdgeInsetsExtension on EdgeInsets {
  /// Creates adapt insets using r [SizeExtension].
  EdgeInsets get r =>
      copyWith(top: top.r, bottom: bottom.r, right: right.r, left: left.r);

  EdgeInsets get dm =>
      copyWith(top: top.dm, bottom: bottom.dm, right: right.dm, left: left.dm);

  EdgeInsets get dg =>
      copyWith(top: top.dg, bottom: bottom.dg, right: right.dg, left: left.dg);

  EdgeInsets get w =>
      copyWith(top: top.w, bottom: bottom.w, right: right.w, left: left.w);

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

extension RadiusExtension on Radius {
  /// Creates adapt Radius using r [SizeExtension].
  Radius get r => Radius.elliptical(x.r, y.r);

  Radius get dm => Radius.elliptical(x.dm, y.dm);

  Radius get dg => Radius.elliptical(x.dg, y.dg);

  Radius get w => Radius.elliptical(x.w, y.w);

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

import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../extensions/size_extension.dart';

/// A responsive container widget that automatically scales dimensions.
///
/// [RContainer] is similar to [Container] but automatically applies responsive
/// scaling to width, height, padding, margin, and constraints using the
/// `.w`, `.h`, and `.r` extensions.
class RContainer extends StatelessWidget {
  /// Creates a responsive container with the given properties.
  const RContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// How to align the child.
  final AlignmentGeometry? alignment;

  /// Empty space to inscribe inside the decorated container.
  final EdgeInsetsGeometry? padding;

  /// The color to paint behind the child.
  final Color? color;

  /// The decoration to paint behind the child.
  final Decoration? decoration;

  /// The decoration to paint in front of the child.
  final Decoration? foregroundDecoration;

  /// Additional constraints to apply to the child.
  final BoxConstraints? constraints;

  /// Empty space to surround the decorated container.
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  final Matrix4? transform;

  /// The alignment of the origin, relative to the size of the container.
  final AlignmentGeometry? transformAlignment;

  /// The clip behavior when [decoration] is not null.
  final Clip clipBehavior;

  /// The width of the container (will be scaled using `.w` extension).
  final double? width;

  /// The height of the container (will be scaled using `.h` extension).
  final double? height;

  @override
  Widget build(BuildContext context) {
    // Register dependency on ScreenUtilPlusScope for efficient reactivity
    context.su;

    return Container(
      key: key,
      alignment: alignment,
      padding: padding is EdgeInsets ? (padding! as EdgeInsets).r : padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width?.w,
      height: height?.h,
      constraints: constraints?.r,
      margin: margin is EdgeInsets ? (margin! as EdgeInsets).r : margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

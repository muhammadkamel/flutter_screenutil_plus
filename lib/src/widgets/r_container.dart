import 'package:flutter/material.dart';

import '../extensions/size_extension.dart';

class RContainer extends StatelessWidget {
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

  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding is EdgeInsets ? (padding as EdgeInsets).r : padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width?.w,
      height: height?.h,
      constraints: constraints?.r,
      margin: margin is EdgeInsets ? (margin as EdgeInsets).r : margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

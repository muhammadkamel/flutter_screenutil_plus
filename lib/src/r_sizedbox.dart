import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'size_extension.dart';

class RSizedBox extends SizedBox {
  const RSizedBox({super.key, super.height, super.width, super.child})
    : _square = false;

  const RSizedBox.vertical(double? height, {super.key, super.child})
    : _square = false,
      super(height: height);

  const RSizedBox.horizontal(double? width, {super.key, super.child})
    : _square = false,
      super(width: width);

  const RSizedBox.square({
    super.key,
    double? height,
    super.dimension,
    super.child,
  }) : _square = true,
       super.square();

  RSizedBox.fromSize({super.key, super.size, super.child})
    : _square = false,
      super.fromSize();

  @override
  RenderConstrainedBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(additionalConstraints: _additionalConstraints);
  }

  final bool _square;

  BoxConstraints get _additionalConstraints {
    final boxConstraints = BoxConstraints.tightFor(
      width: width,
      height: height,
    );
    return _square ? boxConstraints.r : boxConstraints.hw;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderConstrainedBox renderObject,
  ) {
    renderObject.additionalConstraints = _additionalConstraints;
  }
}

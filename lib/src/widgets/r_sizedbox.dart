import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../extensions/size_extension.dart';

/// A responsive [SizedBox] that automatically scales dimensions.
///
/// [RSizedBox] is similar to [SizedBox] but automatically applies responsive
/// scaling to width and height using the `.w` and `.h` extensions.
class RSizedBox extends SizedBox {
  /// Creates a responsive sized box with optional width and height.
  const RSizedBox({super.key, super.height, super.width, super.child})
    : _square = false;

  /// Creates a responsive sized box with a fixed height.
  const RSizedBox.vertical(double? height, {super.key, super.child})
    : _square = false,
      super(height: height);

  /// Creates a responsive sized box with a fixed width.
  const RSizedBox.horizontal(double? width, {super.key, super.child})
    : _square = false,
      super(width: width);

  /// Creates a responsive square sized box.
  const RSizedBox.square({super.key, super.dimension, super.child})
    : _square = true,
      super.square();

  /// Creates a responsive sized box from a [Size].
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

import 'package:flutter/widgets.dart';

/// Extension on [MediaQueryData] to check if size is non-empty.
extension MediaQueryDataExtension on MediaQueryData? {
  /// Returns the [MediaQueryData] if it has a non-empty size, otherwise null.
  MediaQueryData? nonEmptySizeOrNull() {
    if (this?.size.isEmpty ?? true) {
      return null;
    }
    return this;
  }
}

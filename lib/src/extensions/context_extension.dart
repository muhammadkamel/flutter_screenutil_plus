import 'package:flutter/widgets.dart';

/// Extension on [BuildContext] to provide robust access to [MediaQueryData].
extension ScreenUtilContextExtension on BuildContext {
  /// Robustly retrieves MediaQueryData.
  /// Checks MediaQuery.maybeOf(context) first.
  /// If null, checks View.maybeOf(context).
  /// Returns null if neither are available.
  MediaQueryData? get mediaQueryData {
    return MediaQuery.maybeOf(this) ??
        (View.maybeOf(this) != null
            ? MediaQueryData.fromView(View.maybeOf(this)!)
            : null);
  }
}

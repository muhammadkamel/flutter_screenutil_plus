import 'package:flutter/widgets.dart';

import '../core/screen_util_plus.dart';

/// Extension on [BuildContext] to provide robust access to [MediaQueryData]
/// and [ScreenUtilPlus].
extension ScreenUtilContextExtension on BuildContext {
  /// Retrieves MediaQueryData from the nearest MediaQuery ancestor.
  ///
  /// Returns null if no MediaQuery is found in the widget tree.
  MediaQueryData? get mediaQueryData => MediaQuery.maybeOf(this);

  /// Returns the nearest [ScreenUtilPlus] instance and registers this
  /// context for rebuilds when screen metrics change.
  ScreenUtilPlus get su => ScreenUtilPlus.of(this);
}

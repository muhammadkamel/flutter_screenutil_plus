import 'package:flutter/widgets.dart';

import 'screen_util_plus.dart';

/// An [InheritedWidget] that provides [ScreenUtilPlus] configuration to the
/// widget tree and triggers rebuilds when screen metrics change.
class ScreenUtilPlusScope extends InheritedWidget {
  /// Creates a [ScreenUtilPlusScope].
  const ScreenUtilPlusScope({
    super.key,
    required this.metrics,
    required super.child,
  });

  /// The current screen metrics.
  final Object? metrics;

  /// Returns the nearest [ScreenUtilPlus] instance and registers the
  /// context for rebuilds when metrics change.
  static ScreenUtilPlus? maybeOf(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<ScreenUtilPlusScope>();
    return ScreenUtilPlus();
  }

  /// Returns the nearest [ScreenUtilPlus] instance and registers the
  /// context for rebuilds when metrics change.
  ///
  /// Throws an error if no [ScreenUtilPlusScope] is found in the tree.
  static ScreenUtilPlus of(BuildContext context) {
    final ScreenUtilPlus? result = maybeOf(context);
    assert(result != null, 'No ScreenUtilPlusScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ScreenUtilPlusScope oldWidget) {
    return metrics != oldWidget.metrics;
  }
}

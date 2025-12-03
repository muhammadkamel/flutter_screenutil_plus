import 'package:flutter/widgets.dart';

/// A function type for building widgets in [ScreenUtilPlusInit].
///
/// This builder receives the [BuildContext] and optional [child] widget,
/// allowing custom widget tree construction during initialization.
typedef ScreenUtilInitBuilder =
    Widget Function(BuildContext context, Widget? child);

import 'package:flutter/widgets.dart';

/// A mixin that marks a widget as responsive.
///
/// Widgets that use this mixin will automatically be rebuilt when screen
/// metrics change in [ScreenUtilPlusInit]. This is useful for custom widgets
/// that need to respond to screen size changes.
mixin SU on Widget {}

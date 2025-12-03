import 'package:flutter/widgets.dart';

/// A function type that determines when widgets should rebuild based on
/// changes in [MediaQueryData].
///
/// The function receives the old and new [MediaQueryData] and returns `true`
/// if widgets should rebuild, or `false` otherwise.
///
/// See [RebuildFactors] for common implementations.
typedef RebuildFactor = bool Function(MediaQueryData old, MediaQueryData data);

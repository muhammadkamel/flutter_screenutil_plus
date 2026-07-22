import 'package:flutter/widgets.dart';

/// Publishes the nearest parent's layout constraints as a [Size] for
/// responsive APIs ([ResponsiveQuery], builders, etc.).
///
/// Outside a [LayoutScope], those APIs continue to use the viewport
/// [MediaQuery] size. Nested scopes use the nearest ancestor.
///
/// Example:
/// ```dart
/// LayoutScope(
///   child: ResponsiveBuilder(
///     xs: (_) => const CompactView(),
///     md: (_) => const ExpandedView(),
///   ),
/// );
/// ```
class LayoutScope extends StatelessWidget {
  /// Creates a [LayoutScope] that exposes local constraints to descendants.
  const LayoutScope({super.key, required this.child});

  /// The widget subtree that should use container-based metrics.
  final Widget child;

  /// The size from the nearest [LayoutScope], or `null` if none exists.
  ///
  /// Registers a dependency so the calling context rebuilds when the
  /// published size changes.
  static Size? maybeSizeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LayoutScope>()?.size;
  }

  /// Resolves the size used for responsive queries: layout scope if present,
  /// otherwise the viewport [MediaQuery] size.
  static Size sizeOf(BuildContext context) {
    return maybeSizeOf(context) ?? MediaQuery.maybeSizeOf(context) ?? Size.zero;
  }

  static Size _resolveSize(BuildContext context, BoxConstraints constraints) {
    final Size viewport = MediaQuery.maybeSizeOf(context) ?? Size.zero;
    return Size(
      constraints.hasBoundedWidth ? constraints.maxWidth : viewport.width,
      constraints.hasBoundedHeight ? constraints.maxHeight : viewport.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _LayoutScope(
          size: _resolveSize(context, constraints),
          child: child,
        );
      },
    );
  }
}

class _LayoutScope extends InheritedWidget {
  const _LayoutScope({required this.size, required super.child});

  final Size size;

  @override
  bool updateShouldNotify(_LayoutScope oldWidget) => size != oldWidget.size;
}

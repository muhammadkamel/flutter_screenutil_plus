import 'package:flutter/widgets.dart';

import '../core/layout_scope.dart';
import '../utils/breakpoints.dart';
import '../utils/responsive_query.dart';

/// A 12-column responsive layout grid that adapts to different screen sizes.
///
/// Wraps its content in a [LayoutScope] so column spans and item widths are
/// resolved from the same local constraints (not the viewport alone).
class ResponsiveGrid extends StatelessWidget {
  /// Creates a responsive grid layout.
  ///
  /// The [children] must be a list of [ResponsiveGridItem]s.
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  /// The items to display in the grid.
  final List<ResponsiveGridItem> children;

  /// How much space to place between children in a run in the main axis.
  final double spacing;

  /// How much space to place between the runs themselves in the cross axis.
  final double runSpacing;

  /// How the children within a run should be placed in the main axis.
  final WrapAlignment alignment;

  /// How the runs themselves should be placed in the cross axis.
  final WrapAlignment runAlignment;

  /// How the children within a run should be aligned relative to each other in the cross axis.
  final WrapCrossAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutScope(
      child: Builder(
        builder: (BuildContext context) {
          final query = ResponsiveQuery.of(context);
          final double maxWidth = query.width;
          final Breakpoint currentBreakpoint = query.breakpoint;

          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: alignment,
            runAlignment: runAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children.map((ResponsiveGridItem item) {
              final int span = _getSpanForBreakpoint(item, currentBreakpoint);
              // Fit `span/12` of the row so that items totaling 12 columns plus
              // Wrap spacing fill [maxWidth] exactly (avoids negative widths when
              // spacing is large relative to the container).
              final double itemWidth =
                  (maxWidth + spacing) * span / 12.0 - spacing;

              return SizedBox(
                width: itemWidth.clamp(0.0, maxWidth),
                child: item.child,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  int _getSpanForBreakpoint(ResponsiveGridItem item, Breakpoint breakpoint) {
    return switch (breakpoint) {
      Breakpoint.xs => item.xs ?? 12, // Default to full width on mobile
      Breakpoint.sm => item.sm ?? item.xs ?? 12,
      Breakpoint.md => item.md ?? item.sm ?? item.xs ?? 12,
      Breakpoint.lg => item.lg ?? item.md ?? item.sm ?? item.xs ?? 12,
      Breakpoint.xl =>
        item.xl ?? item.lg ?? item.md ?? item.sm ?? item.xs ?? 12,
      Breakpoint.xxl =>
        item.xxl ?? item.xl ?? item.lg ?? item.md ?? item.sm ?? item.xs ?? 12,
    };
  }
}

/// An item within a [ResponsiveGrid].
///
/// Defines the column span (out of 12) for each breakpoint.
class ResponsiveGridItem {
  /// Creates a responsive grid item.
  ///
  /// If a span is not specified for a breakpoint, it falls back to the
  /// span of the next smaller breakpoint. If no generic spans are defined,
  /// it defaults to 12 (full width).
  const ResponsiveGridItem({
    required this.child,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  }) : assert(
         xs == null || (xs > 0 && xs <= 12),
         'Span must be between 1 and 12',
       ),
       assert(
         sm == null || (sm > 0 && sm <= 12),
         'Span must be between 1 and 12',
       ),
       assert(
         md == null || (md > 0 && md <= 12),
         'Span must be between 1 and 12',
       ),
       assert(
         lg == null || (lg > 0 && lg <= 12),
         'Span must be between 1 and 12',
       ),
       assert(
         xl == null || (xl > 0 && xl <= 12),
         'Span must be between 1 and 12',
       ),
       assert(
         xxl == null || (xxl > 0 && xxl <= 12),
         'Span must be between 1 and 12',
       );

  /// The widget to display within the grid item.
  final Widget child;

  /// The integer column span out of 12 for the extra small breakpoint.
  final int? xs;

  /// The integer column span out of 12 for the small breakpoint.
  final int? sm;

  /// The integer column span out of 12 for the medium breakpoint.
  final int? md;

  /// The integer column span out of 12 for the large breakpoint.
  final int? lg;

  /// The integer column span out of 12 for the extra large breakpoint.
  final int? xl;

  /// The integer column span out of 12 for the extra extra large breakpoint.
  final int? xxl;
}

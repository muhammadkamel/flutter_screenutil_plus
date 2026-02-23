import 'package:flutter/widgets.dart';

import '../utils/breakpoints.dart';
import '../utils/responsive_query.dart';

/// A 12-column responsive layout grid that adapts to different screen sizes.
///
/// Uses [ResponsiveQuery] to determine the current [Breakpoint] and
/// configures the column span for each item based on the current breakpoint.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final Breakpoint currentBreakpoint = ResponsiveQuery.of(
          context,
        ).breakpoint;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: alignment,
          runAlignment: runAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children.map((item) {
            final int span = _getSpanForBreakpoint(item, currentBreakpoint);

            // 12 column grid system
            // Calculate the width for a single column, considering the spacing.
            // If there are 'n' items in a row, there are 'n-1' spacings.
            // The maximum number of items in a row is 12 (if all span 1).
            // So, the total width for 12 columns, including 11 spacings, is maxWidth.
            // (12 * columnWidth) + (11 * spacing) = maxWidth
            // columnWidth = (maxWidth - (11 * spacing)) / 12
            // However, the Wrap widget handles the spacing.
            // So, we just need to calculate the width of the item itself.
            // The Wrap widget will then add the spacing between these items.
            // The total width available for the items in a run is maxWidth.
            // If we have 'N' items in a run, and 'N-1' spacings,
            // the total width consumed by items is maxWidth - (N-1)*spacing.
            // Each item's width should be proportional to its span.
            // A simpler approach is to calculate the width of a single "grid unit"
            // and multiply by the span.
            // The Wrap widget will then add the spacing.
            // The total width available for the content of the items in a row
            // is maxWidth minus the total spacing that will be applied in that row.
            final double totalContentWidth = maxWidth - (11 * spacing);
            final double columnUnitWidth = totalContentWidth / 12;
            final double itemWidth = columnUnitWidth * span;

            return SizedBox(
              width: itemWidth.clamp(0.0, double.infinity),
              child: item.child,
            );
          }).toList(),
        );
      },
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

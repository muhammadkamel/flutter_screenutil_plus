import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:material_ui/material_ui.dart';

/// Demo page for [LayoutScope] — container-aware responsive metrics.
class LayoutScopeDemoPage extends StatefulWidget {
  const LayoutScopeDemoPage({super.key});

  @override
  State<LayoutScopeDemoPage> createState() => _LayoutScopeDemoPageState();
}

class _LayoutScopeDemoPageState extends State<LayoutScopeDemoPage> {
  double _paneWidth = 320;

  @override
  Widget build(BuildContext context) {
    final Breakpoint viewportBreakpoint = context.breakpoint;

    return Scaffold(
      appBar: AppBar(title: const Text('LayoutScope Demo'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(viewportBreakpoint),
            20.verticalSpace,
            _buildPaneWidthSlider(),
            20.verticalSpace,
            _buildComparison(viewportBreakpoint),
            20.verticalSpace,
            _buildNestedDemo(),
            20.verticalSpace,
            _buildGridDemo(),
            20.verticalSpace,
            _buildUsageSnippet(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Breakpoint viewportBreakpoint) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.view_sidebar, size: 32.sp, color: Colors.white),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  'Container-aware layouts',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'Wrap a pane in LayoutScope so ResponsiveBuilder and friends '
            'use local constraints — not the full viewport '
            '(${viewportBreakpoint.name.toUpperCase()} here).',
            style: TextStyle(fontSize: 14.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPaneWidthSlider() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.teal.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pane width: ${_paneWidth.round()} dp',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          Text(
            'Drag to simulate a sidebar / split pane. Watch the pane breakpoint '
            'change while the viewport stays the same.',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
          ),
          Slider(
            value: _paneWidth,
            min: 280,
            max: 900,
            divisions: 31,
            label: '${_paneWidth.round()}',
            onChanged: (value) => setState(() => _paneWidth = value),
          ),
        ],
      ),
    );
  }

  Widget _buildComparison(Breakpoint viewportBreakpoint) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Viewport vs LayoutScope',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          _metricCard(
            title: 'Viewport (no scope)',
            subtitle: 'Breakpoint: ${viewportBreakpoint.name.toUpperCase()}',
            color: Colors.indigo,
            child: ResponsiveBuilder(
              xs: (_) => _layoutChip('XS', Colors.red),
              sm: (_) => _layoutChip('SM', Colors.orange),
              md: (_) => _layoutChip('MD', Colors.green),
              lg: (_) => _layoutChip('LG', Colors.blue),
              xl: (_) => _layoutChip('XL', Colors.purple),
              xxl: (_) => _layoutChip('XXL', Colors.teal),
            ),
          ),
          16.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: _paneWidth,
              child: LayoutScope(
                child: Builder(
                  builder: (context) {
                    final Breakpoint paneBp = context.breakpoint;
                    return _metricCard(
                      title: 'Pane (LayoutScope)',
                      subtitle:
                          'Width ${_paneWidth.round()} → ${paneBp.name.toUpperCase()}',
                      color: Colors.teal,
                      child: ResponsiveBuilder(
                        xs: (_) => _layoutChip('XS pane', Colors.red),
                        sm: (_) => _layoutChip('SM pane', Colors.orange),
                        md: (_) => _layoutChip('MD pane', Colors.green),
                        lg: (_) => _layoutChip('LG pane', Colors.blue),
                        xl: (_) => _layoutChip('XL pane', Colors.purple),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNestedDemo() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.deepPurple.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nested scopes',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          Text(
            'Nearest LayoutScope wins for descendants.',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
          ),
          12.verticalSpace,
          SizedBox(
            height: 100,
            child: LayoutScope(
              child: ColoredBox(
                color: Colors.deepPurple.shade100,
                child: Row(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final Breakpoint bp = context.breakpoint;
                          return Center(
                            child: _paneChip(
                              'Outer ${bp.name.toUpperCase()}',
                              Colors.deepPurple,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: LayoutScope(
                        child: Builder(
                          builder: (context) {
                            final Breakpoint bp = context.breakpoint;
                            return ColoredBox(
                              color: Colors.amber.shade100,
                              child: Center(
                                child: _paneChip(
                                  'Inner ${bp.name.toUpperCase()}',
                                  Colors.amber.shade800,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridDemo() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.cyan.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ResponsiveGrid in a narrow pane',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          Text(
            'Spans follow the pane width (xs → full width), not the desktop viewport.',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
          ),
          12.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: _paneWidth.clamp(280, 420).toDouble(),
              child: ResponsiveGrid(
                // Use unscaled spacing so viewport .w does not collapse a narrow pane.
                spacing: 8,
                runSpacing: 8,
                children: [
                  ResponsiveGridItem(
                    xs: 12,
                    md: 6,
                    lg: 4,
                    child: _paneGridCell('A', Colors.indigo),
                  ),
                  ResponsiveGridItem(
                    xs: 12,
                    md: 6,
                    lg: 4,
                    child: _paneGridCell('B', Colors.teal),
                  ),
                  ResponsiveGridItem(
                    xs: 12,
                    md: 12,
                    lg: 4,
                    child: _paneGridCell('C', Colors.orange),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageSnippet() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          10.verticalSpace,
          Text(
            'LayoutScope(\n'
            '  child: ResponsiveBuilder(\n'
            '    xs: (_) => CompactView(),\n'
            '    md: (_) => ExpandedView(),\n'
            '  ),\n'
            ');',
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'monospace',
              color: Colors.greenAccent.shade100,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String subtitle,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          4.verticalSpace,
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
          ),
          10.verticalSpace,
          child,
        ],
      ),
    );
  }

  Widget _layoutChip(String label, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Fixed logical sizes for pane demos (viewport .sp/.w would overflow narrow scopes).
  Widget _paneChip(String label, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _gridCell(String label, Color color) {
    return Container(
      height: 48.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _paneGridCell(String label, Color color) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

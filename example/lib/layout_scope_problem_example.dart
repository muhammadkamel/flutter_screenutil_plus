import 'package:material_ui/material_ui.dart';

/// Pure Flutter demo of the container-vs-viewport bug.
///
/// Intentionally does **not** import `flutter_screenutil_plus`.
/// It shows why deciding layouts from [MediaQuery] size alone fails inside
/// sidebars, split panes, and nested regions.
class LayoutScopeProblemExample extends StatefulWidget {
  const LayoutScopeProblemExample({super.key});

  @override
  State<LayoutScopeProblemExample> createState() =>
      _LayoutScopeProblemExampleState();
}

class _LayoutScopeProblemExampleState extends State<LayoutScopeProblemExample> {
  double _paneWidth = 320;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.sizeOf(context);
    final String viewportBp = bootstrapBreakpoint(viewport.width);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Before: MediaQuery only'),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            problemCallout(
              color: Colors.red,
              title: 'The problem (no LayoutScope)',
              body:
                  'Many apps pick mobile vs desktop UI from MediaQuery.size. '
                  'That is the window size — not the width of a sidebar or split pane. '
                  'This page uses only Flutter APIs (no flutter_screenutil_plus).',
            ),
            const SizedBox(height: 16),
            problemCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pane width: ${_paneWidth.round()} dp',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Drag to shrink a “sidebar”. The viewport breakpoint stays '
                    'the same; watch the pane wrongly keep that breakpoint.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
                  ),
                  Slider(
                    value: _paneWidth,
                    min: 280,
                    max: 900,
                    divisions: 31,
                    activeColor: Colors.red.shade400,
                    label: '${_paneWidth.round()}',
                    onChanged: (v) => setState(() => _paneWidth = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            problemCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Viewport (correct for the window)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'MediaQuery width ${viewport.width.round()} → $viewportBp',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(height: 12),
                  layoutBanner(
                    label: '$viewportBp layout',
                    color: colorForBreakpoint(viewportBp),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            problemCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Narrow pane using MediaQuery (wrong)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This pane is constrained, but the builder still reads '
                    'MediaQuery.size — so it chooses a desktop layout inside '
                    'a phone-sized box.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: _paneWidth,
                      child: MediaQueryOnlyPaneLayout(paneWidth: _paneWidth),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            problemCallout(
              color: Colors.orange,
              title: 'Takeaway',
              body:
                  'Hand-rolling LayoutBuilder everywhere duplicates breakpoint '
                  'logic and is easy to get wrong in nested panes. '
                  'Compare with “After: LayoutScope”.',
            ),
          ],
        ),
      ),
    );
  }
}

/// Layout chosen from [MediaQuery] only — incorrect inside a narrow parent.
class MediaQueryOnlyPaneLayout extends StatelessWidget {
  const MediaQueryOnlyPaneLayout({super.key, required this.paneWidth});

  final double paneWidth;

  @override
  Widget build(BuildContext context) {
    // BUG: ignores [paneWidth] / parent constraints; uses full window size.
    final double mediaWidth = MediaQuery.sizeOf(context).width;
    final String bp = bootstrapBreakpoint(mediaWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.red.shade50,
          child: Text(
            'Pane is ${paneWidth.round()} dp, but MediaQuery is '
            '${mediaWidth.round()} → $bp',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade900,
            ),
          ),
        ),
        const SizedBox(height: 8),
        layoutBanner(
          label: '$bp layout (incorrect)',
          color: colorForBreakpoint(bp),
        ),
        if (isAtLeastBreakpoint(bp, 'MD')) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: fakeNav('Nav rail')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: fakeNav('Desktop content')),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Desktop chrome crammed into ${paneWidth.round()} dp',
            style: TextStyle(fontSize: 11, color: Colors.red.shade700),
          ),
        ] else
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: fakeNav('Mobile single column'),
          ),
      ],
    );
  }
}

// Shared helpers kept in this file so the problem example stays package-free.

String bootstrapBreakpoint(double width) {
  if (width >= 1400) return 'XXL';
  if (width >= 1200) return 'XL';
  if (width >= 992) return 'LG';
  if (width >= 768) return 'MD';
  if (width >= 576) return 'SM';
  return 'XS';
}

bool isAtLeastBreakpoint(String bp, String min) {
  const order = ['XS', 'SM', 'MD', 'LG', 'XL', 'XXL'];
  return order.indexOf(bp) >= order.indexOf(min);
}

Color colorForBreakpoint(String bp) {
  return switch (bp) {
    'XS' => Colors.red,
    'SM' => Colors.orange,
    'MD' => Colors.green,
    'LG' => Colors.blue,
    'XL' => Colors.purple,
    _ => Colors.teal,
  };
}

Widget layoutBanner({required String label, required Color color}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}

Widget fakeNav(String label) {
  return Container(
    height: 44,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label, style: const TextStyle(fontSize: 12)),
  );
}

Widget problemCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: child,
  );
}

Widget problemCallout({
  required Color color,
  required String title,
  required String body,
}) {
  final Color titleColor = color is MaterialColor ? color.shade800 : color;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(body, style: const TextStyle(fontSize: 13, height: 1.35)),
      ],
    ),
  );
}

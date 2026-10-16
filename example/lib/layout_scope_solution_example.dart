import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:material_ui/material_ui.dart';

/// Same scenario as [LayoutScopeProblemExample], fixed with [LayoutScope].
///
/// The narrow pane adapts from local constraints while the viewport
/// breakpoint can remain MD/LG/XXL.
class LayoutScopeSolutionExample extends StatefulWidget {
  const LayoutScopeSolutionExample({super.key});

  @override
  State<LayoutScopeSolutionExample> createState() =>
      _LayoutScopeSolutionExampleState();
}

class _LayoutScopeSolutionExampleState
    extends State<LayoutScopeSolutionExample> {
  double _paneWidth = 320;

  @override
  Widget build(BuildContext context) {
    final Breakpoint viewportBp = context.breakpoint;

    return Scaffold(
      appBar: AppBar(
        title: const Text('After: LayoutScope'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _callout(
              color: Colors.teal,
              title: 'The solution (LayoutScope)',
              body:
                  'Wrap the pane in LayoutScope. ResponsiveBuilder, '
                  'ResponsiveQuery, and related APIs then use the pane’s '
                  'constraints instead of the full window MediaQuery size.',
            ),
            const SizedBox(height: 16),
            _card(
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
                    'Same slider as the “Before” example. The viewport stays '
                    'put; the pane breakpoint updates correctly.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
                  ),
                  Slider(
                    value: _paneWidth,
                    min: 280,
                    max: 900,
                    divisions: 31,
                    activeColor: Colors.teal,
                    label: '${_paneWidth.round()}',
                    onChanged: (v) => setState(() => _paneWidth = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Viewport (unchanged)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Breakpoint: ${viewportBp.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ResponsiveBuilder(
                    xs: (_) => _banner('XS layout', Colors.red),
                    sm: (_) => _banner('SM layout', Colors.orange),
                    md: (_) => _banner('MD layout', Colors.green),
                    lg: (_) => _banner('LG layout', Colors.blue),
                    xl: (_) => _banner('XL layout', Colors.purple),
                    xxl: (_) => _banner('XXL layout', Colors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Narrow pane with LayoutScope (correct)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'LayoutScope publishes local size. ResponsiveBuilder inside '
                    'the pane follows that size — typically XS/SM for a sidebar.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF616161)),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: _paneWidth,
                      child: LayoutScope(
                        child: Builder(
                          builder: (context) {
                            final Breakpoint paneBp = context.breakpoint;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.teal.shade50,
                                  child: Text(
                                    'Pane ${_paneWidth.round()} dp → '
                                    '${paneBp.name.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.teal.shade900,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ResponsiveBuilder(
                                  xs: (_) => Column(
                                    children: [
                                      _banner(
                                        'XS layout (correct)',
                                        Colors.red,
                                      ),
                                      const SizedBox(height: 8),
                                      _nav('Mobile single column'),
                                    ],
                                  ),
                                  sm: (_) => Column(
                                    children: [
                                      _banner(
                                        'SM layout (correct)',
                                        Colors.orange,
                                      ),
                                      const SizedBox(height: 8),
                                      _nav('Compact layout'),
                                    ],
                                  ),
                                  md: (_) => Column(
                                    children: [
                                      _banner(
                                        'MD layout (correct)',
                                        Colors.green,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(child: _nav('Side')),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 2,
                                            child: _nav('Content'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  lg: (_) => _banner(
                                    'LG layout (correct)',
                                    Colors.blue,
                                  ),
                                  xl: (_) => _banner(
                                    'XL layout (correct)',
                                    Colors.purple,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              color: Colors.grey.shade900,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minimal usage',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'LayoutScope(\n'
                    '  child: ResponsiveBuilder(\n'
                    '    xs: (_) => CompactView(),\n'
                    '    md: (_) => ExpandedView(),\n'
                    '  ),\n'
                    ');',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      fontFamily: 'monospace',
                      color: Color(0xFFB9F6CA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _banner(String label, Color color) {
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

  Widget _nav(String label) {
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

  Widget _card({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: color == null ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: child,
    );
  }

  Widget _callout({
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
}

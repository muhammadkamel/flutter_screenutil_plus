import 'package:flutter_screenutil_plus_example/layout_scope_demo_page.dart';
import 'package:flutter_screenutil_plus_example/layout_scope_problem_example.dart';
import 'package:flutter_screenutil_plus_example/layout_scope_solution_example.dart';
import 'package:material_ui/material_ui.dart';

/// Hub that walks developers through the LayoutScope problem and fix.
class LayoutScopeLearnPage extends StatelessWidget {
  const LayoutScopeLearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn LayoutScope'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Why LayoutScope exists',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Responsive UIs that key off MediaQuery.size treat a narrow sidebar '
            'as if it were the full window. Walk through the bug, then the fix.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _stepCard(
            context,
            step: '1',
            title: 'Before — MediaQuery only',
            subtitle:
                'Pure Flutter. No flutter_screenutil_plus. See the wrong '
                'desktop layout inside a phone-sized pane.',
            color: Colors.red,
            icon: Icons.bug_report,
            page: const LayoutScopeProblemExample(),
          ),
          const SizedBox(height: 12),
          _stepCard(
            context,
            step: '2',
            title: 'After — LayoutScope',
            subtitle:
                'Same scenario with LayoutScope + ResponsiveBuilder. '
                'The pane follows local constraints.',
            color: Colors.teal,
            icon: Icons.verified,
            page: const LayoutScopeSolutionExample(),
          ),
          const SizedBox(height: 12),
          _stepCard(
            context,
            step: '3',
            title: 'Full LayoutScope playground',
            subtitle:
                'Nested scopes, ResponsiveGrid, and more interactive cases.',
            color: Colors.blue,
            icon: Icons.science,
            page: const LayoutScopeDemoPage(),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(
    BuildContext context, {
    required String step,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required Widget page,
  }) {
    return Material(
      color: color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => page));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                foregroundColor: Colors.white,
                child: Text(
                  step,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 18, color: color),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color is MaterialColor
                                  ? color.shade800
                                  : color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:alchemist/alchemist.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'golden_helper.dart';

void main() {
  group('LayoutScope golden tests', () {
    goldenTest(
      'LayoutScope uses local constraints on desktop viewport',
      fileName: 'layout_scope_container',
      constraints: const BoxConstraints(maxWidth: 1400),
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: 'viewport only',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: ResponsiveBuilder(
                xs: (_) => _tile('XS', const Color(0xFFE53935)),
                md: (_) => _tile('MD', const Color(0xFF43A047)),
                lg: (_) => _tile('LG', const Color(0xFF1E88E5)),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'narrow LayoutScope',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: Align(
                child: SizedBox(
                  width: 320,
                  height: 120,
                  child: LayoutScope(
                    child: ResponsiveBuilder(
                      xs: (_) => _tile('XS pane', const Color(0xFFE53935)),
                      md: (_) => _tile('MD pane', const Color(0xFF43A047)),
                      lg: (_) => _tile('LG pane', const Color(0xFF1E88E5)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'medium LayoutScope',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: Align(
                child: SizedBox(
                  width: 800,
                  height: 120,
                  child: LayoutScope(
                    child: ResponsiveBuilder(
                      xs: (_) => _tile('XS pane', const Color(0xFFE53935)),
                      md: (_) => _tile('MD pane', const Color(0xFF43A047)),
                      lg: (_) => _tile('LG pane', const Color(0xFF1E88E5)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'SizeClassBuilder pane',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: Align(
                child: SizedBox(
                  width: 400,
                  height: 120,
                  child: LayoutScope(
                    child: SizeClassBuilder(
                      compact: (_) =>
                          _tile('Compact pane', const Color(0xFFD81B60)),
                      regular: (_) =>
                          _tile('Regular pane', const Color(0xFF00897B)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Nested LayoutScope nearest ancestor wins',
      fileName: 'layout_scope_nested',
      constraints: const BoxConstraints(maxWidth: 1400),
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          GoldenTestScenario(
            name: 'outer wide / inner narrow',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: Align(
                child: SizedBox(
                  width: 900,
                  height: 200,
                  child: LayoutScope(
                    child: ColoredBox(
                      color: const Color(0xFFE3F2FD),
                      child: Row(
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                final Breakpoint bp = ResponsiveQuery.of(
                                  context,
                                ).breakpoint;
                                return _tile(
                                  'Outer ${bp.name}',
                                  const Color(0xFF1E88E5),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 280,
                            child: LayoutScope(
                              child: ResponsiveBuilder(
                                xs: (_) =>
                                    _tile('Inner XS', const Color(0xFFE53935)),
                                md: (_) =>
                                    _tile('Inner MD', const Color(0xFF43A047)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'ResponsiveGrid under LayoutScope uses container spans',
      fileName: 'layout_scope_grid',
      constraints: const BoxConstraints(maxWidth: 1400),
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          GoldenTestScenario(
            name: 'full desktop grid',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ResponsiveGrid(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ResponsiveGridItem(
                      xs: 12,
                      md: 6,
                      lg: 4,
                      child: _gridCell('A', const Color(0xFF5C6BC0)),
                    ),
                    ResponsiveGridItem(
                      xs: 12,
                      md: 6,
                      lg: 4,
                      child: _gridCell('B', const Color(0xFF26A69A)),
                    ),
                    ResponsiveGridItem(
                      xs: 12,
                      md: 12,
                      lg: 4,
                      child: _gridCell('C', const Color(0xFFEF5350)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'narrow pane grid',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: Align(
                child: SizedBox(
                  width: 360,
                  height: 220,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ResponsiveGrid(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ResponsiveGridItem(
                          xs: 12,
                          md: 6,
                          lg: 4,
                          child: _gridCell('A', const Color(0xFF5C6BC0)),
                        ),
                        ResponsiveGridItem(
                          xs: 12,
                          md: 6,
                          lg: 4,
                          child: _gridCell('B', const Color(0xFF26A69A)),
                        ),
                        ResponsiveGridItem(
                          xs: 12,
                          md: 12,
                          lg: 4,
                          child: _gridCell('C', const Color(0xFFEF5350)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _tile(String label, Color color) {
  return Container(
    width: double.infinity,
    height: 80,
    alignment: Alignment.center,
    color: color,
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _gridCell(String label, Color color) {
  return Container(
    height: 56,
    alignment: Alignment.center,
    color: color,
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

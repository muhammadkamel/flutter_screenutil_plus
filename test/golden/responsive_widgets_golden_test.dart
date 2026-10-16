import 'package:alchemist/alchemist.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'golden_helper.dart';

void main() {
  group('Responsive widgets golden tests', () {
    goldenTest(
      'ResponsiveBuilder switches layout by breakpoint',
      fileName: 'responsive_builder',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: ResponsiveBuilder(
                  xs: (_) => _layoutTile(
                    label: 'XS',
                    color: const Color(0xFFE53935),
                  ),
                  sm: (_) => _layoutTile(
                    label: 'SM',
                    color: const Color(0xFFFB8C00),
                  ),
                  md: (_) => _layoutTile(
                    label: 'MD',
                    color: const Color(0xFF43A047),
                  ),
                  lg: (_) => _layoutTile(
                    label: 'LG',
                    color: const Color(0xFF1E88E5),
                  ),
                  xl: (_) => _layoutTile(
                    label: 'XL',
                    color: const Color(0xFF8E24AA),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'ResponsiveBuilder fallback chain',
      fileName: 'responsive_builder_fallback',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: ResponsiveBuilder(
                  // Only xs + lg defined — md/tablet falls back toward xs.
                  xs: (_) => _layoutTile(
                    label: 'XS fallback',
                    color: const Color(0xFF6D4C41),
                  ),
                  lg: (_) => _layoutTile(
                    label: 'LG only',
                    color: const Color(0xFF00838F),
                  ),
                  fallback: _layoutTile(
                    label: 'Fallback',
                    color: const Color(0xFF455A64),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'SizeClassBuilder compact vs regular',
      fileName: 'size_class_builder',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: SizeClassBuilder(
                  compact: (_) => _layoutTile(
                    label: 'Compact',
                    color: const Color(0xFFD81B60),
                  ),
                  regular: (_) => _layoutTile(
                    label: 'Regular',
                    color: const Color(0xFF00897B),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'SizeClassBuilder horizontal and builder APIs',
      fileName: 'size_class_builder_apis',
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: 'horizontal phone',
            child: screenUtilGoldenFrame(
              screenSize: goldenPhoneSize,
              child: SizeClassBuilder(
                horizontal: (context, sizeClass) => _layoutTile(
                  label: 'H:${sizeClass.name}',
                  color: const Color(0xFF5E35B1),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'builder tablet',
            child: screenUtilGoldenFrame(
              screenSize: goldenTabletSize,
              child: SizeClassBuilder(
                builder: (context, sizeClasses) => _layoutTile(
                  label: 'B:${sizeClasses.horizontal.name}',
                  color: const Color(0xFF3949AB),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'vertical phone',
            child: screenUtilGoldenFrame(
              screenSize: goldenPhoneSize,
              child: SizeClassBuilder(
                vertical: (context, sizeClass) => _layoutTile(
                  label: 'V:${sizeClass.name}',
                  color: const Color(0xFF00ACC1),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'horizontal desktop',
            child: screenUtilGoldenFrame(
              screenSize: goldenDesktopSize,
              child: SizeClassBuilder(
                horizontal: (context, sizeClass) => _layoutTile(
                  label: 'H:${sizeClass.name}',
                  color: const Color(0xFF43A047),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'ConditionalBuilder by breakpoint condition',
      fileName: 'conditional_builder',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: ConditionalBuilder(
                  condition: (context) =>
                      ResponsiveQuery.of(context).isAtLeast(Breakpoint.md),
                  builder: (_) => _layoutTile(
                    label: '>= MD',
                    color: const Color(0xFF2E7D32),
                  ),
                  fallback: (_) => _layoutTile(
                    label: '< MD',
                    color: const Color(0xFFC62828),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'ResponsiveGrid adapts column spans by breakpoint',
      fileName: 'responsive_grid',
      constraints: const BoxConstraints(maxWidth: 1400),
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
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
        ],
      ),
    );

    goldenTest(
      'ResponsiveGrid dense spans',
      fileName: 'responsive_grid_dense',
      constraints: const BoxConstraints(maxWidth: 1400),
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ResponsiveGrid(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final (label, color, xs, md, lg) in _denseItems)
                        ResponsiveGridItem(
                          xs: xs,
                          md: md,
                          lg: lg,
                          child: _gridCell(label, color),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  });
}

Widget _layoutTile({required String label, required Color color}) {
  return Container(
    width: 160,
    height: 80,
    alignment: Alignment.center,
    color: color,
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 20,
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

const _denseItems = <(String, Color, int, int, int)>[
  ('1', Color(0xFFEF5350), 6, 4, 3),
  ('2', Color(0xFFAB47BC), 6, 4, 3),
  ('3', Color(0xFF5C6BC0), 6, 4, 3),
  ('4', Color(0xFF29B6F6), 6, 4, 3),
];

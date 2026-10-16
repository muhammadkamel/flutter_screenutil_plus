import 'package:alchemist/alchemist.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'golden_helper.dart';

void main() {
  group('Adaptive widgets golden tests', () {
    goldenTest(
      'AdaptiveText adapts across breakpoints',
      fileName: 'adaptive_text',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: const AdaptiveText(
                  'Adaptive heading',
                  fontSizeXs: 14,
                  fontSizeMd: 20,
                  fontSizeLg: 28,
                  fontWeightXs: FontWeight.normal,
                  fontWeightMd: FontWeight.w600,
                  fontWeightLg: FontWeight.bold,
                  colorXs: Color(0xFF37474F),
                  colorMd: Color(0xFF1565C0),
                  colorLg: Color(0xFF6A1B9A),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'AdaptiveText with letter spacing and alignment',
      fileName: 'adaptive_text_styles',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: const SizedBox(
                  width: 200,
                  child: AdaptiveText(
                    'Spaced & aligned',
                    fontSizeXs: 12,
                    fontSizeMd: 16,
                    fontSizeLg: 20,
                    letterSpacingXs: 0.5,
                    letterSpacingMd: 1.0,
                    letterSpacingLg: 2.0,
                    lineHeightXs: 1.2,
                    lineHeightMd: 1.4,
                    lineHeightLg: 1.6,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'AdaptiveContainer adapts across breakpoints',
      fileName: 'adaptive_container',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: const AdaptiveContainer(
                  width: {
                    Breakpoint.xs: 120,
                    Breakpoint.md: 200,
                    Breakpoint.lg: 280,
                  },
                  height: {
                    Breakpoint.xs: 60,
                    Breakpoint.md: 80,
                    Breakpoint.lg: 100,
                  },
                  padding: {
                    Breakpoint.xs: EdgeInsets.all(8),
                    Breakpoint.md: EdgeInsets.all(16),
                    Breakpoint.lg: EdgeInsets.all(24),
                  },
                  color: Color(0xFFFF8A65),
                  alignment: Alignment.center,
                  child: Text(
                    'Adaptive',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'SimpleAdaptiveContainer adapts across breakpoints',
      fileName: 'simple_adaptive_container',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: const SimpleAdaptiveContainer(
                  widthXs: 100,
                  widthMd: 180,
                  widthLg: 260,
                  heightXs: 48,
                  heightMd: 64,
                  heightLg: 80,
                  paddingXs: EdgeInsets.all(6),
                  paddingMd: EdgeInsets.all(12),
                  paddingLg: EdgeInsets.all(20),
                  marginXs: EdgeInsets.all(4),
                  marginMd: EdgeInsets.all(8),
                  marginLg: EdgeInsets.all(12),
                  color: Color(0xFF7E57C2),
                  child: Center(
                    child: Text(
                      'Simple',
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'AdaptiveContainer with decoration and margin',
      fileName: 'adaptive_container_decoration',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: AdaptiveContainer(
                  width: const {
                    Breakpoint.xs: 140,
                    Breakpoint.md: 220,
                    Breakpoint.lg: 300,
                  },
                  height: const {
                    Breakpoint.xs: 70,
                    Breakpoint.md: 90,
                    Breakpoint.lg: 110,
                  },
                  margin: const {
                    Breakpoint.xs: EdgeInsets.all(8),
                    Breakpoint.md: EdgeInsets.all(16),
                    Breakpoint.lg: EdgeInsets.all(24),
                  },
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Decorated',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
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

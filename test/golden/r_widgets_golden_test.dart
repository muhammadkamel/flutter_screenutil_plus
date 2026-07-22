import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_helper.dart';

void main() {
  group('R* widgets golden tests', () {
    goldenTest(
      'RContainer scales across screen sizes',
      fileName: 'r_container',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: const RContainer(
                  width: 100,
                  height: 80,
                  color: Color(0xFF1565C0),
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: RContainer(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF90CAF9),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'RContainer with constraints and transform',
      fileName: 'r_container_constraints',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: const RContainer(
                  constraints: BoxConstraints(
                    minWidth: 80,
                    maxWidth: 160,
                    minHeight: 40,
                    maxHeight: 80,
                  ),
                  color: Color(0xFF00897B),
                  alignment: Alignment.center,
                  child: RText(
                    'Constrained',
                    style: TextStyle(fontSize: 12, color: Color(0xFFFFFFFF)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'RPadding with EdgeInsets and REdgeInsets',
      fileName: 'r_padding',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const RPadding(
                      padding: EdgeInsets.all(16),
                      child: ColoredBox(
                        color: Color(0xFF5C6BC0),
                        child: SizedBox(width: 80, height: 40),
                      ),
                    ),
                    RPadding(
                      padding: REdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: const ColoredBox(
                        color: Color(0xFF26A69A),
                        child: SizedBox(width: 80, height: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'RSizedBox constructors scale across screen sizes',
      fileName: 'r_sizedbox',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const RSizedBox(
                      width: 32,
                      height: 64,
                      child: ColoredBox(color: Color(0xFFE53935)),
                    ),
                    const RSizedBox.horizontal(8),
                    const RSizedBox.vertical(
                      48,
                      child: ColoredBox(
                        color: Color(0xFFFB8C00),
                        child: SizedBox(width: 24),
                      ),
                    ),
                    const RSizedBox.horizontal(8),
                    const RSizedBox.square(
                      dimension: 40,
                      child: ColoredBox(color: Color(0xFF43A047)),
                    ),
                    const RSizedBox.horizontal(8),
                    RSizedBox.fromSize(
                      size: const Size(56, 28),
                      child: const ColoredBox(color: Color(0xFF1E88E5)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    goldenTest(
      'RText scales font size across screen sizes',
      fileName: 'r_text',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          for (final entry in goldenScreenSizes.entries)
            GoldenTestScenario(
              name: entry.key,
              child: screenUtilGoldenFrame(
                screenSize: entry.value,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RText(
                      'Title 24.sp',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    RSizedBox(height: 8),
                    RText(
                      'Body 14.sp',
                      style: TextStyle(fontSize: 14, color: Color(0xFF616161)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  });
}

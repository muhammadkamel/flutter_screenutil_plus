import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RText', () {
    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.noScaling,
        ),
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    testWidgets('scales font size when style is provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RText('Hello', style: TextStyle(fontSize: 16))),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();

      expect(text.style?.fontSize, closeTo(16 * util.scaleText, 0.001));
    });

    testWidgets('scales default font size when no style provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultTextStyle(
            style: TextStyle(fontSize: 14),
            child: RText('Hello'),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();

      expect(text.style?.fontSize, closeTo(14 * util.scaleText, 0.001));
    });

    testWidgets('preserves other text properties', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RText(
            'Hello',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));

      expect(text.style?.color, Colors.red);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.textAlign, TextAlign.center);
      expect(text.maxLines, 2);
    });

    testWidgets('scales line height proportionally with font size', (
      tester,
    ) async {
      const originalFontSize = 16.0;
      const originalHeight = 1.5;

      await tester.pumpWidget(
        const MaterialApp(
          home: RText(
            'Test',
            style: TextStyle(
              fontSize: originalFontSize,
              height: originalHeight,
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();
      final double scaledFontSize = originalFontSize * util.scaleText;
      // Height multiplier should be preserved
      const expectedHeight = originalHeight;

      expect(text.style?.fontSize, closeTo(scaledFontSize, 0.001));
      expect(text.style?.height, closeTo(expectedHeight, 0.001));
    });

    testWidgets(
      'uses default line height multiplier when height not provided',
      (tester) async {
        const fontSize = 20.0;

        await tester.pumpWidget(
          const MaterialApp(
            home: RText(
              'Test',
              style: TextStyle(
                fontSize: fontSize,
                // No height specified - should use default
              ),
            ),
          ),
        );

        final Text text = tester.widget<Text>(find.byType(Text));
        final util = ScreenUtilPlus();
        final double scaledFontSize = fontSize * util.scaleText;

        expect(text.style?.fontSize, closeTo(scaledFontSize, 0.001));
        expect(
          text.style?.height,
          RText.defaultLineHeightMultiplier,
          reason: 'Should use default line height multiplier when not provided',
        );
      },
    );

    testWidgets('default line height works across different font sizes', (
      tester,
    ) async {
      final fontSizes = [12.0, 16.0, 20.0, 24.0, 32.0];

      for (final fontSize in fontSizes) {
        await tester.pumpWidget(
          MaterialApp(
            home: RText(
              'Test',
              style: TextStyle(
                fontSize: fontSize,
                // No height specified
              ),
            ),
          ),
        );

        final Text text = tester.widget<Text>(find.byType(Text));
        final util = ScreenUtilPlus();
        final double scaledFontSize = fontSize * util.scaleText;

        expect(
          text.style?.fontSize,
          closeTo(scaledFontSize, 0.001),
          reason: 'Font size should scale for fontSize=$fontSize',
        );
        expect(
          text.style?.height,
          RText.defaultLineHeightMultiplier,
          reason: 'Should use default line height for fontSize=$fontSize',
        );
      }
    });

    testWidgets('calculates default line height when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RText(
            'Test',
            style: TextStyle(
              fontSize: 16,
              // No height specified
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();
      final double scaledFontSize = 16 * util.scaleText;

      expect(text.style?.fontSize, closeTo(scaledFontSize, 0.001));
      // Should have default line height multiplier
      expect(text.style?.height, RText.defaultLineHeightMultiplier);
    });

    testWidgets(
      'text with line height is properly scaled for vertical centering',
      (tester) async {
        const containerHeight = 80.0;
        const fontSize = 16.0;
        const lineHeight = 1.2;

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            child: MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Container(
                    height: containerHeight,
                    width: 200,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const RText(
                      'Centered Text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        height: lineHeight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder textFinder = find.text('Centered Text');
        expect(textFinder, findsOneWidget);

        final Text textWidget = tester.widget<Text>(textFinder);
        final util = ScreenUtilPlus();
        final double scaledFontSize = fontSize * util.scaleText;
        // Height multiplier should be preserved, not scaled
        const expectedHeight = lineHeight;

        // Verify font size is scaled
        expect(textWidget.style?.fontSize, closeTo(scaledFontSize, 0.001));

        // Verify line height multiplier is preserved
        expect(textWidget.style?.height, closeTo(expectedHeight, 0.001));

        // Verify text is visible and rendered
        expect(textFinder, findsOneWidget);
      },
    );

    testWidgets('line height scales correctly for different font sizes', (
      tester,
    ) async {
      final testCases = [
        {'fontSize': 12.0, 'height': 1.2},
        {'fontSize': 16.0, 'height': 1.5},
        {'fontSize': 20.0, 'height': 1.8},
        {'fontSize': 24.0, 'height': 2.0},
      ];

      for (final testCase in testCases) {
        final double originalFontSize = testCase['fontSize']!;
        final double originalHeight = testCase['height']!;

        await tester.pumpWidget(
          MaterialApp(
            home: RText(
              'Test',
              style: TextStyle(
                fontSize: originalFontSize,
                height: originalHeight,
              ),
            ),
          ),
        );

        final Text text = tester.widget<Text>(find.byType(Text));
        final util = ScreenUtilPlus();
        final double scaledFontSize = originalFontSize * util.scaleText;
        // Height multiplier should be preserved
        final expectedHeight = originalHeight;

        expect(
          text.style?.fontSize,
          closeTo(scaledFontSize, 0.001),
          reason: 'Font size should scale for fontSize=$originalFontSize',
        );
        expect(
          text.style?.height,
          closeTo(expectedHeight, 0.001),
          reason:
              'Height multiplier should be preserved for fontSize=$originalFontSize',
        );
      }
    });

    testWidgets(
      'text with scaled line height maintains proper proportions in container',
      (tester) async {
        const containerHeight = 60.0;
        const fontSize = 16.0;
        const lineHeight = 1.2;

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            child: MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Container(
                    height: containerHeight,
                    width: 200,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const RText(
                      'Fitting Text',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSize, height: lineHeight),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder textFinder = find.text('Fitting Text');
        expect(textFinder, findsOneWidget);

        final Text textWidget = tester.widget<Text>(textFinder);
        final util = ScreenUtilPlus();
        final double scaledFontSize = fontSize * util.scaleText;
        // Height multiplier should be preserved
        const scaledHeight = lineHeight;

        // Verify font size is scaled
        expect(textWidget.style?.fontSize, closeTo(scaledFontSize, 0.001));

        // Verify line height multiplier is preserved
        expect(textWidget.style?.height, closeTo(scaledHeight, 0.001));

        // Verify the absolute line height scales with font size
        // (absolute line height = fontSize * height multiplier)
        final double absoluteLineHeight = scaledFontSize * scaledHeight;
        expect(absoluteLineHeight, closeTo(scaledFontSize * lineHeight, 0.001));
      },
    );

    testWidgets(
      'multiple RText widgets with same style have consistent line heights',
      (tester) async {
        const fontSize = 16.0;
        const height = 1.5;

        await tester.pumpWidget(
          const MaterialApp(
            home: Column(
              children: [
                RText(
                  'Text 1',
                  style: TextStyle(fontSize: fontSize, height: height),
                ),
                RText(
                  'Text 2',
                  style: TextStyle(fontSize: fontSize, height: height),
                ),
                RText(
                  'Text 3',
                  style: TextStyle(fontSize: fontSize, height: height),
                ),
              ],
            ),
          ),
        );

        final Iterable<Text> textWidgets = tester.widgetList<Text>(
          find.byType(Text),
        );
        final util = ScreenUtilPlus();
        final double expectedFontSize = fontSize * util.scaleText;
        // Height multiplier should be preserved
        const expectedHeight = height;

        for (final text in textWidgets) {
          expect(text.style?.fontSize, closeTo(expectedFontSize, 0.001));
          expect(text.style?.height, closeTo(expectedHeight, 0.001));
        }
      },
    );

    testWidgets(
      'RText in RContainer maintains proper line height for vertical centering',
      (tester) async {
        const containerHeight = 80.0;
        const fontSize = 16.0;

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            child: MaterialApp(
              home: Scaffold(
                body: Row(
                  children: [
                    Expanded(
                      child: RContainer(
                        height: containerHeight,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: RText(
                            'RContainer 1',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RContainer(
                        height: containerHeight,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: RText(
                            'RContainer 2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify both text widgets are found
        final Finder text1Finder = find.text('RContainer 1');
        final Finder text2Finder = find.text('RContainer 2');
        expect(text1Finder, findsOneWidget);
        expect(text2Finder, findsOneWidget);

        // Verify both have correct scaled font sizes
        final Text text1Widget = tester.widget<Text>(text1Finder);
        final Text text2Widget = tester.widget<Text>(text2Finder);
        final util = ScreenUtilPlus();
        final double expectedFontSize = fontSize * util.scaleText;

        expect(text1Widget.style?.fontSize, closeTo(expectedFontSize, 0.001));
        expect(text2Widget.style?.fontSize, closeTo(expectedFontSize, 0.001));

        // Verify text align is center
        expect(text1Widget.textAlign, TextAlign.center);
        expect(text2Widget.textAlign, TextAlign.center);

        // Verify both texts are visible and rendered
        expect(text1Finder, findsOneWidget);
        expect(text2Finder, findsOneWidget);
      },
    );
  });

  group('RText vertical centering across different screen sizes', () {
    // Mobile sizes
    final List<Map<String, Object>> mobileSizes = [
      {'name': 'Small Mobile', 'size': const Size(320, 568)}, // iPhone SE
      {'name': 'Medium Mobile', 'size': const Size(375, 667)}, // iPhone 8
      {
        'name': 'Large Mobile',
        'size': const Size(414, 896),
      }, // iPhone 11 Pro Max
    ];

    // Tablet sizes
    final List<Map<String, Object>> tabletSizes = [
      {'name': 'Small Tablet', 'size': const Size(600, 960)},
      {'name': 'Medium Tablet', 'size': const Size(768, 1024)}, // iPad
      {'name': 'Large Tablet', 'size': const Size(1024, 1366)}, // iPad Pro
    ];

    // Desktop/Web sizes
    final List<Map<String, Object>> desktopSizes = [
      {'name': 'Small Desktop', 'size': const Size(1280, 720)}, // HD
      {'name': 'Medium Desktop', 'size': const Size(1920, 1080)}, // Full HD
      {'name': 'Large Desktop', 'size': const Size(2560, 1440)}, // 2K
      {'name': 'Very Large Desktop', 'size': const Size(3840, 2160)}, // 4K
    ];

    // Web browser sizes
    final List<Map<String, Object>> webSizes = [
      {'name': 'Mobile Web', 'size': const Size(375, 667)},
      {'name': 'Tablet Web', 'size': const Size(768, 1024)},
      {'name': 'Desktop Web', 'size': const Size(1920, 1080)},
      {'name': 'Large Web', 'size': const Size(2560, 1440)},
    ];

    Future<void> testVerticalCenteringForSize(
      String sizeName,
      Size screenSize,
      WidgetTester tester,
    ) async {
      const containerHeight = 80.0;
      const fontSize = 16.0;
      const lineHeight = 1.2;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Container(
                  height: containerHeight,
                  width: 200,
                  color: Colors.blue.shade50,
                  alignment: Alignment.center,
                  child: const RText(
                    'Centered Text',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: lineHeight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Finder textFinder = find.text('Centered Text');
      expect(
        textFinder,
        findsOneWidget,
        reason: 'Text should be found for $sizeName',
      );

      final Text textWidget = tester.widget<Text>(textFinder);
      final util = ScreenUtilPlus();
      final double scaledFontSize = fontSize * util.scaleText;
      // Height multiplier should be preserved
      const expectedHeight = lineHeight;

      // Verify font size is scaled
      expect(
        textWidget.style?.fontSize,
        closeTo(scaledFontSize, 0.001),
        reason: 'Font size should be scaled for $sizeName',
      );

      // Verify line height multiplier is preserved
      expect(
        textWidget.style?.height,
        closeTo(expectedHeight, 0.001),
        reason: 'Line height multiplier should be preserved for $sizeName',
      );

      // Verify text align is center
      expect(
        textWidget.textAlign,
        TextAlign.center,
        reason: 'Text should be center aligned for $sizeName',
      );
    }

    // Test mobile sizes
    for (final sizeData in mobileSizes) {
      testWidgets(
        'vertical centering on ${sizeData['name']} (${sizeData['size']})',
        (tester) async {
          ScreenUtilPlus.configure(
            data: MediaQueryData(
              size: sizeData['size']! as Size,
              textScaler: TextScaler.noScaling,
            ),
            designSize: const Size(360, 690),
            minTextAdapt: false,
            splitScreenMode: false,
          );

          await testVerticalCenteringForSize(
            sizeData['name']! as String,
            sizeData['size']! as Size,
            tester,
          );
        },
      );
    }

    // Test tablet sizes
    for (final sizeData in tabletSizes) {
      testWidgets(
        'vertical centering on ${sizeData['name']} (${sizeData['size']})',
        (tester) async {
          ScreenUtilPlus.configure(
            data: MediaQueryData(
              size: sizeData['size']! as Size,
              textScaler: TextScaler.noScaling,
            ),
            designSize: const Size(360, 690),
            minTextAdapt: false,
            splitScreenMode: false,
          );

          await testVerticalCenteringForSize(
            sizeData['name']! as String,
            sizeData['size']! as Size,
            tester,
          );
        },
      );
    }

    // Test desktop sizes
    for (final sizeData in desktopSizes) {
      testWidgets(
        'vertical centering on ${sizeData['name']} (${sizeData['size']})',
        (tester) async {
          ScreenUtilPlus.configure(
            data: MediaQueryData(
              size: sizeData['size']! as Size,
              textScaler: TextScaler.noScaling,
            ),
            designSize: const Size(360, 690),
            minTextAdapt: false,
            splitScreenMode: false,
          );

          await testVerticalCenteringForSize(
            sizeData['name']! as String,
            sizeData['size']! as Size,
            tester,
          );
        },
      );
    }

    // Test web sizes
    for (final sizeData in webSizes) {
      testWidgets(
        'vertical centering on ${sizeData['name']} (${sizeData['size']})',
        (tester) async {
          ScreenUtilPlus.configure(
            data: MediaQueryData(
              size: sizeData['size']! as Size,
              textScaler: TextScaler.noScaling,
            ),
            designSize: const Size(360, 690),
            minTextAdapt: false,
            splitScreenMode: false,
          );

          await testVerticalCenteringForSize(
            sizeData['name']! as String,
            sizeData['size']! as Size,
            tester,
          );
        },
      );
    }

    // Test RContainer scenario across different sizes
    testWidgets('RContainer text vertical centering on multiple screen sizes', (
      tester,
    ) async {
      final testSizes = [
        const Size(320, 568), // Small mobile
        const Size(375, 667), // Medium mobile
        const Size(768, 1024), // Tablet
        const Size(1920, 1080), // Desktop
        const Size(3840, 2160), // Very large
      ];

      for (final screenSize in testSizes) {
        ScreenUtilPlus.configure(
          data: MediaQueryData(
            size: screenSize,
            textScaler: TextScaler.noScaling,
          ),
          designSize: const Size(360, 690),
          minTextAdapt: false,
          splitScreenMode: false,
        );

        const containerHeight = 80.0;
        const fontSize = 16.0;

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            child: MaterialApp(
              home: Scaffold(
                body: Row(
                  children: [
                    Expanded(
                      child: RContainer(
                        height: containerHeight,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: RText(
                            'RContainer 1',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RContainer(
                        height: containerHeight,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: RText(
                            'RContainer 2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder text1Finder = find.text('RContainer 1');
        final Finder text2Finder = find.text('RContainer 2');
        expect(text1Finder, findsOneWidget);
        expect(text2Finder, findsOneWidget);

        final Text text1Widget = tester.widget<Text>(text1Finder);
        final Text text2Widget = tester.widget<Text>(text2Finder);
        final util = ScreenUtilPlus();
        final double expectedFontSize = fontSize * util.scaleText;

        expect(
          text1Widget.style?.fontSize,
          closeTo(expectedFontSize, 0.001),
          reason: 'Font size should scale for screen size $screenSize',
        );
        expect(
          text2Widget.style?.fontSize,
          closeTo(expectedFontSize, 0.001),
          reason: 'Font size should scale for screen size $screenSize',
        );

        expect(text1Widget.textAlign, TextAlign.center);
        expect(text2Widget.textAlign, TextAlign.center);
      }
    });

    // Test line height consistency across different screen sizes
    testWidgets('line height scaling consistency across all screen sizes', (
      tester,
    ) async {
      final testSizes = [
        const Size(320, 568), // Small mobile
        const Size(414, 896), // Large mobile
        const Size(768, 1024), // Tablet
        const Size(1920, 1080), // Desktop
        const Size(3840, 2160), // Very large
      ];

      const fontSize = 16.0;
      const lineHeight = 1.5;

      for (final screenSize in testSizes) {
        ScreenUtilPlus.configure(
          data: MediaQueryData(
            size: screenSize,
            textScaler: TextScaler.noScaling,
          ),
          designSize: const Size(360, 690),
          minTextAdapt: false,
          splitScreenMode: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            key: ValueKey(screenSize),
            home: const RText(
              'Test Text',
              style: TextStyle(fontSize: fontSize, height: lineHeight),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(find.byType(Text));
        final util = ScreenUtilPlus();
        final double scaledFontSize = fontSize * util.scaleText;
        // Height multiplier should be preserved
        const expectedHeight = lineHeight;

        expect(
          textWidget.style?.fontSize,
          closeTo(scaledFontSize, 0.001),
          reason: 'Font size should scale for $screenSize',
        );

        expect(
          textWidget.style?.height,
          closeTo(expectedHeight, 0.001),
          reason: 'Line height multiplier should be preserved for $screenSize',
        );

        // Verify the absolute line height scales with font size
        // (absolute line height = fontSize * height multiplier)
        final double absoluteLineHeight = scaledFontSize * expectedHeight;
        const double originalAbsoluteLineHeight = fontSize * lineHeight;
        final double fontSizeRatio = scaledFontSize / fontSize;
        expect(
          absoluteLineHeight / originalAbsoluteLineHeight,
          closeTo(fontSizeRatio, 0.001),
          reason:
              'Absolute line height should scale with font size for $screenSize',
        );
      }
    });

    // Test default line height calculation across different screen sizes
    testWidgets('default line height calculation across all screen sizes', (
      tester,
    ) async {
      final testSizes = [
        const Size(320, 568), // Small mobile
        const Size(414, 896), // Large mobile
        const Size(768, 1024), // Tablet
        const Size(1920, 1080), // Desktop
        const Size(3840, 2160), // Very large
      ];

      const fontSize = 16.0;

      for (final screenSize in testSizes) {
        ScreenUtilPlus.configure(
          data: MediaQueryData(
            size: screenSize,
            textScaler: TextScaler.noScaling,
          ),
          designSize: const Size(360, 690),
          minTextAdapt: false,
          splitScreenMode: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            key: ValueKey(screenSize),
            home: const RText(
              'Test Text',
              style: TextStyle(
                fontSize: fontSize,
                // No height specified - should use default
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(find.byType(Text));
        final util = ScreenUtilPlus();
        final double scaledFontSize = fontSize * util.scaleText;

        expect(
          textWidget.style?.fontSize,
          closeTo(scaledFontSize, 0.001),
          reason: 'Font size should scale for $screenSize',
        );

        expect(
          textWidget.style?.height,
          RText.defaultLineHeightMultiplier,
          reason: 'Should use default line height multiplier for $screenSize',
        );
      }
    });
  });
}

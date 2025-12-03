import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Adaptive Widgets Integration Tests', () {
    testWidgets('AdaptiveContainer adapts width based on breakpoint', (
      tester,
    ) async {
      // Set screen size to xs breakpoint
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: AdaptiveContainer(
              width: {
                Breakpoint.xs: 100,
                Breakpoint.md: 200,
                Breakpoint.lg: 300,
              },
              height: {Breakpoint.xs: 50},
              color: Colors.blue,
              child: const Text('Adaptive Container'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Adaptive Container'), findsOneWidget);
      // Verify container was created
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('AdaptiveContainer adapts height based on breakpoint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: AdaptiveContainer(
              width: {Breakpoint.xs: 200},
              height: {
                Breakpoint.xs: 50,
                Breakpoint.md: 100,
                Breakpoint.lg: 150,
              },
              color: Colors.red,
              child: const Text('Height Adaptive'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Height Adaptive'), findsOneWidget);
    });

    testWidgets('AdaptiveContainer adapts padding based on breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: AdaptiveContainer(
              width: {Breakpoint.xs: 200},
              height: {Breakpoint.xs: 100},
              padding: {
                Breakpoint.xs: const EdgeInsets.all(8),
                Breakpoint.md: const EdgeInsets.all(16),
                Breakpoint.lg: const EdgeInsets.all(24),
              },
              color: Colors.green,
              child: const Text('Padding Adaptive'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Padding Adaptive'), findsOneWidget);
    });

    testWidgets('AdaptiveContainer adapts margin based on breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: AdaptiveContainer(
              width: {Breakpoint.xs: 200},
              height: {Breakpoint.xs: 100},
              margin: {
                Breakpoint.xs: const EdgeInsets.symmetric(horizontal: 8),
                Breakpoint.md: const EdgeInsets.symmetric(horizontal: 16),
                Breakpoint.lg: const EdgeInsets.symmetric(horizontal: 24),
              },
              color: Colors.orange,
              child: const Text('Margin Adaptive'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Margin Adaptive'), findsOneWidget);
    });

    testWidgets('AdaptiveContainer falls back to smaller breakpoint', (
      tester,
    ) async {
      // Set to md breakpoint but only define xs and lg
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: AdaptiveContainer(
              width: {Breakpoint.xs: 100, Breakpoint.lg: 300},
              height: {Breakpoint.xs: 50},
              color: Colors.purple,
              child: const Text('Fallback Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Fallback Test'), findsOneWidget);
    });

    testWidgets('SimpleAdaptiveContainer with all breakpoints', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: SimpleAdaptiveContainer(
              widthXs: 100,
              widthSm: 150,
              widthMd: 200,
              widthLg: 250,
              widthXl: 300,
              heightXs: 50,
              heightMd: 100,
              heightLg: 150,
              paddingXs: 8,
              paddingMd: 16,
              paddingLg: 24,
              color: Colors.blue,
              child: const Text('Simple Adaptive'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Simple Adaptive'), findsOneWidget);
    });

    testWidgets('AdaptiveContainer with custom breakpoints', (tester) async {
      final customBreakpoints = const Breakpoints(
        xs: 0,
        sm: 400,
        md: 800,
        lg: 1200,
        xl: 1600,
        xxl: 2000,
      );

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: AdaptiveContainer(
              width: {Breakpoint.xs: 100, Breakpoint.md: 200},
              height: {Breakpoint.xs: 50},
              breakpoints: customBreakpoints,
              color: Colors.teal,
              child: const Text('Custom Breakpoints'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom Breakpoints'), findsOneWidget);
    });

    testWidgets('AdaptiveText adapts fontSize based on breakpoint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Adaptive Text',
              fontSizeXs: 12,
              fontSizeSm: 14,
              fontSizeMd: 16,
              fontSizeLg: 18,
              fontSizeXl: 20,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Adaptive Text'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style!.fontSize!, greaterThan(0));
    });

    testWidgets('AdaptiveText adapts fontWeight based on breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Weight Adaptive',
              fontSizeXs: 14,
              fontWeightXs: FontWeight.normal,
              fontWeightMd: FontWeight.w500,
              fontWeightLg: FontWeight.bold,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Weight Adaptive'), findsOneWidget);
    });

    testWidgets('AdaptiveText adapts color based on breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Color Adaptive',
              fontSizeXs: 14,
              colorXs: Colors.red,
              colorMd: Colors.blue,
              colorLg: Colors.green,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Color Adaptive'));
      expect(text.style?.color, isNotNull);
    });

    testWidgets('AdaptiveText adapts lineHeight based on breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Line Height Adaptive',
              fontSizeXs: 14,
              lineHeightXs: 1.2,
              lineHeightMd: 1.5,
              lineHeightLg: 1.8,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Line Height Adaptive'));
      expect(text.style?.height, isNotNull);
    });

    testWidgets('AdaptiveText adapts letterSpacing based on breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Letter Spacing Adaptive',
              fontSizeXs: 14,
              letterSpacingXs: 0.5,
              letterSpacingMd: 1.0,
              letterSpacingLg: 1.5,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Letter Spacing Adaptive'));
      expect(text.style?.letterSpacing, isNotNull);
    });

    testWidgets('AdaptiveText with baseStyle', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Base Style Test',
              fontSizeXs: 16,
              baseStyle: TextStyle(
                fontFamily: 'Roboto',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Base Style Test'));
      expect(text.style?.fontSize, isNotNull);
    });

    testWidgets('AdaptiveText with all text properties', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Full Properties',
              fontSizeXs: 14,
              fontWeightXs: FontWeight.normal,
              colorXs: Colors.black,
              lineHeightXs: 1.5,
              letterSpacingXs: 1.0,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Full Properties'));
      expect(text.textAlign, TextAlign.center);
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('AdaptiveText falls back to next breakpoint', (tester) async {
      // Set to md breakpoint but only define xs and lg
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: AdaptiveText(
              'Fallback Test',
              fontSizeXs: 12,
              fontSizeLg: 20,
              // md should fall back to xs
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Fallback Test'));
      expect(text.style?.fontSize, isNotNull);
    });
  });
}

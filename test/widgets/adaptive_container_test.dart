import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_screenutil_plus/src/core/_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    ScreenUtilPlus.configure(
      data: const MediaQueryData(size: Size(800, 600)),
      designSize: defaultSize,
      minTextAdapt: true,
      splitScreenMode: false,
    );
  });

  group('AdaptiveContainer', () {
    testWidgets('renders with width for current breakpoint', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(400, 800)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: AdaptiveContainer(
              width: {Breakpoint.xs: 100, Breakpoint.md: 200},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
      final Container container = tester.widget(find.byType(Container));
      // Width is scaled: 100 * (400/360) = 111.11...
      const double expectedWidth = 100 * (400 / 360);
      expect(container.constraints?.maxWidth, closeTo(expectedWidth, 0.01));
      expect(container.constraints?.minWidth, closeTo(expectedWidth, 0.01));
    });

    testWidgets('renders with height for current breakpoint', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 600)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(
              height: {Breakpoint.md: 200, Breakpoint.lg: 300},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // Height is scaled: 200 * (600/690) = 173.91...
      const double expectedHeight = 200 * (600 / 690);
      expect(container.constraints?.maxHeight, closeTo(expectedHeight, 0.01));
      expect(container.constraints?.minHeight, closeTo(expectedHeight, 0.01));
    });

    testWidgets('falls back to smaller breakpoint when current not found', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 600)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(
              width: {Breakpoint.sm: 150, Breakpoint.lg: 300},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // At md breakpoint, should fall back to sm (smaller)
      // Width is scaled: 150 * (800/360) = 333.33...
      const double expectedWidth = 150 * (800 / 360);
      expect(container.constraints?.maxWidth, closeTo(expectedWidth, 0.01));
      expect(container.constraints?.minWidth, closeTo(expectedWidth, 0.01));
    });

    testWidgets('falls back to larger breakpoint when no smaller found', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(400, 800)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: AdaptiveContainer(
              width: {Breakpoint.lg: 300},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // At xs breakpoint, no smaller breakpoints, should use lg
      // Width is scaled: 300 * (400/360) = 333.33...
      const double expectedWidth = 300 * (400 / 360);
      expect(container.constraints?.maxWidth, closeTo(expectedWidth, 0.01));
      expect(container.constraints?.minWidth, closeTo(expectedWidth, 0.01));
    });

    testWidgets('renders with padding for current breakpoint', (tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(600, 800)),
            child: AdaptiveContainer(
              padding: {
                Breakpoint.sm: EdgeInsets.all(8),
                Breakpoint.md: EdgeInsets.all(16),
              },
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(8));
    });

    testWidgets('renders with margin for current breakpoint', (tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1000, 600)),
            child: AdaptiveContainer(
              margin: {Breakpoint.lg: EdgeInsets.all(24)},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.margin, const EdgeInsets.all(24));
    });

    testWidgets('renders with decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
      expect((container.decoration! as BoxDecoration).color, Colors.blue);
    });

    testWidgets('renders with color convenience property', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(color: Colors.red, child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
      expect((container.decoration! as BoxDecoration).color, Colors.red);
    });

    testWidgets('uses custom breakpoints', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(500, 800)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      const customBreakpoints = Breakpoints(sm: 500, md: 800);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(500, 800)),
            child: AdaptiveContainer(
              breakpoints: customBreakpoints,
              width: {Breakpoint.sm: 200, Breakpoint.md: 300},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // With custom breakpoints, 500px should match sm
      // Width is scaled: 200 * (500/360) = 277.78...
      const double expectedWidth = 200 * (500 / 360);
      expect(container.constraints?.maxWidth, closeTo(expectedWidth, 0.01));
      expect(container.constraints?.minWidth, closeTo(expectedWidth, 0.01));
    });

    testWidgets('renders with alignment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(
              alignment: Alignment.center,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.alignment, Alignment.center);
    });

    testWidgets('renders with constraints', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(
              constraints: BoxConstraints(maxWidth: 500),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.constraints?.maxWidth, 500);
    });

    testWidgets('renders with transform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(
              transform: Matrix4.rotationZ(0.1),
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.transform, isNotNull);
    });
  });

  group('SimpleAdaptiveContainer', () {
    testWidgets('renders with width properties', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 600)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: SimpleAdaptiveContainer(
              widthXs: 100,
              widthSm: 150,
              widthMd: 200,
              widthLg: 300,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
      final Container container = tester.widget(find.byType(Container));
      // At md breakpoint, should use widthMd
      // Width is scaled: 200 * (800/360) = 444.44...
      const double expectedWidth = 200 * (800 / 360);
      expect(container.constraints?.maxWidth, closeTo(expectedWidth, 0.01));
      expect(container.constraints?.minWidth, closeTo(expectedWidth, 0.01));
    });

    testWidgets('renders with height properties', (tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1000, 600)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1000, 600)),
            child: SimpleAdaptiveContainer(
              heightXs: 100,
              heightSm: 150,
              heightMd: 200,
              heightLg: 300,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // At lg breakpoint, should use heightLg
      // Height is scaled: 300 * (600/690) = 260.87...
      const double expectedHeight = 300 * (600 / 690);
      expect(container.constraints?.maxHeight, closeTo(expectedHeight, 0.01));
      expect(container.constraints?.minHeight, closeTo(expectedHeight, 0.01));
    });

    testWidgets('renders with padding properties', (tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(600, 800)),
            child: SimpleAdaptiveContainer(
              paddingXs: 8,
              paddingSm: 12,
              paddingMd: 16,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // At sm breakpoint, should use paddingSm
      expect(container.padding, const EdgeInsets.all(12));
    });

    testWidgets('renders with color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: SimpleAdaptiveContainer(
              color: Colors.green,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect((container.decoration! as BoxDecoration).color, Colors.green);
    });

    testWidgets('renders with decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: SimpleAdaptiveContainer(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('uses custom breakpoints', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(500, 800)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      const customBreakpoints = Breakpoints(sm: 500, md: 800);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(500, 800)),
            child: SimpleAdaptiveContainer(
              breakpoints: customBreakpoints,
              widthXs: 100,
              widthSm: 200,
              widthMd: 300,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // With custom breakpoints, 500px should match sm
      // Width is scaled: 200 * (500/360) = 277.78...
      const double expectedWidth = 200 * (500 / 360);
      expect(container.constraints?.maxWidth, closeTo(expectedWidth, 0.01));
      expect(container.constraints?.minWidth, closeTo(expectedWidth, 0.01));
    });

    testWidgets('handles all breakpoint sizes', (tester) async {
      tester.view.physicalSize = const Size(1500, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1500, 600)),
        designSize: defaultSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1500, 600)),
            child: SimpleAdaptiveContainer(
              widthXs: 50,
              widthSm: 100,
              widthMd: 150,
              widthLg: 200,
              widthXl: 250,
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // At xxl breakpoint, should fall back to xl
      // Width is scaled: 250 * (1500/360) = 1041.67...
      const double expectedWidth = 250 * (1500 / 360);
      expect(container.constraints?.maxWidth, closeTo(expectedWidth, 0.01));
      expect(container.constraints?.minWidth, closeTo(expectedWidth, 0.01));
    });
  });
}

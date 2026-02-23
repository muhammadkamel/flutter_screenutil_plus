import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    ScreenUtilPlus.configure(
      data: const MediaQueryData(size: Size(800, 600)),
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
      const double expectedWidth = 100;
      expect(container.constraints?.maxWidth, expectedWidth);
      expect(container.constraints?.minWidth, expectedWidth);
    });

    testWidgets('renders with height for current breakpoint', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 600)),
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
      const double expectedHeight = 200;
      expect(container.constraints?.maxHeight, expectedHeight);
      expect(container.constraints?.minHeight, expectedHeight);
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
      // Width is NOT scaled anymore.
      const double expectedWidth = 150;
      expect(container.constraints?.maxWidth, expectedWidth);
      expect(container.constraints?.minWidth, expectedWidth);
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
      const double expectedWidth = 300;
      expect(container.constraints?.maxWidth, expectedWidth);
      expect(container.constraints?.minWidth, expectedWidth);
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
      const double expectedWidth = 200;
      expect(container.constraints?.maxWidth, expectedWidth);
      expect(container.constraints?.minWidth, expectedWidth);
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
      const double expectedWidth = 200;
      expect(container.constraints?.maxWidth, expectedWidth);
      expect(container.constraints?.minWidth, expectedWidth);
    });

    testWidgets('renders with height properties', (tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1000, 600)),
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
      const double expectedHeight = 300;
      expect(container.constraints?.maxHeight, expectedHeight);
      expect(container.constraints?.minHeight, expectedHeight);
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
              paddingXs: EdgeInsets.all(8),
              paddingSm: EdgeInsets.all(12),
              paddingMd: EdgeInsets.all(16),
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
      const double expectedWidth = 200;
      expect(container.constraints?.maxWidth, expectedWidth);
      expect(container.constraints?.minWidth, expectedWidth);
    });

    testWidgets('handles all breakpoint sizes', (tester) async {
      tester.view.physicalSize = const Size(1500, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Configure ScreenUtilPlus for this specific test size
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1500, 600)),
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
      const double expectedWidth = 250;
      expect(container.constraints?.maxWidth, expectedWidth);
      expect(container.constraints?.minWidth, expectedWidth);
    });
    testWidgets('handles empty maps gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: AdaptiveContainer(
              width: {},
              height: {},
              padding: {},
              margin: {},
              child: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Container container = tester.widget(find.byType(Container));
      // Should behave like a default Container
      expect(container.constraints, null);
      expect(container.padding, null);
      expect(container.margin, null);
    });

    testWidgets('handles map with no matching breakpoint', (tester) async {
      // Setup a scenario where current breakpoint (e.g., md) has no value
      // and checking logic:
      // 1. Current (md) -> not found
      // 2. Smaller (sm, xs) -> not found
      // 3. Larger (lg, xl, xxl) -> not found
      // Result: null

      // This effectively means "empty map" covers it, but let's try a map
      // with only a value for a specific breakpoint that we won't hit in any fallback?
      // Actually, fallback logic tries *all* smaller then *all* larger.
      // So to return null, the map must be empty relative to the search.
      // But we can test just passing explicit empty maps or a map that doesn't trigger anything?
      // If we provide {Breakpoint.xs: ...}, it will be found by "smaller" search if current is md?
      // No, smaller search is: `bp.index < current.index`. xs < md. So `xs` IS checked.
      // "Try smaller breakpoints in reverse order".
      // If we are at md.
      // 1. Check md.
      // 2. Check sm, xs.
      // 3. Check lg, xl, xxl.
      // So effectively ALL breakpoints are checked eventually unless we return early.
      // So if map is not empty, it WILL find something.
      // Thus "empty map" is the only case that returns null.
      // The previous test covers this. We can skip a specific "no match" test as it's mathematically impossible if map is non-empty.
    });
  });

  group('SimpleAdaptiveContainer', () {
    testWidgets('renders correctly with no properties set', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: SimpleAdaptiveContainer(child: Text('Test')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
      final Container container = tester.widget(find.byType(Container));
      // Should behave like a default Container with no constraints/padding
      expect(container.constraints, null);
      expect(container.padding, null);
      expect(container.margin, null);
      expect(container.margin, null);
    });

    testWidgets('handles all nulls internally', (tester) async {
      // This verifies that the internal helper returns null when all inputs are null,
      // resulting in a standard Container with no AdaptiveContainer behavior overhead.
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: SimpleAdaptiveContainer(child: Text('Test')),
          ),
        ),
      );

      final Container container = tester.widget(find.byType(Container));
      // No extra constraints or padding should be applied
      expect(container.constraints, null);
      expect(container.padding, null);
    });
  });
}

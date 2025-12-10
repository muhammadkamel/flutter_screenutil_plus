import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coverage Gaps', () {
    testWidgets('AdaptiveContainer _getValueForBreakpoint fallback logic', (
      tester,
    ) async {
      // We can't access private _getValueForBreakpoint directly, but we can verify behavior via build.
      // Case 1: Exact match
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) => const MaterialApp(
            home: AdaptiveContainer(width: {Breakpoint.md: 100}),
          ),
        ),
      );
      // Set screen size to MD (768-992). 800 is MD.
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpAndSettle();
      expect(
        tester.widget<Container>(find.byType(Container)).constraints?.minWidth,
        100.w,
      );

      // Case 2: Fallback to smaller (current LG, value at MD)
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) => const MaterialApp(
            home: AdaptiveContainer(width: {Breakpoint.md: 100}),
          ),
        ),
      );
      // Set screen size to LG (1000). Should pick MD value (100).
      tester.view.physicalSize = const Size(1000, 600);
      await tester.pumpAndSettle();
      expect(
        tester.widget<Container>(find.byType(Container)).constraints?.minWidth,
        100.w,
      );

      // Case 3: Fallback to larger (current XS, value at MD)
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) => const MaterialApp(
            home: AdaptiveContainer(width: {Breakpoint.md: 100}),
          ),
        ),
      );
      // Set size to XS (400). Should pick MD value.
      tester.view.physicalSize = const Size(400, 600);
      await tester.pumpAndSettle();
      expect(
        tester.widget<Container>(find.byType(Container)).constraints?.minWidth,
        100.w,
      );

      // Case 4: No value
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) =>
              const MaterialApp(home: AdaptiveContainer(width: {})),
        ),
      );
      await tester.pumpAndSettle();
      // Width/Constraints should be null on Container
      expect(
        tester.widget<Container>(find.byType(Container)).constraints,
        isNull,
      );
    });

    testWidgets('SimpleAdaptiveContainer maps properties correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) => const MaterialApp(
            home: SimpleAdaptiveContainer(
              widthXs: 10,
              widthSm: 20,
              widthMd: 30,
              widthLg: 40,
              widthXl: 50,
              heightXs: 10,
              heightSm: 20,
              paddingXs: 10,
              paddingMd: 30,
              color: Colors.red,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdaptiveContainer), findsOneWidget);
    });

    testWidgets('AdaptiveText _getAdaptiveValue logic', (tester) async {
      // Test letterSpacing, fontWeight, color
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) => const MaterialApp(
            home: AdaptiveText(
              'Test',
              letterSpacingXs: 1.0,
              fontWeightXs: FontWeight.bold,
              colorXs: Colors.red,
              baseStyle: TextStyle(fontSize: 10),
            ),
          ),
        ),
      );

      tester.view.physicalSize = const Size(400, 600); // XS
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpAndSettle();

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.letterSpacing, 1.0);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.color, Colors.red);
      expect(
        text.style?.fontSize,
        10,
      ); // baseStyle preserved (and maybe not scaled if not provided?)

      // Test fallback: provide only Md, current Xs
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) =>
              const MaterialApp(home: AdaptiveText('Test', fontSizeMd: 20)),
        ),
      );
      await tester.pumpAndSettle();
      final Text text2 = tester.widget<Text>(find.byType(Text));
      expect(text2.style?.fontSize, 20.sp);
    });

    testWidgets('REdgeInsetsDirectional usage in Padding', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          builder: (c, _) => MaterialApp(
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: REdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Container(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final Padding padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, isA<REdgeInsetsDirectional>());
      // .resolve should return scaled values?
      // REdgeInsetsDirectional constructs with scaled values immediately via super call.
      final EdgeInsets resolved = padding.padding.resolve(TextDirection.ltr);
      expect(resolved.left, 10.r);
    });
  });
}

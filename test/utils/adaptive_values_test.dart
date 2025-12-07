import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveValues', () {
    testWidgets('creates instance from context with default breakpoints', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                expect(adaptive.context, context);
                expect(adaptive.breakpoints, Breakpoints.bootstrap);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('creates instance from context with custom breakpoints', (
      tester,
    ) async {
      const customBreakpoints = Breakpoints(sm: 500, md: 800);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(
                  context,
                  breakpoints: customBreakpoints,
                );
                expect(adaptive.breakpoints, customBreakpoints);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('width returns responsive width value', (tester) async {
      const deviceSize = Size(720, 1380);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final double width = adaptive.width(xs: 100, sm: 200, md: 300);
                // At xs breakpoint (< 576px), should use xs value (100)
                // Then apply .w scaling: 100 * (720/360) = 200
                expect(width, 200);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('width falls back to larger breakpoints', (tester) async {
      const deviceSize = Size(720, 1380);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                // At xs breakpoint, no xs value, should fall back to sm
                final double width = adaptive.width(sm: 200, md: 300);
                expect(width, 400); // 200 * 2
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('height returns responsive height value', (tester) async {
      const deviceSize = Size(720, 1380);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final double height = adaptive.height(md: 100, lg: 200);
                // At md breakpoint, should use md value (100)
                // Then apply .h scaling: 100 * (1380/690) = 200
                expect(height, 200);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('fontSize returns responsive font size value', (tester) async {
      const deviceSize = Size(720, 1380);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1000, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final double fontSize = adaptive.fontSize(lg: 16, xl: 20);
                // At lg breakpoint, should use lg value (16)
                // Then apply .sp scaling
                expect(fontSize, greaterThan(0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('radius returns responsive radius value', (tester) async {
      const deviceSize = Size(720, 1380);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(600, 800)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final double radius = adaptive.radius(sm: 8, md: 12);
                // At sm breakpoint, should use sm value (8)
                // Then apply .r scaling
                expect(radius, greaterThan(0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('padding returns responsive padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final EdgeInsets padding = adaptive.padding(
                  xs: const EdgeInsets.all(8),
                  md: const EdgeInsets.all(16),
                );
                // At md breakpoint, should use md value
                expect(padding, const EdgeInsets.all(16));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('padding falls back to larger breakpoints first', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                // At md breakpoint, no md value, should fall back to lg first
                final EdgeInsets padding = adaptive.padding(
                  xs: const EdgeInsets.all(8),
                  lg: const EdgeInsets.all(24),
                );
                expect(padding, const EdgeInsets.all(24));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('margin returns responsive margin', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1000, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final EdgeInsets margin = adaptive.margin(
                  md: const EdgeInsets.all(16),
                  lg: const EdgeInsets.all(24),
                );
                // At lg breakpoint, should use lg value
                expect(margin, const EdgeInsets.all(24));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('margin uses padding internally', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final EdgeInsets margin = adaptive.margin(
                  xs: const EdgeInsets.all(8),
                );
                // margin should call padding internally
                expect(margin, const EdgeInsets.all(8));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('supports all breakpoint sizes', (tester) async {
      const deviceSize = Size(720, 1380);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1500, 600)),
            child: Builder(
              builder: (context) {
                final adaptive = AdaptiveValues.of(context);
                final double width = adaptive.width(
                  xs: 50,
                  sm: 100,
                  md: 150,
                  lg: 200,
                  xl: 250,
                  xxl: 300,
                );
                // At xxl breakpoint, should use xxl value (300)
                expect(width, 600); // 300 * 2
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('AdaptiveValuesExtension', () {
    testWidgets('provides adaptive extension on BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final AdaptiveValues adaptive = context.adaptive();
                expect(adaptive, isA<AdaptiveValues>());
                expect(adaptive.breakpoints, Breakpoints.bootstrap);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('provides adaptive extension with custom breakpoints', (
      tester,
    ) async {
      const customBreakpoints = Breakpoints(sm: 500);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final AdaptiveValues adaptive = context.adaptive(
                  breakpoints: customBreakpoints,
                );
                expect(adaptive.breakpoints, customBreakpoints);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}

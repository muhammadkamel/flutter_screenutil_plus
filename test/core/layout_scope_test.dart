import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const viewport = Size(1440, 900);

  Future<void> setView(WidgetTester tester) async {
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget wrap({required Widget child}) {
    return MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: viewport),
        child: Scaffold(body: child),
      ),
    );
  }

  group('LayoutScope', () {
    testWidgets('outside scope uses viewport metrics', (tester) async {
      await setView(tester);

      late Breakpoint breakpoint;
      late SizeClasses sizeClasses;

      await tester.pumpWidget(
        wrap(
          child: Builder(
            builder: (context) {
              breakpoint = ResponsiveQuery.of(context).breakpoint;
              sizeClasses = context.sizeClasses;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Bootstrap: 1440 >= xxl (1400)
      expect(breakpoint, Breakpoint.xxl);
      expect(sizeClasses.horizontal, SizeClass.regular);
    });

    testWidgets('inside scope uses local constraints', (tester) async {
      await setView(tester);

      late Breakpoint breakpoint;
      late double width;

      await tester.pumpWidget(
        wrap(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 320,
              height: 600,
              child: LayoutScope(
                child: ResponsiveBuilder(
                  xs: (context) {
                    breakpoint = ResponsiveQuery.of(context).breakpoint;
                    width = ResponsiveQuery.of(context).width;
                    return const Text('compact');
                  },
                  md: (context) => const Text('expanded'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('compact'), findsOneWidget);
      expect(breakpoint, Breakpoint.xs);
      expect(width, 320);
    });

    testWidgets('nested scope uses nearest size', (tester) async {
      await setView(tester);

      late double outerWidth;
      late double innerWidth;

      await tester.pumpWidget(
        wrap(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 800,
              height: 600,
              child: LayoutScope(
                child: Builder(
                  builder: (context) {
                    outerWidth = ResponsiveQuery.of(context).width;
                    return Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 320,
                        height: 600,
                        child: LayoutScope(
                          child: Builder(
                            builder: (context) {
                              innerWidth = ResponsiveQuery.of(context).width;
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      expect(outerWidth, 800);
      expect(innerWidth, 320);
    });

    testWidgets('unbounded height falls back to viewport height', (
      tester,
    ) async {
      await setView(tester);

      late Size scopeSize;

      await tester.pumpWidget(
        wrap(
          child: SizedBox(
            width: 400,
            child: ListView(
              children: [
                LayoutScope(
                  child: Builder(
                    builder: (context) {
                      scopeSize = LayoutScope.sizeOf(context);
                      return const SizedBox(height: 100);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(scopeSize.width, 400);
      expect(scopeSize.height, viewport.height);
    });

    testWidgets('SizeClassBuilder respects LayoutScope', (tester) async {
      await setView(tester);

      await tester.pumpWidget(
        wrap(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              height: 500,
              child: LayoutScope(
                child: SizeClassBuilder(
                  compact: (_) => const Text('compact'),
                  regular: (_) => const Text('regular'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('compact'), findsOneWidget);
      expect(find.text('regular'), findsNothing);
    });
  });
}

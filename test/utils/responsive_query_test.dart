import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveQuery', () {
    testWidgets('creates instance from context with default breakpoints', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                expect(query.context, context);
                expect(query.breakpoints, Breakpoints.bootstrap);
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
                final query = ResponsiveQuery.of(
                  context,
                  breakpoints: customBreakpoints,
                );
                expect(query.breakpoints, customBreakpoints);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('width returns screen width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                expect(query.width, 800);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('height returns screen height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                expect(query.height, 600);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('breakpoint returns current breakpoint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                // 800px is md breakpoint (>= 768, < 992)
                expect(query.breakpoint, Breakpoint.md);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('sizeClasses returns SizeClasses instance', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                expect(query.sizeClasses, isA<SizeClasses>());
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('isAtLeast returns true for larger breakpoints', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                // At md (800px), should be at least sm and md
                expect(query.isAtLeast(Breakpoint.xs), true);
                expect(query.isAtLeast(Breakpoint.sm), true);
                expect(query.isAtLeast(Breakpoint.md), true);
                expect(query.isAtLeast(Breakpoint.lg), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('isLessThan returns true for smaller breakpoints', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                // At md (800px), should be less than lg and xl
                expect(query.isLessThan(Breakpoint.lg), true);
                expect(query.isLessThan(Breakpoint.xl), true);
                expect(query.isLessThan(Breakpoint.md), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('isBetween returns true when width is between breakpoints', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                // 800px is between sm (576) and lg (992)
                expect(query.isBetween(Breakpoint.sm, Breakpoint.lg), true);
                expect(query.isBetween(Breakpoint.md, Breakpoint.lg), true);
                expect(query.isBetween(Breakpoint.xs, Breakpoint.sm), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('isExactly returns true for current breakpoint', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final query = ResponsiveQuery.of(context);
                expect(query.isExactly(Breakpoint.md), true);
                expect(query.isExactly(Breakpoint.sm), false);
                expect(query.isExactly(Breakpoint.lg), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    group('value', () {
      testWidgets('returns value for current breakpoint', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  final int value = query.value(xs: 10, sm: 20, md: 30, lg: 40);
                  // At md breakpoint, should return md value
                  expect(value, 30);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('falls back to larger breakpoints when current not found', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  // At md breakpoint, no md value, should fall back to lg
                  final int value = query.value(xs: 10, sm: 20, lg: 40);
                  expect(value, 40);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('falls back to smaller breakpoints when larger not found', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  // At md breakpoint, no md or larger values, should fall back to sm
                  final int value = query.value(xs: 10, sm: 20);
                  expect(value, 20);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('handles all breakpoint sizes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(1500, 600)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  final int value = query.value(
                    xs: 10,
                    sm: 20,
                    md: 30,
                    lg: 40,
                    xl: 50,
                    xxl: 60,
                  );
                  // At xxl breakpoint, should return xxl value
                  expect(value, 60);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('valueBySizeClass', () {
      testWidgets('returns regular for regular size class', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  final int value = query.valueBySizeClass(
                    compact: 1,
                    regular: 3,
                  );
                  // 800px width should be regular
                  expect(value, 3);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('returns compact for compact size class', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(400, 600)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  final int value = query.valueBySizeClass(
                    compact: 1,
                    regular: 3,
                  );
                  // 400px width should be compact
                  expect(value, 1);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('valueByHorizontalSizeClass', () {
      testWidgets('returns regular for regular horizontal size class', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  final int value = query.valueByHorizontalSizeClass(
                    compact: 1,
                    regular: 3,
                  );
                  expect(value, 3);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('valueByVerticalSizeClass', () {
      testWidgets('returns regular for regular vertical size class', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(800, 800)),
              child: Builder(
                builder: (context) {
                  final query = ResponsiveQuery.of(context);
                  final int value = query.valueByVerticalSizeClass(
                    compact: 1,
                    regular: 3,
                  );
                  expect(value, 3);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });
  });

  group('ResponsiveQueryExtension', () {
    testWidgets('provides responsive extension on BuildContext', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                final ResponsiveQuery query = context.responsive();
                expect(query, isA<ResponsiveQuery>());
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('provides breakpoint getter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                expect(context.breakpoint, Breakpoint.md);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('provides isAtLeast extension method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                expect(context.isAtLeast(Breakpoint.md), true);
                expect(context.isAtLeast(Breakpoint.lg), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('provides isLessThan extension method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                expect(context.isLessThan(Breakpoint.lg), true);
                expect(context.isLessThan(Breakpoint.md), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('provides isBetween extension method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                expect(context.isBetween(Breakpoint.sm, Breakpoint.lg), true);
                expect(context.isBetween(Breakpoint.xs, Breakpoint.sm), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('provides isExactly extension method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Builder(
              builder: (context) {
                expect(context.isExactly(Breakpoint.md), true);
                expect(context.isExactly(Breakpoint.sm), false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}

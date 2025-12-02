import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Breakpoints and Responsive Builders Integration Tests', () {
    testWidgets('ResponsiveBuilder shows xs widget on small screen', (
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
          child: Scaffold(
            body: ResponsiveBuilder(
              xs: (context) => const Text('Mobile Layout'),
              md: (context) => const Text('Tablet Layout'),
              lg: (context) => const Text('Desktop Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mobile Layout'), findsOneWidget);
      expect(find.text('Tablet Layout'), findsNothing);
      expect(find.text('Desktop Layout'), findsNothing);
    });

    testWidgets('ResponsiveBuilder shows md widget on medium screen', (
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
            body: ResponsiveBuilder(
              xs: (context) => const Text('Mobile Layout'),
              md: (context) => const Text('Tablet Layout'),
              lg: (context) => const Text('Desktop Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Tablet Layout'), findsOneWidget);
    });

    testWidgets('ResponsiveBuilder shows lg widget on large screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: ResponsiveBuilder(
              xs: (context) => const Text('Mobile Layout'),
              md: (context) => const Text('Tablet Layout'),
              lg: (context) => const Text('Desktop Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Desktop Layout'), findsOneWidget);
    });

    testWidgets('ResponsiveBuilder falls back to next breakpoint', (
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
            body: ResponsiveBuilder(
              xs: (context) => const Text('Mobile'),
              lg: (context) => const Text('Desktop'),
              // md should fall back to lg (prefers larger breakpoints first)
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At md breakpoint, with only xs and lg defined, it falls back to lg first
      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets('ResponsiveBuilder falls back to smaller breakpoint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: ResponsiveBuilder(
              xs: (context) => const Text('Mobile'),
              // sm breakpoint but only xs defined, should fall back to xs
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // At sm breakpoint, with only xs defined, it falls back to xs
      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('ResponsiveBuilder with custom breakpoints', (tester) async {
      final customBreakpoints = const Breakpoints(
        xs: 0,
        sm: 400,
        md: 800,
        lg: 1200,
        xl: 1600,
        xxl: 2000,
      );

      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: ResponsiveBuilder(
              xs: (context) => const Text('XS'),
              md: (context) => const Text('MD'),
              breakpoints: customBreakpoints,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('MD'), findsOneWidget);
    });

    testWidgets('ResponsiveBuilder with fallback widget', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: ResponsiveBuilder(fallback: const Text('Fallback Widget')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Fallback Widget'), findsOneWidget);
    });

    testWidgets('SizeClassBuilder with compact size class', (tester) async {
      // Use size where both dimensions are < 600 to ensure isCompact is true
      tester.view.physicalSize = const Size(400, 500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: SizeClassBuilder(
              compact: (context) => const Text('Compact Layout'),
              regular: (context) => const Text('Regular Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Compact Layout'), findsOneWidget);
    });

    testWidgets('SizeClassBuilder with regular size class', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: SizeClassBuilder(
              compact: (context) => const Text('Compact Layout'),
              regular: (context) => const Text('Regular Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Regular Layout'), findsOneWidget);
    });

    testWidgets('SizeClassBuilder with horizontal size class', (tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: SizeClassBuilder(
              horizontal: (context, sizeClass) {
                return Text('Horizontal: $sizeClass');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Horizontal:'), findsOneWidget);
    });

    testWidgets('SizeClassBuilder with vertical size class', (tester) async {
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
            body: SizeClassBuilder(
              vertical: (context, sizeClass) {
                return Text('Vertical: $sizeClass');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Vertical:'), findsOneWidget);
    });

    testWidgets('SizeClassBuilder with full builder', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: SizeClassBuilder(
              builder: (context, sizeClasses) {
                return Text(
                  'H: ${sizeClasses.horizontal}, V: ${sizeClasses.vertical}',
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('H:'), findsOneWidget);
      expect(find.textContaining('V:'), findsOneWidget);
    });

    testWidgets('SizeClassBuilder with custom threshold', (tester) async {
      tester.view.physicalSize = const Size(500, 500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: SizeClassBuilder(
              threshold: 400,
              compact: (context) => const Text('Compact'),
              regular: (context) => const Text('Regular'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Regular'), findsOneWidget);
    });

    testWidgets('ConditionalBuilder with breakpoint condition', (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: ConditionalBuilder(
              condition: (context) => context.isAtLeast(Breakpoint.md),
              builder: (context) => const Text('Desktop View'),
              fallback: (context) => const Text('Mobile View'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Desktop View'), findsOneWidget);
    });

    testWidgets('ConditionalBuilder with fallback', (tester) async {
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
            body: ConditionalBuilder(
              condition: (context) => context.isAtLeast(Breakpoint.md),
              builder: (context) => const Text('Desktop View'),
              fallback: (context) => const Text('Mobile View'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mobile View'), findsOneWidget);
    });

    testWidgets('ConditionalBuilder without fallback', (tester) async {
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
            body: ConditionalBuilder(
              condition: (context) => context.isAtLeast(Breakpoint.md),
              builder: (context) => const Text('Desktop View'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show nothing when condition is false and no fallback
      expect(find.text('Desktop View'), findsNothing);
    });

    testWidgets('ResponsiveQuery.isAtLeast works correctly', (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final isAtLeastMd = context.isAtLeast(Breakpoint.md);
              return Scaffold(body: Text('Is at least MD: $isAtLeastMd'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Is at least MD: true'), findsOneWidget);
    });

    testWidgets('ResponsiveQuery.isLessThan works correctly', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final isLessThanMd = context.isLessThan(Breakpoint.md);
              return Scaffold(body: Text('Is less than MD: $isLessThanMd'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Is less than MD: true'), findsOneWidget);
    });

    testWidgets('ResponsiveQuery.isBetween works correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final isBetween = context.isBetween(Breakpoint.sm, Breakpoint.lg);
              return Scaffold(body: Text('Is between SM and LG: $isBetween'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Is between'), findsOneWidget);
    });

    testWidgets('ResponsiveQuery.isExactly works correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final isExactlyMd = context.isExactly(Breakpoint.md);
              return Scaffold(body: Text('Is exactly MD: $isExactlyMd'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Is exactly MD:'), findsOneWidget);
    });

    testWidgets('ResponsiveQuery.value returns correct value', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final padding = ResponsiveQuery.of(
                context,
              ).value(xs: 8.0, sm: 12.0, md: 16.0, lg: 24.0);
              return Scaffold(body: Text('Padding: $padding'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Padding: 16.0'), findsOneWidget);
    });

    testWidgets('ResponsiveQuery.valueBySizeClass works correctly', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final columns = ResponsiveQuery.of(
                context,
              ).valueBySizeClass(compact: 1, regular: 3);
              return Scaffold(body: Text('Columns: $columns'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Columns: 3'), findsOneWidget);
    });

    testWidgets('Breakpoints.bootstrap preset works', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final breakpoint = context.breakpoint;
              return Scaffold(body: Text('Breakpoint: $breakpoint'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Breakpoint:'), findsOneWidget);
    });

    testWidgets('Breakpoints.tailwind preset works', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final query = ResponsiveQuery.of(
                context,
                breakpoints: Breakpoints.tailwind,
              );
              return Scaffold(body: Text('Breakpoint: ${query.breakpoint}'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Breakpoint:'), findsOneWidget);
    });

    testWidgets('Breakpoints.material preset works', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final query = ResponsiveQuery.of(
                context,
                breakpoints: Breakpoints.material,
              );
              return Scaffold(body: Text('Breakpoint: ${query.breakpoint}'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Breakpoint:'), findsOneWidget);
    });

    testWidgets('Breakpoints.mobileFirst preset works', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final query = ResponsiveQuery.of(
                context,
                breakpoints: Breakpoints.mobileFirst,
              );
              return Scaffold(body: Text('Breakpoint: ${query.breakpoint}'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Breakpoint:'), findsOneWidget);
    });
  });
}

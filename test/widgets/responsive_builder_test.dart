import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveBuilder', () {
    testWidgets('shows xs widget when breakpoint is xs', (tester) async {
      // Set screen size to xs breakpoint (< 576px)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder(
              xs: (context) => const Text('XS Layout'),
              sm: (context) => const Text('SM Layout'),
              md: (context) => const Text('MD Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('XS Layout'), findsOneWidget);
      expect(find.text('SM Layout'), findsNothing);
      expect(find.text('MD Layout'), findsNothing);
    });

    testWidgets('shows sm widget when breakpoint is sm', (tester) async {
      // Set screen size to sm breakpoint (>= 576px, < 768px)
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(600, 800)),
            child: ResponsiveBuilder(
              xs: (context) => const Text('XS Layout'),
              sm: (context) => const Text('SM Layout'),
              md: (context) => const Text('MD Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('SM Layout'), findsOneWidget);
      expect(find.text('XS Layout'), findsNothing);
      expect(find.text('MD Layout'), findsNothing);
    });

    testWidgets('shows md widget when breakpoint is md', (tester) async {
      // Set screen size to md breakpoint (>= 768px, < 992px)
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: ResponsiveBuilder(
              xs: (context) => const Text('XS Layout'),
              sm: (context) => const Text('SM Layout'),
              md: (context) => const Text('MD Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('MD Layout'), findsOneWidget);
      expect(find.text('XS Layout'), findsNothing);
      expect(find.text('SM Layout'), findsNothing);
    });

    testWidgets('shows lg widget when breakpoint is lg', (tester) async {
      // Set screen size to lg breakpoint (>= 992px, < 1200px)
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1000, 600)),
            child: ResponsiveBuilder(
              md: (context) => const Text('MD Layout'),
              lg: (context) => const Text('LG Layout'),
              xl: (context) => const Text('XL Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('LG Layout'), findsOneWidget);
      expect(find.text('MD Layout'), findsNothing);
      expect(find.text('XL Layout'), findsNothing);
    });

    testWidgets('shows xl widget when breakpoint is xl', (tester) async {
      // Set screen size to xl breakpoint (>= 1200px, < 1400px)
      tester.view.physicalSize = const Size(1300, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1300, 600)),
            child: ResponsiveBuilder(
              lg: (context) => const Text('LG Layout'),
              xl: (context) => const Text('XL Layout'),
              xxl: (context) => const Text('XXL Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('XL Layout'), findsOneWidget);
      expect(find.text('LG Layout'), findsNothing);
      expect(find.text('XXL Layout'), findsNothing);
    });

    testWidgets('shows xxl widget when breakpoint is xxl', (tester) async {
      // Set screen size to xxl breakpoint (>= 1400px)
      tester.view.physicalSize = const Size(1500, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1500, 600)),
            child: ResponsiveBuilder(
              lg: (context) => const Text('LG Layout'),
              xl: (context) => const Text('XL Layout'),
              xxl: (context) => const Text('XXL Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('XXL Layout'), findsOneWidget);
      expect(find.text('LG Layout'), findsNothing);
      expect(find.text('XL Layout'), findsNothing);
    });

    testWidgets('falls back to sm when xs is not provided', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder(
              sm: (context) => const Text('SM Layout'),
              md: (context) => const Text('MD Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('SM Layout'), findsOneWidget);
      expect(find.text('MD Layout'), findsNothing);
    });

    testWidgets('falls back to md when sm is not provided', (tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(600, 800)),
            child: ResponsiveBuilder(
              xs: (context) => const Text('XS Layout'),
              md: (context) => const Text('MD Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('MD Layout'), findsOneWidget);
      expect(find.text('XS Layout'), findsNothing);
    });

    testWidgets('falls back to lg when md is not provided', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: ResponsiveBuilder(
              sm: (context) => const Text('SM Layout'),
              lg: (context) => const Text('LG Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('LG Layout'), findsOneWidget);
      expect(find.text('SM Layout'), findsNothing);
    });

    testWidgets('falls back to xl when lg is not provided', (tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1000, 600)),
            child: ResponsiveBuilder(
              md: (context) => const Text('MD Layout'),
              xl: (context) => const Text('XL Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('XL Layout'), findsOneWidget);
      expect(find.text('MD Layout'), findsNothing);
    });

    testWidgets('falls back to xxl when xl is not provided', (tester) async {
      tester.view.physicalSize = const Size(1300, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1300, 600)),
            child: ResponsiveBuilder(
              lg: (context) => const Text('LG Layout'),
              xxl: (context) => const Text('XXL Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('XXL Layout'), findsOneWidget);
      expect(find.text('LG Layout'), findsNothing);
    });

    testWidgets('falls back to xs when xxl is not provided', (tester) async {
      tester.view.physicalSize = const Size(1500, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1500, 600)),
            child: ResponsiveBuilder(
              xs: (context) => const Text('XS Layout'),
              xl: (context) => const Text('XL Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('XL Layout'), findsOneWidget);
      expect(find.text('XS Layout'), findsNothing);
    });

    testWidgets('uses fallback widget when no builders match', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder(fallback: Text('Fallback Widget')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Fallback Widget'), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when no builders and no fallback', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      final SizedBox sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 0.0);
      expect(sizedBox.height, 0.0);
    });

    testWidgets('uses custom breakpoints when provided', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Custom breakpoints where sm is 500px
      const customBreakpoints = Breakpoints(sm: 500, md: 800, lg: 1000);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(500, 800)),
            child: ResponsiveBuilder(
              breakpoints: customBreakpoints,
              xs: (context) => const Text('XS Layout'),
              sm: (context) => const Text('SM Layout'),
              md: (context) => const Text('MD Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // With custom breakpoints, 500px should match sm
      expect(find.text('SM Layout'), findsOneWidget);
      expect(find.text('XS Layout'), findsNothing);
      expect(find.text('MD Layout'), findsNothing);
    });

    testWidgets('handles complex fallback chain correctly', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder(
              // Only provide lg, should fall back through the chain
              lg: (context) => const Text('LG Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // xs breakpoint should fall back to lg (xs -> sm -> md -> lg -> xl -> xxl -> xs)
      expect(find.text('LG Layout'), findsOneWidget);
    });

    testWidgets('handles reverse fallback chain for xxl', (tester) async {
      tester.view.physicalSize = const Size(1500, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1500, 600)),
            child: ResponsiveBuilder(
              // Only provide xs, should fall back through the chain
              xs: (context) => const Text('XS Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // xxl breakpoint should fall back to xl -> lg -> md -> sm -> xs
      expect(find.text('XS Layout'), findsOneWidget);
    });
  });

  group('SizeClassBuilder', () {
    testWidgets('shows compact widget for compact size class', (tester) async {
      tester.view.physicalSize = const Size(400, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 400)),
            child: SizeClassBuilder(
              threshold: 500,
              compact: (context) => const Text('Compact Layout'),
              regular: (context) => const Text('Regular Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Compact Layout'), findsOneWidget);
      expect(find.text('Regular Layout'), findsNothing);
    });

    testWidgets('shows regular widget for regular size class', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(
              compact: (context) => const Text('Compact Layout'),
              regular: (context) => const Text('Regular Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Regular Layout'), findsOneWidget);
      expect(find.text('Compact Layout'), findsNothing);
    });

    testWidgets('uses horizontal builder when provided', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(
              horizontal: (context, sizeClass) {
                if (sizeClass == SizeClass.regular) {
                  return const Text('Regular Horizontal');
                }
                return const Text('Compact Horizontal');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Regular Horizontal'), findsOneWidget);
    });

    testWidgets('uses vertical builder when provided', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: SizeClassBuilder(
              vertical: (context, sizeClass) {
                if (sizeClass == SizeClass.regular) {
                  return const Text('Regular Vertical');
                }
                return const Text('Compact Vertical');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Regular Vertical'), findsOneWidget);
    });

    testWidgets('uses builder with full size class information', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(
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

    testWidgets('falls back to regular when compact not provided', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 600)),
            child: SizeClassBuilder(
              regular: (context) => const Text('Regular Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Regular Layout'), findsOneWidget);
    });

    testWidgets('falls back to compact when regular not provided', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(
              compact: (context) => const Text('Compact Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Compact Layout'), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when no builders provided', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      final SizedBox sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 0.0);
      expect(sizedBox.height, 0.0);
    });

    testWidgets('uses custom threshold', (tester) async {
      tester.view.physicalSize = const Size(500, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(500, 600)),
            child: SizeClassBuilder(
              threshold: 400,
              compact: (context) => const Text('Compact Layout'),
              regular: (context) => const Text('Regular Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // With threshold 400, 500px width should be regular
      expect(find.text('Regular Layout'), findsOneWidget);
    });

    testWidgets(
      'builder takes priority over horizontal/vertical/compact/regular',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: SizeClassBuilder(
                builder: (c, s) => const Text('Builder'),
                horizontal: (c, s) => const Text('Horizontal'),
                vertical: (c, s) => const Text('Vertical'),
                compact: (c) => const Text('Compact'),
                regular: (c) => const Text('Regular'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Builder'), findsOneWidget);
      },
    );

    testWidgets('horizontal takes priority over vertical/compact/regular', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(
              horizontal: (c, s) => const Text('Horizontal'),
              vertical: (c, s) => const Text('Vertical'),
              compact: (c) => const Text('Compact'),
              regular: (c) => const Text('Regular'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Horizontal'), findsOneWidget);
    });

    testWidgets('vertical takes priority over compact/regular', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(
              vertical: (c, s) => const Text('Vertical'),
              compact: (c) => const Text('Compact'),
              regular: (c) => const Text('Regular'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Vertical'), findsOneWidget);
    });

    testWidgets('regular takes priority over compact if regular size class', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: SizeClassBuilder(
              regular: (c) => const Text('Regular'),
              compact: (c) => const Text('Compact'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Regular'), findsOneWidget);
    });
  });

  group('ConditionalBuilder', () {
    testWidgets('shows builder widget when condition is true', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: ConditionalBuilder(
              condition: (context) => context.isAtLeast(Breakpoint.md),
              builder: (context) => const Text('Desktop Layout'),
              fallback: (context) => const Text('Mobile Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Desktop Layout'), findsOneWidget);
      expect(find.text('Mobile Layout'), findsNothing);
    });

    testWidgets('shows fallback widget when condition is false', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 600)),
            child: ConditionalBuilder(
              condition: (context) => context.isAtLeast(Breakpoint.md),
              builder: (context) => const Text('Desktop Layout'),
              fallback: (context) => const Text('Mobile Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mobile Layout'), findsOneWidget);
      expect(find.text('Desktop Layout'), findsNothing);
    });

    testWidgets(
      'returns SizedBox.shrink when condition false and no fallback',
      (tester) async {
        tester.view.physicalSize = const Size(400, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(400, 600)),
              child: ConditionalBuilder(
                condition: (context) => context.isAtLeast(Breakpoint.md),
                builder: (context) => const Text('Desktop Layout'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Desktop Layout'), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
        final SizedBox sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox),
        );
        expect(sizedBox.width, 0.0);
        expect(sizedBox.height, 0.0);
      },
    );

    testWidgets('handles complex conditions', (tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1000, 600)),
            child: ConditionalBuilder(
              condition: (context) =>
                  context.isBetween(Breakpoint.md, Breakpoint.xl),
              builder: (context) => const Text('Tablet Layout'),
              fallback: (context) => const Text('Other Layout'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1000px is between md (768) and xl (1200)
      expect(find.text('Tablet Layout'), findsOneWidget);
      expect(find.text('Other Layout'), findsNothing);
    });
  });
}

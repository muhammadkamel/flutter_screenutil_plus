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
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder(fallback: const Text('Fallback Widget')),
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
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 0.0);
      expect(sizedBox.height, 0.0);
    });

    testWidgets('uses custom breakpoints when provided', (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Custom breakpoints where sm is 500px
      final customBreakpoints = Breakpoints(
        xs: 0,
        sm: 500,
        md: 800,
        lg: 1000,
        xl: 1200,
        xxl: 1400,
      );

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
}

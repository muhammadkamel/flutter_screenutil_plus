import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Extensions Integration Tests', () {
    testWidgets('AdaptiveValues.width returns responsive width', (
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
          child: Builder(
            builder: (context) {
              final width = AdaptiveValues.of(
                context,
              ).width(xs: 50, sm: 100, md: 150, lg: 200);
              return Scaffold(
                body: Container(
                  width: width,
                  height: 50,
                  color: Colors.blue,
                  child: const Text('Adaptive Width'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Adaptive Width'), findsOneWidget);
    });

    testWidgets('AdaptiveValues.height returns responsive height', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final height = AdaptiveValues.of(
                context,
              ).height(xs: 50, sm: 100, md: 150, lg: 200);
              return Scaffold(
                body: Container(
                  width: 100,
                  height: height,
                  color: Colors.red,
                  child: const Text('Adaptive Height'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Adaptive Height'), findsOneWidget);
    });

    testWidgets('AdaptiveValues.fontSize returns responsive fontSize', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final fontSize = AdaptiveValues.of(
                context,
              ).fontSize(xs: 12, sm: 14, md: 16, lg: 18);
              return Scaffold(
                body: Text(
                  'Adaptive Font Size',
                  style: TextStyle(fontSize: fontSize),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Adaptive Font Size'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style!.fontSize!, greaterThan(0));
    });

    testWidgets('AdaptiveValues.radius returns responsive radius', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final radius = AdaptiveValues.of(
                context,
              ).radius(xs: 4, sm: 8, md: 12, lg: 16);
              return Scaffold(
                body: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: const Text('Adaptive Radius'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Adaptive Radius'), findsOneWidget);
    });

    testWidgets('AdaptiveValues.padding returns responsive padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final padding = AdaptiveValues.of(context).padding(
                xs: const EdgeInsets.all(8),
                sm: const EdgeInsets.all(12),
                md: const EdgeInsets.all(16),
                lg: const EdgeInsets.all(24),
              );
              return Scaffold(
                body: Container(
                  padding: padding,
                  color: Colors.orange,
                  child: const Text('Adaptive Padding'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Adaptive Padding'), findsOneWidget);
    });

    testWidgets('AdaptiveValues.margin returns responsive margin', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final margin = AdaptiveValues.of(context).margin(
                xs: const EdgeInsets.all(8),
                sm: const EdgeInsets.all(12),
                md: const EdgeInsets.all(16),
                lg: const EdgeInsets.all(24),
              );
              return Scaffold(
                body: Container(
                  margin: margin,
                  color: Colors.purple,
                  child: const Text('Adaptive Margin'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Adaptive Margin'), findsOneWidget);
    });

    testWidgets('AdaptiveValues with custom breakpoints', (tester) async {
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
          child: Builder(
            builder: (context) {
              final width = AdaptiveValues.of(
                context,
                breakpoints: customBreakpoints,
              ).width(xs: 50, md: 200);
              return Scaffold(
                body: Container(
                  width: width,
                  height: 50,
                  color: Colors.teal,
                  child: const Text('Custom Breakpoints'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom Breakpoints'), findsOneWidget);
    });

    testWidgets('AdaptiveTextStyleExtension creates adaptive text style', (
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
          child: Builder(
            builder: (context) {
              final style = context.adaptiveTextStyle(
                fontSizeXs: 12,
                fontSizeSm: 14,
                fontSizeMd: 16,
                fontSizeLg: 18,
                fontWeightXs: FontWeight.normal,
                fontWeightLg: FontWeight.bold,
                colorXs: Colors.red,
                colorLg: Colors.blue,
              );
              return Scaffold(body: Text('Adaptive Text Style', style: style));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Adaptive Text Style'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style!.fontSize!, greaterThan(0));
    });

    testWidgets('AdaptiveTextStyleExtension with baseStyle', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final style = context.adaptiveTextStyle(
                fontSizeXs: 16,
                baseStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  decoration: TextDecoration.underline,
                ),
              );
              return Scaffold(body: Text('Base Style Test', style: style));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Base Style Test'));
      expect(text.style?.fontSize, isNotNull);
    });

    testWidgets('AdaptiveTextStyleExtension with lineHeight', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final style = context.adaptiveTextStyle(
                fontSizeXs: 14,
                lineHeightXs: 1.2,
                lineHeightMd: 1.5,
                lineHeightLg: 1.8,
              );
              return Scaffold(body: Text('Line Height Test', style: style));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Line Height Test'));
      expect(text.style?.height, isNotNull);
    });

    testWidgets('TextStyleExtension.r makes text responsive', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Text(
              'Responsive Text',
              style: const TextStyle(fontSize: 16).r,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Responsive Text'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style!.fontSize!, greaterThan(0));
    });

    testWidgets('TextStyleExtension.withLineHeight works correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Text(
              'Line Height Text',
              style: const TextStyle(fontSize: 16).withLineHeight(1.5),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Line Height Text'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style?.height, 1.5);
    });

    testWidgets('TextStyleExtension.withAutoLineHeight works correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Text(
              'Auto Line Height',
              style: const TextStyle(fontSize: 16).withAutoLineHeight(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Auto Line Height'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style?.height, 1.2);
    });

    testWidgets('TextStyleExtension.withLineHeightFromFigma works correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Text(
              'Figma Line Height',
              style: const TextStyle(fontSize: 20).withLineHeightFromFigma(14),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Figma Line Height'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style?.height, closeTo(0.7, 0.01));
    });

    testWidgets('TextStyleExtension.r preserves height multiplier', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Text(
              'Preserved Height',
              style: const TextStyle(fontSize: 16, height: 1.5).r,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Preserved Height'));
      expect(text.style?.fontSize, isNotNull);
      expect(text.style?.height, 1.5);
    });

    testWidgets('TextStyleExtension.r with null fontSize returns unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Text(
              'No Font Size',
              style: const TextStyle(color: Colors.red).r,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('No Font Size'));
      expect(text.style?.fontSize, isNull);
      expect(text.style?.color, Colors.red);
    });

    testWidgets('Context extension breakpoint works', (tester) async {
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
              final breakpoint = context.breakpoint;
              return Scaffold(body: Text('Breakpoint: $breakpoint'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Breakpoint:'), findsOneWidget);
    });

    testWidgets('Context extension sizeClasses works', (tester) async {
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
              final sizeClasses = context.sizeClasses;
              return Scaffold(
                body: Text(
                  'Size Classes: ${sizeClasses.horizontal}, ${sizeClasses.vertical}',
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Size Classes:'), findsOneWidget);
    });

    testWidgets('Context extension horizontalSizeClass works', (tester) async {
      tester.view.physicalSize = const Size(800, 400);
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
              final sizeClass = context.horizontalSizeClass;
              return Scaffold(body: Text('Horizontal: $sizeClass'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Horizontal:'), findsOneWidget);
    });

    testWidgets('Context extension verticalSizeClass works', (tester) async {
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
              final sizeClass = context.verticalSizeClass;
              return Scaffold(body: Text('Vertical: $sizeClass'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Vertical:'), findsOneWidget);
    });
  });
}

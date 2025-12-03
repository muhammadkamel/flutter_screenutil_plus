import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Helper class to track build count
class _BuildCounter {
  int count = 0;
}

// Custom widget that will be rebuilt (not in flutterWidgets list)
class _BuildCounterWidget extends StatelessWidget {
  final _BuildCounter counter;
  const _BuildCounterWidget(this.counter);

  @override
  Widget build(BuildContext context) {
    counter.count++;
    return Scaffold(body: Center(child: Text('Build Count: ${counter.count}')));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('ScreenUtilPlusInit initializes correctly with MaterialApp', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(body: Center(child: Text('Test App'))),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the app rendered
      expect(find.text('Test App'), findsOneWidget);

      // Verify ScreenUtil is initialized
      final util = ScreenUtilPlus();
      expect(util.screenWidth, greaterThan(0));
      expect(util.screenHeight, greaterThan(0));
    });

    testWidgets('ResponsiveTheme integration with MaterialApp', (tester) async {
      // Set screen size larger than design size to ensure scaling occurs
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: const TextTheme(
                    headlineLarge: TextStyle(fontSize: 32),
                    bodyLarge: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Headline', style: theme.textTheme.headlineLarge),
                      Text('Body', style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Headline'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);

      // Verify theme text styles are scaled
      final headlineText = tester.widget<Text>(find.text('Headline'));
      final bodyText = tester.widget<Text>(find.text('Body'));

      expect(headlineText.style?.fontSize, greaterThan(32));
      expect(bodyText.style?.fontSize, greaterThan(16));
    });

    testWidgets('Basic responsive sizing across different screen sizes', (
      tester,
    ) async {
      // Test with default screen size
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Container(
                  key: const Key('responsive_container'),
                  width: 100.w,
                  height: 50.h,
                  color: Colors.blue,
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byKey(const Key('responsive_container')),
      );
      expect(container.color, Colors.blue);

      // Verify responsive sizing is applied
      final util = ScreenUtilPlus();
      expect(util.setWidth(100), greaterThan(0));
      expect(util.setHeight(50), greaterThan(0));
    });

    testWidgets('Orientation changes update ScreenUtil', (tester) async {
      // Set initial view size to portrait
      tester.view.physicalSize = const Size(600, 800);
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
              final util = ScreenUtilPlus();
              return Scaffold(
                body: Center(child: Text('Orientation: ${util.orientation}')),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial orientation should be portrait
      final util = ScreenUtilPlus();
      expect(util.orientation, Orientation.portrait);

      // Simulate landscape by changing screen size
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpAndSettle();

      // Orientation should update to landscape
      expect(util.orientation, Orientation.landscape);
    });

    testWidgets('Split screen mode behavior', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final util = ScreenUtilPlus();
              return Scaffold(
                body: Center(child: Text('Scale Height: ${util.scaleHeight}')),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final util = ScreenUtilPlus();
      expect(util.scaleHeight, greaterThan(0));

      // With split screen mode, height scaling should account for minimum height
      expect(find.textContaining('Scale Height:'), findsOneWidget);
    });

    testWidgets('Multiple responsive widgets in widget tree', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Test', style: TextStyle(fontSize: 20.sp)),
                ),
                body: Column(
                  children: [
                    Container(width: 100.w, height: 50.h, color: Colors.red),
                    RContainer(width: 200, height: 100, color: Colors.blue),
                    RText(
                      'Responsive Text',
                      style: const TextStyle(fontSize: 16),
                    ),
                    RSizedBox(width: 50, height: 25),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all widgets rendered
      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Responsive Text'), findsOneWidget);
      expect(find.byType(RSizedBox), findsOneWidget);
    });

    testWidgets('ensureScreenSize parameter works correctly', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          ensureScreenSize: true,
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: Center(child: Text('Screen Size Ensured')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Screen Size Ensured'), findsOneWidget);

      // Verify ScreenUtil is initialized
      final util = ScreenUtilPlus();
      expect(util.screenWidth, greaterThan(0));
      expect(util.screenHeight, greaterThan(0));
    });

    testWidgets('RebuildFactor.size triggers rebuild on size change', (
      tester,
    ) async {
      // Use a mutable object to track build count
      final buildCounter = _BuildCounter();

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          rebuildFactor: RebuildFactors.size,
          responsiveWidgets: ['_BuildCounterWidget'],
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: _BuildCounterWidget(buildCounter),
        ),
      );

      await tester.pumpAndSettle();
      final initialBuildCount = buildCounter.count;
      expect(
        initialBuildCount,
        greaterThan(0),
      ); // Ensure initial build happened

      // Change screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Explicitly trigger metrics change
      tester.binding.handleMetricsChanged();
      await tester.pump();
      await tester.pumpAndSettle();

      // Build count should increase due to size change
      expect(buildCounter.count, greaterThan(initialBuildCount));
    });

    testWidgets('Custom fontSizeResolver works correctly', (tester) async {
      double customResolver(num fontSize, ScreenUtilPlus instance) {
        return fontSize * 1.5;
      }

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          fontSizeResolver: customResolver,
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: Text('Custom Font', style: TextStyle(fontSize: 16.sp)),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Custom Font'));
      // Font size should be 16 * 1.5 = 24
      expect(textWidget.style?.fontSize, 24.0);
    });

    testWidgets('enableScaleWH and enableScaleText work correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          enableScaleWH: () => false,
          enableScaleText: () => false,
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              final util = ScreenUtilPlus();
              return Scaffold(
                body: Center(
                  child: Text('Scale: ${util.scaleWidth}, ${util.scaleText}'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final util = ScreenUtilPlus();
      // Scaling should be disabled (scale = 1.0)
      expect(util.scaleWidth, 1.0);
      expect(util.scaleText, 1.0);
    });

    testWidgets(
      'RebuildFactor.orientation triggers rebuild on orientation change',
      (tester) async {
        final buildCounter = _BuildCounter();

        tester.view.physicalSize = const Size(600, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            designSize: const Size(360, 690),
            rebuildFactor: RebuildFactors.orientation,
            responsiveWidgets: ['_BuildCounterWidget'],
            builder: (context, child) {
              return MaterialApp(home: child);
            },
            child: _BuildCounterWidget(buildCounter),
          ),
        );

        await tester.pumpAndSettle();
        final initialBuildCount = buildCounter.count;

        // Change orientation
        tester.view.physicalSize = const Size(800, 600);
        tester.binding.handleMetricsChanged();
        await tester.pump();
        await tester.pumpAndSettle();

        expect(buildCounter.count, greaterThan(initialBuildCount));
      },
    );

    testWidgets('RebuildFactor.change triggers rebuild on any change', (
      tester,
    ) async {
      final buildCounter = _BuildCounter();

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          rebuildFactor: RebuildFactors.change,
          responsiveWidgets: ['_BuildCounterWidget'],
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: _BuildCounterWidget(buildCounter),
        ),
      );

      await tester.pumpAndSettle();
      final initialBuildCount = buildCounter.count;

      // Change screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.binding.handleMetricsChanged();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(buildCounter.count, greaterThan(initialBuildCount));
    });

    testWidgets('RebuildFactor.always triggers rebuild always', (tester) async {
      final buildCounter = _BuildCounter();

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          rebuildFactor: RebuildFactors.always,
          responsiveWidgets: ['_BuildCounterWidget'],
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: _BuildCounterWidget(buildCounter),
        ),
      );

      await tester.pumpAndSettle();
      final initialBuildCount = buildCounter.count;
      expect(initialBuildCount, greaterThan(0));

      // Trigger a MediaQuery change - with always rebuild factor, it should rebuild
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      tester.binding.handleMetricsChanged();
      await tester.pump();
      await tester.pumpAndSettle();

      // With always rebuild factor, it should rebuild on any MediaQuery change
      expect(buildCounter.count, greaterThan(initialBuildCount));
    });

    testWidgets('RebuildFactor.none never triggers rebuild', (tester) async {
      final buildCounter = _BuildCounter();

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          rebuildFactor: RebuildFactors.none,
          responsiveWidgets: ['_BuildCounterWidget'],
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: _BuildCounterWidget(buildCounter),
        ),
      );

      await tester.pumpAndSettle();
      final initialBuildCount = buildCounter.count;

      // Change screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.binding.handleMetricsChanged();
      await tester.pump();
      await tester.pumpAndSettle();

      // Build count should not increase
      expect(buildCounter.count, initialBuildCount);
    });

    testWidgets(
      'RebuildFactor.sizeAndViewInsets triggers on viewInsets change',
      (tester) async {
        final buildCounter = _BuildCounter();

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            designSize: const Size(360, 690),
            rebuildFactor: RebuildFactors.sizeAndViewInsets,
            responsiveWidgets: ['_BuildCounterWidget'],
            builder: (context, child) {
              return MaterialApp(home: child);
            },
            child: _BuildCounterWidget(buildCounter),
          ),
        );

        await tester.pumpAndSettle();
        final initialBuildCount = buildCounter.count;

        // Simulate view insets change (e.g., keyboard appears)
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        tester.binding.handleMetricsChanged();
        await tester.pump();
        await tester.pumpAndSettle();

        expect(buildCounter.count, greaterThan(initialBuildCount));
      },
    );

    testWidgets('minTextAdapt parameter works correctly', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Text('Min Text Adapt', style: TextStyle(fontSize: 16.sp)),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Min Text Adapt'));
      expect(text.style?.fontSize, isNotNull);
    });

    testWidgets('REdgeInsetsDirectional works correctly', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Container(
              padding: REdgeInsetsDirectional.all(16),
              color: Colors.blue,
              child: const Text('Directional Padding'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Directional Padding'), findsOneWidget);
    });

    testWidgets('Very small screen size handles correctly', (tester) async {
      tester.view.physicalSize = const Size(200, 300);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Container(
              width: 100.w,
              height: 50.h,
              color: Colors.red,
              child: const Text('Small Screen'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Small Screen'), findsOneWidget);
    });

    testWidgets('Very large screen size handles correctly', (tester) async {
      tester.view.physicalSize = const Size(2000, 1500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Container(
              width: 100.w,
              height: 50.h,
              color: Colors.blue,
              child: const Text('Large Screen'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Large Screen'), findsOneWidget);
    });

    testWidgets('Zero dimensions handled correctly', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Column(
              children: [
                Container(width: 0.w, height: 0.h, color: Colors.red),
                SizedBox(width: 0.w, height: 0.h),
                Text('Zero Test', style: TextStyle(fontSize: 0.sp)),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Zero Test'), findsOneWidget);
    });

    testWidgets('Multiple ScreenUtilPlusInit instances work independently', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              home: ScreenUtilPlusInit(
                designSize: const Size(400, 800),
                builder: (context, child) => child!,
                child: Scaffold(
                  body: Text('Nested Init', style: TextStyle(fontSize: 16.sp)),
                ),
              ),
            );
          },
          child: const Scaffold(body: Text('Outer Init')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Nested Init'), findsOneWidget);
    });
  });
}

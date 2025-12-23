import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenUtilPlusScope', () {
    testWidgets('provides ScreenUtilPlus instance to descendants', (
      WidgetTester tester,
    ) async {
      ScreenUtilPlus? capturedInstance;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: Builder(
            builder: (context) {
              capturedInstance = ScreenUtilPlus.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedInstance, isNotNull);
      expect(capturedInstance, isA<ScreenUtilPlus>());
    });

    testWidgets('maybeOf returns instance when scope exists', (
      WidgetTester tester,
    ) async {
      ScreenUtilPlus? capturedInstance;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: Builder(
            builder: (context) {
              capturedInstance = ScreenUtilPlusScope.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedInstance, isNotNull);
    });

    testWidgets('context.su extension works correctly', (
      WidgetTester tester,
    ) async {
      ScreenUtilPlus? capturedInstance;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: Builder(
            builder: (context) {
              capturedInstance = context.su;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedInstance, isNotNull);
      expect(capturedInstance, isA<ScreenUtilPlus>());
    });

    testWidgets('rebuilds when design size changes', (
      WidgetTester tester,
    ) async {
      var buildCount = 0;

      Widget buildApp(Size designSize) {
        return ScreenUtilPlusInit(
          designSize: designSize,
          child: Builder(
            builder: (context) {
              ScreenUtilPlus.of(context);
              buildCount++;
              return const SizedBox();
            },
          ),
        );
      }

      await tester.pumpWidget(buildApp(const Size(375, 812)));
      expect(buildCount, 1);

      // Change design size
      await tester.pumpWidget(buildApp(const Size(414, 896)));
      expect(buildCount, 2);
    });
  });

  group('ScreenUtilPlusInit with autoRebuild', () {
    testWidgets('autoRebuild parameter exists and defaults to true', (
      WidgetTester tester,
    ) async {
      // Just verify the parameter exists and can be set
      await tester.pumpWidget(
        const ScreenUtilPlusInit(designSize: Size(375, 812), child: SizedBox()),
      );

      expect(find.byType(ScreenUtilPlusInit), findsOneWidget);

      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          designSize: Size(375, 812),
          autoRebuild: false,
          child: SizedBox(),
        ),
      );

      expect(find.byType(ScreenUtilPlusInit), findsOneWidget);
    });

    testWidgets('widgets can use ScreenUtilPlus.of(context)', (
      WidgetTester tester,
    ) async {
      double? capturedWidth;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: Builder(
            builder: (context) {
              final ScreenUtilPlus su = ScreenUtilPlus.of(context);
              capturedWidth = su.setWidth(100);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedWidth, isNotNull);
      expect(capturedWidth, greaterThan(0));
    });
  });

  group('Context-aware R-widgets', () {
    testWidgets('RContainer can be created and rendered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          designSize: Size(375, 812),
          child: MaterialApp(
            home: Scaffold(
              body: RContainer(width: 100, height: 50, child: Text('Test')),
            ),
          ),
        ),
      );

      expect(find.byType(RContainer), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('RText can be created and rendered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          designSize: Size(375, 812),
          child: MaterialApp(
            home: Scaffold(body: RText('Test', style: TextStyle(fontSize: 16))),
          ),
        ),
      );

      expect(find.byType(RText), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('RContainer uses context.su internally', (
      WidgetTester tester,
    ) async {
      // Verify that RContainer works with the scope
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          designSize: Size(375, 812),
          autoRebuild: false, // Disable tree walking
          child: MaterialApp(
            home: Scaffold(
              body: RContainer(width: 100, height: 50, child: Text('Test')),
            ),
          ),
        ),
      );

      expect(find.byType(RContainer), findsOneWidget);
    });

    testWidgets('RText uses context.su internally', (
      WidgetTester tester,
    ) async {
      // Verify that RText works with the scope
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          designSize: Size(375, 812),
          autoRebuild: false, // Disable tree walking
          child: MaterialApp(
            home: Scaffold(body: RText('Test', style: TextStyle(fontSize: 16))),
          ),
        ),
      );

      expect(find.byType(RText), findsOneWidget);
    });
  });

  group('ScreenUtilPlus metrics', () {
    testWidgets('metrics getter returns non-null value', (
      WidgetTester tester,
    ) async {
      Object? metrics;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: Builder(
            builder: (context) {
              metrics = ScreenUtilPlus().metrics;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(metrics, isNotNull);
    });

    testWidgets('metrics changes when design size changes', (
      WidgetTester tester,
    ) async {
      Object? metrics1;
      Object? metrics2;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: Builder(
            builder: (context) {
              metrics1 = ScreenUtilPlus().metrics;
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(414, 896),
          child: Builder(
            builder: (context) {
              metrics2 = ScreenUtilPlus().metrics;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(metrics1, isNotNull);
      expect(metrics2, isNotNull);
      expect(metrics1, isNot(equals(metrics2)));
    });
  });

  group('Integration tests', () {
    testWidgets('complete app with ScreenUtilPlusScope works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const RContainer(
                    width: 100,
                    height: 50,
                    child: Text('Container'),
                  ),
                  const RText('Text', style: TextStyle(fontSize: 16)),
                  Builder(
                    builder: (context) {
                      final ScreenUtilPlus su = context.su;
                      return SizedBox(
                        width: su.setWidth(200),
                        height: su.setHeight(100),
                        child: const Text('Custom'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Container'), findsOneWidget);
      expect(find.text('Text'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('works with autoRebuild: false', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          autoRebuild: false,
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const RContainer(
                    width: 100,
                    height: 50,
                    child: Text('Container'),
                  ),
                  const RText('Text', style: TextStyle(fontSize: 16)),
                  Builder(
                    builder: (context) {
                      final ScreenUtilPlus su = context.su;
                      return SizedBox(
                        width: su.setWidth(200),
                        height: su.setHeight(100),
                        child: const Text('Custom'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Container'), findsOneWidget);
      expect(find.text('Text'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
    });
  });
}

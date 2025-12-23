import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveSizeContext Extension Tests', () {
    testWidgets('context.w() should scale width', (tester) async {
      late double result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.w(100);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, greaterThan(0));
    });

    testWidgets('context.h() should scale height', (tester) async {
      late double result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.h(50);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, greaterThan(0));
    });

    testWidgets('context.r() should scale radius', (tester) async {
      late double result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.r(10);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, greaterThan(0));
    });

    testWidgets('context.dg() should scale diagonal', (tester) async {
      late double result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.dg(10);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, greaterThan(0));
    });

    testWidgets('context.dm() should scale diameter', (tester) async {
      late double result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.dm(10);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, greaterThan(0));
    });

    testWidgets('context.sp() should scale font size', (tester) async {
      late double result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.sp(16);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, greaterThan(0));
    });

    testWidgets('context.spMin() should return minimum', (tester) async {
      late double result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.spMin(16);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, lessThanOrEqualTo(16));
    });

    testWidgets('context.verticalSpace() creates SizedBox', (tester) async {
      late SizedBox result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.verticalSpace(10);
                return result;
              },
            ),
          ),
        ),
      );

      expect(result.height, isNotNull);
      expect(result.height, greaterThan(0));
    });

    testWidgets('context.horizontalSpace() creates SizedBox', (tester) async {
      late SizedBox result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.horizontalSpace(20);
                return result;
              },
            ),
          ),
        ),
      );

      expect(result.width, isNotNull);
      expect(result.width, greaterThan(0));
    });

    testWidgets('context.edgeInsets(all:) creates EdgeInsets', (tester) async {
      late EdgeInsets result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.edgeInsets(all: 16);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result.left, result.right);
      expect(result.top, result.bottom);
      expect(result.left, greaterThan(0));
    });

    testWidgets(
      'context.edgeInsets(horizontal:, vertical:) creates EdgeInsets',
      (tester) async {
        late EdgeInsets result;

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            designSize: const Size(375, 812),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  result = context.edgeInsets(horizontal: 20, vertical: 10);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(result.left, result.right);
        expect(result.top, result.bottom);
        expect(result.left, greaterThan(0));
        expect(result.top, greaterThan(0));
      },
    );

    testWidgets(
      'context.edgeInsets with individual values creates EdgeInsets',
      (tester) async {
        late EdgeInsets result;

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            designSize: const Size(375, 812),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  result = context.edgeInsets(
                    left: 10,
                    top: 20,
                    right: 30,
                    bottom: 40,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(result.left, greaterThan(0));
        expect(result.top, greaterThan(0));
        expect(result.right, greaterThan(0));
        expect(result.bottom, greaterThan(0));
      },
    );

    testWidgets('context.borderRadius(all:) creates BorderRadius', (
      tester,
    ) async {
      late BorderRadius result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.borderRadius(all: 12);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result.topLeft.x, result.topRight.x);
      expect(result.topLeft.x, greaterThan(0));
    });

    testWidgets(
      'context.borderRadius with individual values creates BorderRadius',
      (tester) async {
        late BorderRadius result;

        await tester.pumpWidget(
          ScreenUtilPlusInit(
            designSize: const Size(375, 812),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  result = context.borderRadius(
                    topLeft: 10,
                    topRight: 20,
                    bottomLeft: 5,
                    bottomRight: 30,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(result.topLeft.x, greaterThan(0));
        expect(result.topRight.x, greaterThan(0));
        expect(result.bottomLeft.x, greaterThan(0));
        expect(result.bottomRight.x, greaterThan(0));
      },
    );

    testWidgets('context extensions work in widget tree', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Container(
                  width: context.w(100),
                  height: context.h(50),
                  padding: context.edgeInsets(all: 16),
                  decoration: BoxDecoration(
                    borderRadius: context.borderRadius(all: 12),
                  ),
                  child: Text(
                    'Hello',
                    style: TextStyle(fontSize: context.sp(16)),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });
  });
}

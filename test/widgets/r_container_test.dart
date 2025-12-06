import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_screenutil_plus/src/core/_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RContainer', () {
    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.noScaling,
        ),
        designSize: defaultSize,
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    testWidgets('adapts width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RContainer(width: 100, height: 100)),
      );

      final Container container = tester.widget<Container>(
        find.byType(Container),
      );
      final util = ScreenUtilPlus();

      // 100 * (400 / 360)
      expect(
        container.constraints?.maxWidth,
        closeTo(100 * util.scaleWidth, 0.001),
      );
      // 100 * (800 / 690)
      expect(
        container.constraints?.maxHeight,
        closeTo(100 * util.scaleHeight, 0.001),
      );
    });

    testWidgets('adapts padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RContainer(padding: EdgeInsets.all(10))),
      );

      final Container container = tester.widget<Container>(
        find.byType(Container),
      );
      final util = ScreenUtilPlus();
      final num expectedPadding = 10 * min(util.scaleWidth, util.scaleHeight);

      expect(container.padding, isA<EdgeInsets>());
      expect(
        (container.padding! as EdgeInsets).top,
        closeTo(expectedPadding, 0.001),
      );
    });

    testWidgets('adapts margin', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RContainer(margin: EdgeInsets.all(10))),
      );

      final Container container = tester.widget<Container>(
        find.byType(Container),
      );
      final util = ScreenUtilPlus();
      final num expectedMargin = 10 * min(util.scaleWidth, util.scaleHeight);

      expect(container.margin, isA<EdgeInsets>());
      expect(
        (container.margin! as EdgeInsets).top,
        closeTo(expectedMargin, 0.001),
      );
    });

    testWidgets('adapts constraints', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RContainer(
            constraints: BoxConstraints(
              minWidth: 10,
              maxWidth: 100,
              minHeight: 10,
              maxHeight: 100,
            ),
          ),
        ),
      );

      final Container container = tester.widget<Container>(
        find.byType(Container),
      );
      final util = ScreenUtilPlus();
      final double expectedScale = min(util.scaleWidth, util.scaleHeight);

      expect(
        container.constraints?.minWidth,
        closeTo(10 * expectedScale, 0.001),
      );
      expect(
        container.constraints?.maxWidth,
        closeTo(100 * expectedScale, 0.001),
      );
    });
  });
}

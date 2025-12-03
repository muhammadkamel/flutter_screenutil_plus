import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RContainer', () {
    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.linear(1.0),
        ),
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    testWidgets('adapts width and height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RContainer(width: 100, height: 100)),
      );

      final container = tester.widget<Container>(find.byType(Container));
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
        MaterialApp(home: RContainer(padding: const EdgeInsets.all(10))),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final util = ScreenUtilPlus();
      final expectedPadding = 10 * min(util.scaleWidth, util.scaleHeight);

      expect(container.padding, isA<EdgeInsets>());
      expect(
        (container.padding as EdgeInsets).top,
        closeTo(expectedPadding, 0.001),
      );
    });

    testWidgets('adapts margin', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RContainer(margin: const EdgeInsets.all(10))),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final util = ScreenUtilPlus();
      final expectedMargin = 10 * min(util.scaleWidth, util.scaleHeight);

      expect(container.margin, isA<EdgeInsets>());
      expect(
        (container.margin as EdgeInsets).top,
        closeTo(expectedMargin, 0.001),
      );
    });

    testWidgets('adapts constraints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RContainer(
            constraints: const BoxConstraints(
              minWidth: 10,
              maxWidth: 100,
              minHeight: 10,
              maxHeight: 100,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final util = ScreenUtilPlus();
      final expectedScale = min(util.scaleWidth, util.scaleHeight);

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

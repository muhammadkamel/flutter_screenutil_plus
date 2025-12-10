import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenUtilPlusInit', () {
    testWidgets('uses parent MediaQuery data if available', (tester) async {
      const parentSize = Size(500, 1000);
      const parentData = MediaQueryData(
        size: parentSize,
        devicePixelRatio: 2.0,
      );

      await tester.pumpWidget(
        MediaQuery(
          data: parentData,
          // ScreenUtilPlusInit inside MediaQuery
          child: ScreenUtilPlusInit(
            child: Builder(
              builder: (context) {
                // Verify ScreenUtil picked up the size
                expect(ScreenUtilPlus().screenWidth, parentSize.width);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('falls back to View data if no parent MediaQuery', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      // ScreenUtilPlusInit at root (no parent MediaQuery)
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          child: Builder(
            builder: (context) {
              // Should use view size (physical / pixelRatio) = 600x800
              expect(ScreenUtilPlus().screenWidth, 600);
              expect(ScreenUtilPlus().screenHeight, 800);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}

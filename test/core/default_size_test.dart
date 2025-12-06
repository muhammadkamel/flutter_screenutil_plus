import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_screenutil_plus/src/core/_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenUtilPlus Default Size', () {
    test(
      'ScreenUtilPlus.configure uses defaultSize when designSize is omitted',
      () {
        const data = MediaQueryData(
          size: defaultSize, // Same as default size
          textScaler: TextScaler.noScaling,
        );

        ScreenUtilPlus.configure(data: data, designSize: defaultSize);

        final util = ScreenUtilPlus();
        // Since device size matches default design size (360, 690), scale should be 1.0
        expect(util.scaleWidth, 1.0);
        expect(util.scaleHeight, 1.0);

        // Now let's try with a different device size
        const data2 = MediaQueryData(
          size: Size(720, 1380), // 2x default size
          textScaler: TextScaler.noScaling,
        );

        ScreenUtilPlus.configure(data: data2, designSize: defaultSize);

        // Should correlate to defaultSize (360, 690)
        expect(util.scaleWidth, 2.0);
        expect(util.scaleHeight, 2.0);
      },
    );

    testWidgets('ScreenUtilPlusInit uses defaultSize when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: defaultSize,
          builder: (context, child) {
            return MaterialApp(
              home: Builder(
                builder: (context) {
                  final util = ScreenUtilPlus();
                  return Text(
                    'ScaleW: ${util.scaleWidth}, ScaleH: ${util.scaleHeight}',
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
            );
          },
        ),
      );

      // By default test environment is 800x600.
      // 800 / 360 = 2.222...
      // 600 / 690 = 0.869...

      final util = ScreenUtilPlus();
      expect(util.scaleWidth, closeTo(800 / 360, 0.001));
      expect(util.scaleHeight, closeTo(600 / 690, 0.001));
    });
  });
}

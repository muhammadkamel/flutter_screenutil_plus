import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('deviceType fallback', () {
    testWidgets(
      'returns tablet on large screens when MediaQuery is missing using View fallback',
      (tester) async {
        // Simulate tablet size: 800x1200 (logical pixels if ratio is 1)
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;

        DeviceType? result;

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                result = ScreenUtilPlus().deviceType(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, DeviceType.tablet);

        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      },
    );

    testWidgets(
      'returns mobile on small screens when MediaQuery is missing using View fallback',
      (tester) async {
        // Simulate mobile size: 300x600
        tester.view.physicalSize = const Size(300, 600);
        tester.view.devicePixelRatio = 1.0;

        DeviceType? result;

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                result = ScreenUtilPlus().deviceType(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, DeviceType.mobile);

        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      },
    );
  });
}

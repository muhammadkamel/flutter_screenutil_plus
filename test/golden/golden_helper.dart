import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Package default design size (`Size(360, 690)`).
const Size goldenDesignSize = Size(360, 690);

/// Phone-sized viewport matching [goldenDesignSize].
const Size goldenPhoneSize = Size(360, 690);

/// Tablet-sized viewport (md breakpoint).
const Size goldenTabletSize = Size(768, 1024);

/// Desktop-sized viewport (lg+ breakpoint).
const Size goldenDesktopSize = Size(1280, 800);

/// Standard viewports used across golden scenarios.
const Map<String, Size> goldenScreenSizes = {
  'phone': goldenPhoneSize,
  'tablet': goldenTabletSize,
  'desktop': goldenDesktopSize,
};

/// Wraps [child] in a fixed viewport with [ScreenUtilPlusInit] for golden tests.
///
/// Each scenario should use its own wrapper so [ScreenUtilPlus] is configured
/// from that scenario's [MediaQuery] during build.
Widget screenUtilGoldenFrame({
  required Size screenSize,
  required Widget child,
  Size designSize = goldenDesignSize,
}) {
  return SizedBox(
    width: screenSize.width,
    height: screenSize.height,
    child: MediaQuery(
      data: MediaQueryData(
        size: screenSize,
        textScaler: TextScaler.noScaling,
      ),
      child: ScreenUtilPlusInit(
        designSize: designSize,
        child: ColoredBox(
          color: const Color(0xFFFFFFFF),
          child: Center(child: child),
        ),
      ),
    ),
  );
}

/// Pumps [widget] under [ScreenUtilPlusInit] for Alchemist `pumpWidget`.
Future<void> pumpScreenUtilGolden(
  WidgetTester tester,
  Widget widget, {
  Size screenSize = goldenPhoneSize,
  Size designSize = goldenDesignSize,
}) {
  return tester.pumpWidget(
    ScreenUtilPlusInit(
      designSize: designSize,
      child: MediaQuery(
        data: MediaQueryData(
          size: screenSize,
          textScaler: TextScaler.noScaling,
        ),
        child: widget,
      ),
    ),
  );
}

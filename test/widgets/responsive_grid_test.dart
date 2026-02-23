import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveGrid child widths', () {
    testWidgets('takes full width by default (span 12)', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      const screenSize = Size(1200, 800);
      ScreenUtilPlus.configure(data: const MediaQueryData(size: screenSize));

      final GlobalKey<State<StatefulWidget>> key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: screenSize),
            child: Scaffold(
              body: ResponsiveGrid(
                children: [
                  ResponsiveGridItem(
                    child: Container(key: key, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final Size containerSize = tester.getSize(find.byKey(key));
      // Takes up the entire 1200 row
      expect(containerSize.width, 1200);
    });

    testWidgets('adapts based on breakpoints (e.g lg: 6 -> half width)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      const screenSize = Size(1200, 800); // 1200 is lg
      ScreenUtilPlus.configure(data: const MediaQueryData(size: screenSize));

      final GlobalKey<State<StatefulWidget>> key1 = GlobalKey();
      final GlobalKey<State<StatefulWidget>> key2 = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: screenSize),
            child: Scaffold(
              body: ResponsiveGrid(
                children: [
                  ResponsiveGridItem(
                    lg: 6, // 6/12 = 50%
                    child: Container(key: key1, color: Colors.red),
                  ),
                  ResponsiveGridItem(
                    lg: 6, // 6/12 = 50%
                    child: Container(key: key2, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final Size size1 = tester.getSize(find.byKey(key1));
      final Size size2 = tester.getSize(find.byKey(key2));

      expect(size1.width, 600);
      expect(size2.width, 600);
    });

    testWidgets('falls back to smaller breakpoint if current is null', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1300, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      const screenSize = Size(1300, 800); // 1300 is xl
      ScreenUtilPlus.configure(data: const MediaQueryData(size: screenSize));

      final GlobalKey<State<StatefulWidget>> key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: screenSize),
            child: Scaffold(
              body: ResponsiveGrid(
                children: [
                  ResponsiveGridItem(
                    md: 3, // 3/12 = 25%. Should fallback to this on xl.
                    child: Container(key: key, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final Size size = tester.getSize(find.byKey(key));

      // 1/4th of 1300 is 325
      expect(size.width, 325);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../home.test.dart';

void main() {
  const smallerDeviceSize = Size(300, 600);
  const smallerDeviceData = MediaQueryData(size: smallerDeviceSize);

  const biggerDeviceSize = Size(500, 900);
  const biggerDeviceData = MediaQueryData(size: biggerDeviceSize);

  const uiSize = Size(470, 740);

  group('[Test calculations]', () {
    test('Test smaller size', () {
      ScreenUtilPlus.configure(
        data: smallerDeviceData,
        designSize: uiSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      expect(1.w, smallerDeviceSize.width / uiSize.width);
      expect(1.w < 1, true);
      expect(1.h, smallerDeviceSize.height / uiSize.height);
      expect(1.h < 1, true);
    });

    test('Test bigger size', () {
      ScreenUtilPlus.configure(
        data: biggerDeviceData,
        designSize: uiSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      expect(1.w, biggerDeviceSize.width / uiSize.width);
      expect(1.w > 1, true);
      expect(1.h, biggerDeviceSize.height / uiSize.height);
      expect(1.h > 1, true);
    });
  });

  group('[Test overflow]', () {
    testWidgets('Test overflow width', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: uiSize,
          child: MaterialApp(home: WidgetTest(width: () => uiSize.width.w)),
        ),
      );

      // Wait until all widget rendered
      await tester.pumpAndSettle();

      // a Text widget must be present
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('Test overflow height', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: uiSize,
          child: MaterialApp(home: WidgetTest(height: () => uiSize.height.h)),
        ),
      );

      // Wait until all widget rendered
      await tester.pumpAndSettle();

      // a Text widget must be present
      expect(find.text('Test'), findsOneWidget);
    });
  });

  testWidgets('[Rebuilding]', (tester) async {
    final textFieldKey = UniqueKey();
    final ValueNotifier<int> buildCountNotifier = ValueNotifier(0);
    final focusNode = FocusNode();

    Finder textField() => find.byKey(textFieldKey);

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: uiSize,
        rebuildFactor: RebuildFactors.always,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                buildCountNotifier.value += 1;

                assert(
                  uiSize.width.w == MediaQuery.maybeOf(context)?.size.width,
                );

                return SizedBox(
                  width: 1.sw,
                  child: Column(
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: buildCountNotifier,
                        builder: (_, count, _) => Text('Built count: $count'),
                      ),
                      TextField(key: textFieldKey, focusNode: focusNode),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(buildCountNotifier.value, 1);

    expect(textField(), findsOneWidget);
    expect(focusNode.hasFocus, false);

    await tester.tap(textField()).then((_) => tester.pumpAndSettle());
    expect(textField(), findsOneWidget);
    expect(focusNode.hasFocus, true);
    expect(buildCountNotifier.value, 1);

    // Simulate keyboard
    tester.view.viewInsets = const FakeViewPadding(bottom: 20);

    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, true);
    expect(buildCountNotifier.value, 1);
  });

  group('[Core Functionality]', () {
    testWidgets('registerToBuild rebuilds widget', (tester) async {
      var buildCount = 0;
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: uiSize,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                ScreenUtilPlus.registerToBuild(context);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, 1);

      // Trigger a metric change which calls _rebuildRegisteredElements
      // We can force it by calling configure with different data
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(100, 100)),
        designSize: uiSize,
      );

      await tester.pumpAndSettle();
      expect(buildCount, 2);
    });

    testWidgets('deviceType returns mobile by default', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(360, 690)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                expect(ScreenUtilPlus().deviceType(context), DeviceType.mobile);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('deviceType returns tablet on large screens', (tester) async {
      // Tablet size
      const tabletSize = Size(1200, 1600);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: tabletSize),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                expect(ScreenUtilPlus().deviceType(context), DeviceType.tablet);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    test('enableScale toggles scaling', () {
      ScreenUtilPlus.enableScale(
        enableWH: () => false,
        enableText: () => false,
      );
      expect(ScreenUtilPlus().scaleWidth, 1.0);
      expect(ScreenUtilPlus().scaleText, 1.0);

      ScreenUtilPlus.enableScale(enableWH: () => true, enableText: () => true);
    });

    test('ensureScreenSize completes', () async {
      await ScreenUtilPlus.ensureScreenSize();
      // Success if no timeout/error using implicit view in test env
    });
  });
}

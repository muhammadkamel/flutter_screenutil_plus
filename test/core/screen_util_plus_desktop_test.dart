import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenUtilPlus Desktop Device Type Tests', () {
    testWidgets('deviceType returns DeviceType.mac on macOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1920, 1080)),
      );

      late DeviceType result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = ScreenUtilPlus().deviceType(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, DeviceType.mac);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('deviceType returns DeviceType.windows on Windows', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1920, 1080)),
      );

      late DeviceType result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = ScreenUtilPlus().deviceType(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, DeviceType.windows);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('deviceType returns DeviceType.linux on Linux', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1920, 1080)),
      );

      late DeviceType result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = ScreenUtilPlus().deviceType(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, DeviceType.linux);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('deviceType returns DeviceType.fuchsia on Fuchsia', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1920, 1080)),
      );

      late DeviceType result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = ScreenUtilPlus().deviceType(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, DeviceType.fuchsia);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}

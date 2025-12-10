import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ScreenUtilPlus Core Integration', () {
    testWidgets('ensureScreenSize completes successfully', (tester) async {
      await ScreenUtilPlus.ensureScreenSize();
      // Should not timeout
    });

    testWidgets('ensureScreenSizeAndInit initializes correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            // We need a context, but ensureScreenSizeAndInit is async and usually called before runApp or inside.
            // In test environment, we might just call it.
            ScreenUtilPlus.ensureScreenSizeAndInit(
              context,
              designSize: const Size(360, 690),
            ).then((_) {});
            return const SizedBox();
          },
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('deviceType returns correct type in app', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              home: Builder(
                builder: (context) {
                  final type = ScreenUtilPlus().deviceType(context);
                  final orientation = ScreenUtilPlus().orientation;
                  return Text('Type: $type, Orientation: $orientation');
                },
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Type:'), findsOneWidget);
    });
  });
}

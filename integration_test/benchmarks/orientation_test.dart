import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import '../apps/standard_app.dart' as standard;
import '../apps/su_app.dart' as su;
import '../apps/su_plus_app.dart' as sup;

void main() {
  Future<int> driveOrientationChange(WidgetTester tester) async {
    final originalSize = tester.view.physicalSize;
    final landscapeSize = Size(originalSize.height, originalSize.width);

    final sw = Stopwatch()..start();
    for (int i = 0; i < 20; i++) {
      tester.view.physicalSize = landscapeSize;
      await tester.pump();
      tester.view.physicalSize = originalSize;
      await tester.pump();
    }
    sw.stop();
    return sw.elapsedMilliseconds;
  }

  group('Orientation Benchmarks', () {
    testWidgets('Standard Orientation', (tester) async {
      standard.main();
      await tester.pumpAndSettle();
      final ms = await driveOrientationChange(tester);
      print('standard_orientation: $ms ms');
    });

    testWidgets('SU Orientation', (tester) async {
      su.main();
      await tester.pumpAndSettle();
      final ms = await driveOrientationChange(tester);
      print('su_orientation: $ms ms');
    });

    testWidgets('SUPlus Orientation', (tester) async {
      sup.main();
      await tester.pumpAndSettle();
      final ms = await driveOrientationChange(tester);
      print('su_plus_orientation: $ms ms');
    });
  });
}

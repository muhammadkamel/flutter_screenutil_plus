import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../apps/standard_app.dart' as standard;
import '../apps/su_app.dart' as su;
import '../apps/su_plus_app.dart' as sup;

void main() {
  Future<int> driveScrolling(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('toggle_view')));
    await tester.pumpAndSettle();

    final listFinder = find.byKey(const ValueKey('list_view'));

    final sw = Stopwatch()..start();
    for (int i = 0; i < 50; i++) {
      await tester.drag(listFinder, const Offset(0, -300));
      await tester.pump();
    }
    sw.stop();
    return sw.elapsedMilliseconds;
  }

  group('Scrolling Benchmarks', () {
    testWidgets('Standard Scrolling', (tester) async {
      standard.main();
      await tester.pumpAndSettle();
      final ms = await driveScrolling(tester);
      print('standard_scrolling: $ms ms');
    });

    testWidgets('SU Scrolling', (tester) async {
      su.main();
      await tester.pumpAndSettle();
      final ms = await driveScrolling(tester);
      print('su_scrolling: $ms ms');
    });

    testWidgets('SUPlus Scrolling', (tester) async {
      sup.main();
      await tester.pumpAndSettle();
      final ms = await driveScrolling(tester);
      print('su_plus_scrolling: $ms ms');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import '../apps/standard_app.dart' as standard;
import '../apps/su_app.dart' as su;
import '../apps/su_plus_app.dart' as sup;

void main() {
  group('Deep Tree Benchmarks', () {
    testWidgets('Standard Deep Tree', (tester) async {
      standard.main();
      await tester.pumpAndSettle();

      final sw = Stopwatch()..start();
      for (int i = 0; i < 50; i++) {
        await tester.pump();
      }
      sw.stop();
      print('standard_deep_tree: ${sw.elapsedMilliseconds} ms');
    });

    testWidgets('SU Deep Tree', (tester) async {
      su.main();
      await tester.pumpAndSettle();

      final sw = Stopwatch()..start();
      for (int i = 0; i < 50; i++) {
        await tester.pump();
      }
      sw.stop();
      print('su_deep_tree: ${sw.elapsedMilliseconds} ms');
    });

    testWidgets('SUPlus Deep Tree', (tester) async {
      sup.main();
      await tester.pumpAndSettle();

      final sw = Stopwatch()..start();
      for (int i = 0; i < 50; i++) {
        await tester.pump();
      }
      sw.stop();
      print('su_plus_deep_tree: ${sw.elapsedMilliseconds} ms');
    });
  });
}

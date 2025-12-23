import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MediaQuery Safe Access Tests', () {
    testWidgets('ResponsiveQuery works safely with implicit View MediaQuery', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              // Should not throw.
              // In tests, this uses the implicit View (800x600 default)
              final double width = context.responsive().width;
              final double height = context.responsive().height;
              final Orientation? orientation = context
                  .responsive()
                  .mediaQuery
                  ?.orientation;

              expect(width, greaterThan(0));
              expect(height, greaterThan(0));
              expect(orientation, isNotNull);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets(
      'ScreenUtilPlusInit initializes safely without explicit MediaQuery widget',
      (tester) async {
        // This ensures that ScreenUtilPlusInit doesn't require a MediaQuery widget
        // ancestor, allowing it to be placed at the top of the tree.
        await tester.pumpWidget(
          ScreenUtilPlusInit(
            builder: (context, child) {
              // Verify context has access to data
              final ResponsiveQuery responsive = context.responsive();
              expect(responsive.width, greaterThan(0));
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'SizeClasses extension works safely without explicit MediaQuery widget',
      (tester) async {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                // Should not crash
                final SizeClasses sizeClasses = context.sizeClasses;

                // Should correspond to the default test view size (800x600)
                // 800 width is typically 'md' or 'lg' depending on breakpoints
                expect(sizeClasses, isNotNull);

                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SizeClass', () {
    test('has two values: compact and regular', () {
      expect(SizeClass.values.length, 2);
      expect(SizeClass.values, contains(SizeClass.compact));
      expect(SizeClass.values, contains(SizeClass.regular));
    });

    test('compact is the first value', () {
      expect(SizeClass.values.first, SizeClass.compact);
    });

    test('regular is the second value', () {
      expect(SizeClass.values.last, SizeClass.regular);
    });
  });

  group('SizeClasses', () {
    test('creates instance with horizontal and vertical size classes', () {
      const sizeClasses = SizeClasses(
        horizontal: SizeClass.compact,
        vertical: SizeClass.regular,
      );

      expect(sizeClasses.horizontal, SizeClass.compact);
      expect(sizeClasses.vertical, SizeClass.regular);
    });

    group('fromSize factory', () {
      test('creates compact for width < threshold', () {
        final sizeClasses = SizeClasses.fromSize(const Size(500, 800));

        expect(sizeClasses.horizontal, SizeClass.compact);
      });

      test('creates regular for width >= threshold', () {
        final sizeClasses = SizeClasses.fromSize(const Size(600, 800));

        expect(sizeClasses.horizontal, SizeClass.regular);
      });

      test('creates compact for height < threshold', () {
        final sizeClasses = SizeClasses.fromSize(const Size(800, 500));

        expect(sizeClasses.vertical, SizeClass.compact);
      });

      test('creates regular for height >= threshold', () {
        final sizeClasses = SizeClasses.fromSize(const Size(800, 600));

        expect(sizeClasses.vertical, SizeClass.regular);
      });

      test('uses custom threshold', () {
        final sizeClasses = SizeClasses.fromSize(
          const Size(500, 500),
          threshold: 400,
        );

        expect(sizeClasses.horizontal, SizeClass.regular);
        expect(sizeClasses.vertical, SizeClass.regular);
      });

      test('handles zero dimensions', () {
        final sizeClasses = SizeClasses.fromSize(Size.zero);

        expect(sizeClasses.horizontal, SizeClass.compact);
        expect(sizeClasses.vertical, SizeClass.compact);
      });

      test('handles very large dimensions', () {
        final sizeClasses = SizeClasses.fromSize(const Size(10000, 10000));

        expect(sizeClasses.horizontal, SizeClass.regular);
        expect(sizeClasses.vertical, SizeClass.regular);
      });

      test('handles exactly threshold value', () {
        final sizeClasses = SizeClasses.fromSize(const Size(600, 600));

        expect(sizeClasses.horizontal, SizeClass.regular);
        expect(sizeClasses.vertical, SizeClass.regular);
      });

      test('handles just below threshold value', () {
        final sizeClasses = SizeClasses.fromSize(const Size(599.9, 599.9));

        expect(sizeClasses.horizontal, SizeClass.compact);
        expect(sizeClasses.vertical, SizeClass.compact);
      });
    });

    group('fromMediaQuery factory', () {
      test('creates from MediaQueryData size', () {
        const mediaQuery = MediaQueryData(size: Size(800, 600));
        final sizeClasses = SizeClasses.fromMediaQuery(mediaQuery);

        expect(sizeClasses.horizontal, SizeClass.regular);
        expect(sizeClasses.vertical, SizeClass.regular);
      });

      test('uses custom threshold', () {
        const mediaQuery = MediaQueryData(size: Size(500, 500));
        final sizeClasses = SizeClasses.fromMediaQuery(
          mediaQuery,
          threshold: 400,
        );

        expect(sizeClasses.horizontal, SizeClass.regular);
        expect(sizeClasses.vertical, SizeClass.regular);
      });

      test('delegates to fromSize', () {
        const mediaQuery = MediaQueryData(size: Size(300, 700));
        final sizeClasses = SizeClasses.fromMediaQuery(
          mediaQuery,
          threshold: 500,
        );

        expect(sizeClasses.horizontal, SizeClass.compact);
        expect(sizeClasses.vertical, SizeClass.regular);
      });
    });

    group('getters', () {
      test('isRegular returns true when both are regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses.isRegular, true);
      });

      test('isRegular returns false when horizontal is compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses.isRegular, false);
      });

      test('isRegular returns false when vertical is compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.compact,
        );

        expect(sizeClasses.isRegular, false);
      });

      test('isCompact returns true when both are compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.compact,
        );

        expect(sizeClasses.isCompact, true);
      });

      test('isCompact returns false when horizontal is regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.compact,
        );

        expect(sizeClasses.isCompact, false);
      });

      test('isCompact returns false when vertical is regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses.isCompact, false);
      });

      test('isRegularHorizontal returns true when horizontal is regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.compact,
        );

        expect(sizeClasses.isRegularHorizontal, true);
      });

      test('isRegularHorizontal returns false when horizontal is compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses.isRegularHorizontal, false);
      });

      test('isRegularVertical returns true when vertical is regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses.isRegularVertical, true);
      });

      test('isRegularVertical returns false when vertical is compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.compact,
        );

        expect(sizeClasses.isRegularVertical, false);
      });

      test('isCompactHorizontal returns true when horizontal is compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses.isCompactHorizontal, true);
      });

      test('isCompactHorizontal returns false when horizontal is regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.compact,
        );

        expect(sizeClasses.isCompactHorizontal, false);
      });

      test('isCompactVertical returns true when vertical is compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.compact,
        );

        expect(sizeClasses.isCompactVertical, true);
      });

      test('isCompactVertical returns false when vertical is regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses.isCompactVertical, false);
      });
    });

    group('equality', () {
      test('two instances with same values are equal', () {
        const sizeClasses1 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );
        const sizeClasses2 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses1, sizeClasses2);
        expect(sizeClasses1 == sizeClasses2, true);
      });

      test('two instances with different horizontal are not equal', () {
        const sizeClasses1 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );
        const sizeClasses2 = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses1, isNot(sizeClasses2));
        expect(sizeClasses1 == sizeClasses2, false);
      });

      test('two instances with different vertical are not equal', () {
        const sizeClasses1 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.compact,
        );
        const sizeClasses2 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses1, isNot(sizeClasses2));
        expect(sizeClasses1 == sizeClasses2, false);
      });

      test('identical instances are equal', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses == sizeClasses, true);
      });

      test('instance is not equal to different type', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        // Use dynamic to allow comparison with different type
        const dynamic other = 'not a SizeClasses';
        expect(sizeClasses == other, false);
      });
    });

    group('hashCode', () {
      test('two equal instances have same hashCode', () {
        const sizeClasses1 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );
        const sizeClasses2 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses1.hashCode, sizeClasses2.hashCode);
      });

      test('different instances have different hashCode', () {
        const sizeClasses1 = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );
        const sizeClasses2 = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.regular,
        );

        expect(sizeClasses1.hashCode, isNot(sizeClasses2.hashCode));
      });
    });

    group('toString', () {
      test('returns formatted string', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.regular,
        );

        expect(
          sizeClasses.toString(),
          'SizeClasses(horizontal: SizeClass.compact, vertical: SizeClass.regular)',
        );
      });

      test('returns correct string for both compact', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.compact,
          vertical: SizeClass.compact,
        );

        expect(
          sizeClasses.toString(),
          'SizeClasses(horizontal: SizeClass.compact, vertical: SizeClass.compact)',
        );
      });

      test('returns correct string for both regular', () {
        const sizeClasses = SizeClasses(
          horizontal: SizeClass.regular,
          vertical: SizeClass.regular,
        );

        expect(
          sizeClasses.toString(),
          'SizeClasses(horizontal: SizeClass.regular, vertical: SizeClass.regular)',
        );
      });
    });
  });

  group('SizeClassExtension', () {
    testWidgets('sizeClasses getter returns correct SizeClasses', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final SizeClasses sizeClasses = context.sizeClasses;
              return Scaffold(
                body: Text(
                  'H: ${sizeClasses.horizontal}, V: ${sizeClasses.vertical}',
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.data, contains('H: SizeClass.regular'));
      expect(text.data, contains('V: SizeClass.regular'));
    });

    testWidgets('horizontalSizeClass getter returns correct value', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final SizeClass horizontal = context.horizontalSizeClass;
              return Scaffold(body: Text('Horizontal: $horizontal'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.data, contains('Horizontal: SizeClass.compact'));
    });

    testWidgets('verticalSizeClass getter returns correct value', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1000, 500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final SizeClass vertical = context.verticalSizeClass;
              return Scaffold(body: Text('Vertical: $vertical'));
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.data, contains('Vertical: SizeClass.compact'));
    });

    testWidgets('extension methods work with different screen sizes', (
      tester,
    ) async {
      final List<Map<String, Object>> testCases = [
        {'size': const Size(300, 400), 'h': 'compact', 'v': 'compact'},
        {'size': const Size(700, 400), 'h': 'regular', 'v': 'compact'},
        {'size': const Size(300, 700), 'h': 'compact', 'v': 'regular'},
        {'size': const Size(800, 1000), 'h': 'regular', 'v': 'regular'},
      ];

      for (final testCase in testCases) {
        final size = testCase['size']! as Size;
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final SizeClasses sizeClasses = context.sizeClasses;
                return Scaffold(
                  body: Text(
                    '${sizeClasses.horizontal.name},${sizeClasses.vertical.name}',
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Text text = tester.widget<Text>(find.byType(Text));
        expect(text.data, '${testCase['h']},${testCase['v']}');
      }
    });
  });
}

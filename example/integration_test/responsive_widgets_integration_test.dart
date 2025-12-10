import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Responsive Widgets Integration Tests', () {
    testWidgets('RContainer with all responsive properties', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 200,
              height: 100,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('RContainer Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('RContainer Test'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Multiple RContainers nested', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 300,
              height: 200,
              color: Colors.red,
              child: RContainer(
                width: 200,
                height: 100,
                color: Colors.blue,
                child: RContainer(
                  width: 100,
                  height: 50,
                  color: Colors.green,
                  child: const Text('Nested'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Nested'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('RText automatically scales font size', (tester) async {
      // Set screen size larger than design size to ensure scaling occurs
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  RText('Small Text', style: TextStyle(fontSize: 12)),
                  RText('Medium Text', style: TextStyle(fontSize: 16)),
                  RText('Large Text', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Small Text'), findsOneWidget);
      expect(find.text('Medium Text'), findsOneWidget);
      expect(find.text('Large Text'), findsOneWidget);

      // Verify font sizes are scaled
      final smallText = tester.widget<Text>(find.text('Small Text'));
      final mediumText = tester.widget<Text>(find.text('Medium Text'));
      final largeText = tester.widget<Text>(find.text('Large Text'));

      expect(smallText.style?.fontSize, greaterThan(12));
      expect(mediumText.style?.fontSize, greaterThan(16));
      expect(largeText.style?.fontSize, greaterThan(24));
    });

    testWidgets('RPadding with different edge insets', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: Column(
              children: [
                RPadding(
                  padding: EdgeInsets.all(16),
                  child: Text('All Padding'),
                ),
                RPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('Symmetric Padding'),
                ),
                RPadding(
                  padding: EdgeInsets.only(
                    left: 8,
                    top: 12,
                    right: 16,
                    bottom: 20,
                  ),
                  child: Text('Custom Padding'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('All Padding'), findsOneWidget);
      expect(find.text('Symmetric Padding'), findsOneWidget);
      expect(find.text('Custom Padding'), findsOneWidget);
    });

    testWidgets('Responsive widgets with regular Flutter widgets', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('Mixed Widgets')),
            body: Column(
              children: [
                // Regular Container
                Container(width: 100, height: 50, color: Colors.red),
                // RContainer
                RContainer(width: 100, height: 50, color: Colors.blue),
                // Regular Text
                const Text('Regular Text'),
                // RText
                const RText('Responsive Text', style: TextStyle(fontSize: 16)),
                // Regular Padding
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Regular Padding'),
                ),
                // RPadding
                const RPadding(
                  padding: EdgeInsets.all(8),
                  child: Text('Responsive Padding'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mixed Widgets'), findsOneWidget);
      expect(find.text('Regular Text'), findsOneWidget);
      expect(find.text('Responsive Text'), findsOneWidget);
      expect(find.text('Regular Padding'), findsOneWidget);
      expect(find.text('Responsive Padding'), findsOneWidget);
    });

    testWidgets('REdgeInsets with different constructors', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  padding: REdgeInsets.all(16),
                  color: Colors.red,
                  child: const Text('All'),
                ),
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.blue,
                  child: const Text('Symmetric'),
                ),
                Container(
                  padding: REdgeInsets.only(left: 8, top: 12),
                  color: Colors.green,
                  child: const Text('Only'),
                ),
                Container(
                  padding: REdgeInsetsDirectional.all(16),
                  color: Colors.orange,
                  child: const Text('Directional'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Symmetric'), findsOneWidget);
      expect(find.text('Only'), findsOneWidget);
      expect(find.text('Directional'), findsOneWidget);
    });

    testWidgets('Complex layout with multiple responsive widgets', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            appBar: AppBar(
              title: RText(
                'Complex Layout',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  RContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RText(
                          'Header',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RSizedBox(height: 8),
                        const RText(
                          'Subheader',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  RPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: RContainer(
                            height: 100,
                            color: Colors.red,
                            child: const Center(
                              child: RText(
                                'Card 1',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        RSizedBox(width: 12),
                        Expanded(
                          child: RContainer(
                            height: 100,
                            color: Colors.green,
                            child: const Center(
                              child: RText(
                                'Card 2',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Complex Layout'), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Subheader'), findsOneWidget);
      expect(find.text('Card 1'), findsOneWidget);
      expect(find.text('Card 2'), findsOneWidget);
    });

    testWidgets('Responsive widgets with constraints', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 200,
              height: 100,
              constraints: const BoxConstraints(
                minWidth: 150,
                maxWidth: 250,
                minHeight: 80,
                maxHeight: 120,
              ),
              color: Colors.blue,
              child: const Text('Constrained'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Constrained'), findsOneWidget);
    });

    testWidgets('Responsive widgets rebuild on screen size change', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          rebuildFactor: RebuildFactors.size,
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: RContainer(
                  width: 200,
                  height: 100,
                  color: Colors.blue,
                  child: RText(
                    'Width: ${200.w.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final initialText = find.textContaining('Width:');
      expect(initialText, findsOneWidget);

      // Change screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpAndSettle();

      // Text should update with new width
      expect(find.textContaining('Width:'), findsOneWidget);
    });

    testWidgets('RContainer with alignment', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              color: Colors.blue,
              child: const Text('Centered'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Centered'), findsOneWidget);
    });

    testWidgets('RText with maxLines and overflow', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: SizedBox(
              width: 100,
              child: RText(
                'This is a very long text that should overflow',
                style: TextStyle(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('Responsive widgets with zero dimensions', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Column(
              children: [
                RContainer(width: 0, height: 0, color: Colors.red),
                const RSizedBox(width: 0, height: 0),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should not throw errors
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('RContainer with transform property', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 200,
              height: 100,
              transform: Matrix4.rotationZ(0.1),
              color: Colors.blue,
              child: const Text('Transformed'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Transformed'), findsOneWidget);
    });

    testWidgets('RText with textDirection', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: RText(
              'RTL Text',
              style: TextStyle(fontSize: 16),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('RTL Text'));
      expect(text.textDirection, TextDirection.rtl);
    });

    testWidgets('RText with textScaler', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: RText(
              'Scaled Text',
              style: TextStyle(fontSize: 16),
              textScaler: TextScaler.linear(1.2),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Scaled Text'));
      expect(text.textScaler, const TextScaler.linear(1.2));
    });

    testWidgets('RText with semanticsLabel', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: RText(
              'Accessible Text',
              style: TextStyle(fontSize: 16),
              semanticsLabel: 'Accessible Label',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Accessible Text'));
      expect(text.semanticsLabel, 'Accessible Label');
    });

    testWidgets('RPadding with EdgeInsets.zero', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: RPadding(
              padding: EdgeInsets.zero,
              child: Text('Zero Padding'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Zero Padding'), findsOneWidget);
    });

    testWidgets('RSizedBox with double.infinity', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Column(
              children: [
                const RSizedBox(width: double.infinity, height: 50),
                const Text('Infinity SizedBox'),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Infinity SizedBox'), findsOneWidget);
    });

    testWidgets('RSizedBox variants (square, vertical, horizontal, fromSize)', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: Column(
              children: [
                const RSizedBox.square(dimension: 50),
                const RSizedBox.vertical(10),
                const RSizedBox.horizontal(20),
                RSizedBox.fromSize(size: const Size(30, 30)),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(RSizedBox), findsWidgets);
    });

    testWidgets('RContainer with BoxConstraints min/max', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 200,
              height: 100,
              constraints: const BoxConstraints(
                minWidth: 150,
                maxWidth: 250,
                minHeight: 80,
                maxHeight: 120,
              ),
              color: Colors.purple,
              child: const Text('Constrained Container'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Constrained Container'), findsOneWidget);
    });

    testWidgets('Multiple RText widgets with different styles', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: const Scaffold(
            body: Column(
              children: [
                RText(
                  'Bold Text',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RText(
                  'Italic Text',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                RText(
                  'Colored Text',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                RText(
                  'Underlined Text',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Bold Text'), findsOneWidget);
      expect(find.text('Italic Text'), findsOneWidget);
      expect(find.text('Colored Text'), findsOneWidget);
      expect(find.text('Underlined Text'), findsOneWidget);
    });

    testWidgets('RContainer with gradient decoration', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
              ),
              child: const Text('Gradient Container'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Gradient Container'), findsOneWidget);
    });

    testWidgets('RContainer with border decoration', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: RContainer(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Bordered Container'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Bordered Container'), findsOneWidget);
    });

    testWidgets('Responsive widgets in ListView', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: ListView(
              children: [
                RContainer(
                  width: 200,
                  height: 100,
                  color: Colors.red,
                  child: const Text('Item 1'),
                ),
                RContainer(
                  width: 200,
                  height: 100,
                  color: Colors.blue,
                  child: const Text('Item 2'),
                ),
                RContainer(
                  width: 200,
                  height: 100,
                  color: Colors.green,
                  child: const Text('Item 3'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('Responsive widgets in GridView', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(home: child);
          },
          child: Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              children: [
                RContainer(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: const Text('Grid 1'),
                ),
                RContainer(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  child: const Text('Grid 2'),
                ),
                RContainer(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: const Text('Grid 3'),
                ),
                RContainer(
                  width: 100,
                  height: 100,
                  color: Colors.orange,
                  child: const Text('Grid 4'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Grid 1'), findsOneWidget);
      expect(find.text('Grid 2'), findsOneWidget);
      expect(find.text('Grid 3'), findsOneWidget);
      expect(find.text('Grid 4'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Integration Tests', () {
    testWidgets('ResponsiveTheme.fromTheme scales all text styles', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  textTheme: const TextTheme(
                    displayLarge: TextStyle(fontSize: 96),
                    displayMedium: TextStyle(fontSize: 60),
                    displaySmall: TextStyle(fontSize: 48),
                    headlineLarge: TextStyle(fontSize: 40),
                    headlineMedium: TextStyle(fontSize: 34),
                    headlineSmall: TextStyle(fontSize: 24),
                    titleLarge: TextStyle(fontSize: 20),
                    titleMedium: TextStyle(fontSize: 16),
                    titleSmall: TextStyle(fontSize: 14),
                    bodyLarge: TextStyle(fontSize: 16),
                    bodyMedium: TextStyle(fontSize: 14),
                    bodySmall: TextStyle(fontSize: 12),
                    labelLarge: TextStyle(fontSize: 14),
                    labelMedium: TextStyle(fontSize: 12),
                    labelSmall: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return Scaffold(
                body: Column(
                  children: [
                    Text('Display Large', style: theme.textTheme.displayLarge),
                    Text(
                      'Headline Large',
                      style: theme.textTheme.headlineLarge,
                    ),
                    Text('Title Large', style: theme.textTheme.titleLarge),
                    Text('Body Large', style: theme.textTheme.bodyLarge),
                    Text('Label Large', style: theme.textTheme.labelLarge),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all text styles are scaled
      final displayText = tester.widget<Text>(find.text('Display Large'));
      final headlineText = tester.widget<Text>(find.text('Headline Large'));
      final titleText = tester.widget<Text>(find.text('Title Large'));
      final bodyText = tester.widget<Text>(find.text('Body Large'));
      final labelText = tester.widget<Text>(find.text('Label Large'));

      expect(displayText.style?.fontSize, greaterThan(96));
      expect(headlineText.style?.fontSize, greaterThan(40));
      expect(titleText.style?.fontSize, greaterThan(20));
      expect(bodyText.style?.fontSize, greaterThan(16));
      expect(labelText.style?.fontSize, greaterThan(14));
    });

    testWidgets('Theme changes propagate to widgets', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  primaryColor: Colors.blue,
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Theme Test'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                body: Text(
                  'Themed Text',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Theme Test'), findsOneWidget);
      expect(find.text('Themed Text'), findsOneWidget);
    });

    testWidgets('Custom theme with responsive scaling', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
                  textTheme: const TextTheme(
                    headlineLarge: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    bodyLarge: TextStyle(fontSize: 16),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return Scaffold(
                body: Column(
                  children: [
                    Text('Headline', style: theme.textTheme.headlineLarge),
                    Text('Body', style: theme.textTheme.bodyLarge),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Button'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Headline'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Button'), findsOneWidget);
    });

    testWidgets('Dark mode with responsive theme', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData.light().copyWith(
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              darkTheme: ResponsiveTheme.fromTheme(
                ThemeData.dark().copyWith(
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              themeMode: ThemeMode.dark,
              home: child,
            );
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Text(
                  'Dark Mode Text',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Dark Mode Text'), findsOneWidget);
    });

    testWidgets('Text styles in AppBar', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  appBarTheme: const AppBarTheme(
                    titleTextStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('AppBar Title')),
            body: const Text('Body'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('AppBar Title'), findsOneWidget);
    });

    testWidgets('Text styles in Buttons', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Scaffold(
            body: Column(
              children: [
                TextButton(onPressed: () {}, child: const Text('Text Button')),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Text Button'), findsOneWidget);
      expect(find.text('Elevated Button'), findsOneWidget);
      expect(find.text('Outlined Button'), findsOneWidget);
    });

    testWidgets('Theme with custom font family', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  fontFamily: 'Roboto',
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Text(
                  'Custom Font',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom Font'), findsOneWidget);
    });

    testWidgets('Theme extensions with responsive scaling', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ResponsiveTheme.fromTheme(
                ThemeData(
                  textTheme: const TextTheme(
                    headlineLarge: TextStyle(fontSize: 32),
                    headlineMedium: TextStyle(fontSize: 28),
                    headlineSmall: TextStyle(fontSize: 24),
                    bodyLarge: TextStyle(fontSize: 16),
                    bodyMedium: TextStyle(fontSize: 14),
                    bodySmall: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              home: child,
            );
          },
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return Scaffold(
                body: Column(
                  children: [
                    Text('H1', style: theme.textTheme.headlineLarge),
                    Text('H2', style: theme.textTheme.headlineMedium),
                    Text('H3', style: theme.textTheme.headlineSmall),
                    Text('B1', style: theme.textTheme.bodyLarge),
                    Text('B2', style: theme.textTheme.bodyMedium),
                    Text('B3', style: theme.textTheme.bodySmall),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('H1'), findsOneWidget);
      expect(find.text('H2'), findsOneWidget);
      expect(find.text('H3'), findsOneWidget);
      expect(find.text('B1'), findsOneWidget);
      expect(find.text('B2'), findsOneWidget);
      expect(find.text('B3'), findsOneWidget);
    });
  });
}

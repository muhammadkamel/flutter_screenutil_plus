import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_screenutil_plus_example/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in, unit in dp)
    return ScreenUtilPlusInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      autoRebuild: false,
      // NEW: Set autoRebuild to false for better performance
      // When false, only widgets using context.su or R-widgets will rebuild
      // autoRebuild: false,
      // Use builder only if you need to use library outside ScreenUtilPlusInit context
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter ScreenUtil Plus Example',
          // Use ResponsiveTheme to automatically scale all text styles
          theme: ResponsiveTheme.fromTheme(
            ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          ),
          home: child,
        );
      },
      child: const HomePage(),
    );
  }
}

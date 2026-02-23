import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(const SUApp());

class SUApp extends StatelessWidget {
  const SUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return const MaterialApp(home: SUHomePage());
      },
    );
  }
}

class SUHomePage extends StatefulWidget {
  const SUHomePage({super.key});
  @override
  State<SUHomePage> createState() => _SUHomePageState();
}

class _SUHomePageState extends State<SUHomePage> {
  bool _isDeepTree = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SU App', style: TextStyle(fontSize: 20.sp)),
        actions: [
          IconButton(
            key: const ValueKey('toggle_view'),
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => setState(() => _isDeepTree = !_isDeepTree),
          ),
        ],
      ),
      body: _isDeepTree ? const SUDeepTree(depth: 50) : const SUList(),
    );
  }
}

class SUDeepTree extends StatelessWidget {
  const SUDeepTree({super.key, required this.depth});
  final int depth;

  @override
  Widget build(BuildContext context) {
    if (depth == 0) {
      return Container(
        width: 100.w,
        height: 100.h,
        color: Colors.blue,
        child: Center(
          child: Text('Deep', style: TextStyle(fontSize: 16.sp)),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(width: 1.w, color: Colors.grey),
        ),
        child: SUDeepTree(depth: depth - 1),
      ),
    );
  }
}

class SUList extends StatelessWidget {
  const SUList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const ValueKey('list_view'),
      itemCount: 1000,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
            height: 50.h,
            color: index.isEven
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Text('Item $index', style: TextStyle(fontSize: 14.sp)),
                SizedBox(width: 10.w),
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

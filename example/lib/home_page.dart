import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScreenUtil Plus Demo', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            20.verticalSpace,
            _buildSizeExtensionsDemo(),
            20.verticalSpace,
            _buildWidgetsDemo(),
            20.verticalSpace,
            _buildRContainerDemo(),
            20.verticalSpace,
            _buildRTextDemo(),
            20.verticalSpace,
            _buildTextScalingDemo(),
            20.verticalSpace,
            _buildScreenInfo(),
            20.verticalSpace,
            _buildShapesDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to ScreenUtil Plus!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          10.verticalSpace,
          Text(
            'This example demonstrates how to create responsive UIs that adapt to different screen sizes.',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeExtensionsDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size Extensions',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'Use .w, .h, .r, .sp extensions for responsive sizing',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _buildSizeBox('50.w', 50.w, 50.w, Colors.red),
            _buildSizeBox('100.w', 100.w, 100.w, Colors.blue),
            _buildSizeBox('50.h', 50.w, 50.h, Colors.green),
            _buildSizeBox('100.h', 100.w, 100.h, Colors.orange),
            _buildSizeBox('50.r', 50.r, 50.r, Colors.purple),
            _buildSizeBox('100.r', 100.r, 100.r, Colors.teal),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeBox(String label, double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildWidgetsDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responsive Widgets',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'RPadding, RSizedBox, and RContainer widgets',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.green.shade200, width: 2.w),
          ),
          child: Column(
            children: [
              Text(
                'RPadding Example',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              10.verticalSpace,
              Text(
                'This container uses RPadding with responsive padding values.',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
        15.verticalSpace,
        RSizedBox(
          width: double.infinity,
          height: 60.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'RSizedBox Example (60.h)',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRContainerDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RContainer Widget',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'Automatically adapts width, height, padding, margin, and constraints',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,
        RContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade400, Colors.blue.shade400],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RText(
                'RContainer with Auto-Scaled Dimensions',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              5.verticalSpace,
              RText(
                'Width, height, padding, and margin are all responsive!',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        15.verticalSpace,
        Row(
          children: [
            Expanded(
              child: RContainer(
                height: 80,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: RText(
                    'RContainer 1',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: RContainer(
                height: 80,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: RText(
                    'RContainer 2',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink.shade900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRTextDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RText Widget',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'Automatically scales font sizes - no need for .sp extension!',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.amber.shade200, width: 2.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RText(
                'Heading Text (fontSize: 24)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              10.verticalSpace,
              const RText(
                'Body Text (fontSize: 16)',
                style: TextStyle(fontSize: 16),
              ),
              10.verticalSpace,
              RText(
                'Small Text (fontSize: 12)',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              15.verticalSpace,
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const RText(
                  'All font sizes are automatically responsive without using .sp!',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextScalingDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text Scaling',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'Font sizes adapt to screen size using .sp extension',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,
        _buildTextSample('12.sp', 12.sp),
        10.verticalSpace,
        _buildTextSample('16.sp', 16.sp),
        10.verticalSpace,
        _buildTextSample('20.sp', 20.sp),
        10.verticalSpace,
        _buildTextSample('24.sp', 24.sp),
        10.verticalSpace,
        _buildTextSample('32.sp', 32.sp),
      ],
    );
  }

  Widget _buildTextSample(String label, double fontSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '$label - Sample text with responsive font size',
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }

  Widget _buildScreenInfo() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Screen Information',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          15.verticalSpace,
          _buildInfoRow(
            'Screen Width',
            '${1.sw.toStringAsFixed(2)} (${ScreenUtilPlus().screenWidth.toStringAsFixed(2)} dp)',
          ),
          _buildInfoRow(
            'Screen Height',
            '${1.sh.toStringAsFixed(2)} (${ScreenUtilPlus().screenHeight.toStringAsFixed(2)} dp)',
          ),
          _buildInfoRow('Design Size', '360 x 690 (default)'),
          _buildInfoRow(
            'Scale Width',
            ScreenUtilPlus().scaleWidth.toStringAsFixed(3),
          ),
          _buildInfoRow(
            'Scale Height',
            ScreenUtilPlus().scaleHeight.toStringAsFixed(3),
          ),
          _buildInfoRow(
            'Pixel Ratio',
            (ScreenUtilPlus().pixelRatio ?? 0).toStringAsFixed(2),
          ),
          _buildInfoRow(
            'Status Bar Height',
            '${ScreenUtilPlus().statusBarHeight.toStringAsFixed(2)} dp',
          ),
          _buildInfoRow(
            'Bottom Bar Height',
            '${ScreenUtilPlus().bottomBarHeight.toStringAsFixed(2)} dp',
          ),
          _buildInfoRow(
            'Orientation',
            ScreenUtilPlus().orientation.toString().split('.').last,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildShapesDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shapes & Borders',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'Responsive border radius and spacing',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '12.r radius',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.pink.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Text(
                    '20.r radius',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        15.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.purple.shade400],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Text(
                'Gradient Container',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              8.verticalSpace,
              Text(
                'With responsive padding and border radius',
                style: TextStyle(fontSize: 14.sp, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

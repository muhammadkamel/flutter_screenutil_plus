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
            _buildBreakpointsDemo(),
            20.verticalSpace,
            _buildSizeClassDemo(),
            20.verticalSpace,
            _buildResponsiveBuilderDemo(),
            20.verticalSpace,
            _buildAdaptiveContainerDemo(),
            20.verticalSpace,
            _buildAdaptiveValuesDemo(),
            20.verticalSpace,
            _buildSizeExtensionsDemo(),
            20.verticalSpace,
            _buildWidgetsDemo(),
            20.verticalSpace,
            _buildRContainerDemo(),
            20.verticalSpace,
            _buildRTextDemo(),
            20.verticalSpace,
            _buildAdaptiveTextDemo(),
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
          10.verticalSpace,
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.new_releases,
                  size: 16.sp,
                  color: Colors.green.shade700,
                ),
                5.horizontalSpace,
                Expanded(
                  child: Text(
                    'NEW: CSS & SwiftUI-like adaptive UI features!',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointsDemo() {
    final breakpoint = context.breakpoint;
    final query = context.responsive();

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.indigo.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.view_quilt,
                color: Colors.indigo.shade700,
                size: 24.sp,
              ),
              10.horizontalSpace,
              Text(
                'CSS-like Breakpoints',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          15.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Breakpoint: ${breakpoint.name.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Screen Width: ${query.width.toStringAsFixed(0)}px',
                  style: TextStyle(fontSize: 14.sp),
                ),
                10.verticalSpace,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildBreakpointChip('XS', Breakpoint.xs, breakpoint),
                    _buildBreakpointChip('SM', Breakpoint.sm, breakpoint),
                    _buildBreakpointChip('MD', Breakpoint.md, breakpoint),
                    _buildBreakpointChip('LG', Breakpoint.lg, breakpoint),
                    _buildBreakpointChip('XL', Breakpoint.xl, breakpoint),
                    _buildBreakpointChip('XXL', Breakpoint.xxl, breakpoint),
                  ],
                ),
                15.verticalSpace,
                Text(
                  'Breakpoint Checks:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                _buildCheckRow('isAtLeast(MD)', query.isAtLeast(Breakpoint.md)),
                _buildCheckRow(
                  'isLessThan(LG)',
                  query.isLessThan(Breakpoint.lg),
                ),
                _buildCheckRow(
                  'isBetween(SM, XL)',
                  query.isBetween(Breakpoint.sm, Breakpoint.xl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointChip(String label, Breakpoint bp, Breakpoint current) {
    final isActive = bp == current;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.indigo.shade600 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildCheckRow(String label, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 16.sp,
            color: value ? Colors.green : Colors.red,
          ),
          5.horizontalSpace,
          Text('$label: $value', style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _buildSizeClassDemo() {
    final sizeClasses = context.sizeClasses;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.teal.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone_android,
                color: Colors.teal.shade700,
                size: 24.sp,
              ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  'SwiftUI-like Size Classes',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Size Classes:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: _buildSizeClassCard(
                        'Horizontal',
                        sizeClasses.horizontal,
                        Colors.teal.shade400,
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: _buildSizeClassCard(
                        'Vertical',
                        sizeClasses.vertical,
                        Colors.teal.shade400,
                      ),
                    ),
                  ],
                ),
                15.verticalSpace,
                Text(
                  'Size Class Checks:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                _buildCheckRow('isRegular', sizeClasses.isRegular),
                _buildCheckRow('isCompact', sizeClasses.isCompact),
                _buildCheckRow(
                  'isRegularHorizontal',
                  sizeClasses.isRegularHorizontal,
                ),
                _buildCheckRow(
                  'isRegularVertical',
                  sizeClasses.isRegularVertical,
                ),
              ],
            ),
          ),
          15.verticalSpace,
          SizeClassBuilder(
            compact: (context) => Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Compact Layout Active',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
            regular: (context) => Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Regular Layout Active',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeClassCard(String label, SizeClass sizeClass, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color, width: 2.w),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
          ),
          5.verticalSpace,
          Text(
            sizeClass.name.toUpperCase(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveBuilderDemo() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.purple.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.dynamic_form,
                color: Colors.purple.shade700,
                size: 24.sp,
              ),
              10.horizontalSpace,
              Text(
                'ResponsiveBuilder',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'Different layouts based on breakpoints (CSS media query style)',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          15.verticalSpace,
          ResponsiveBuilder(
            xs: (context) => Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 32.sp,
                    color: Colors.red.shade700,
                  ),
                  8.verticalSpace,
                  Text(
                    'Mobile Layout (XS)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                  Text(
                    'Single column layout',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
            sm: (context) => Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 32.sp,
                    color: Colors.orange.shade700,
                  ),
                  8.verticalSpace,
                  Text(
                    'Small Tablet Layout (SM)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                  Text(
                    'Optimized for landscape phones',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
            md: (context) => Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.tablet, size: 32.sp, color: Colors.blue.shade700),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tablet Layout (MD)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        Text(
                          'Two column layout',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            lg: (context) => Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.desktop_windows,
                    size: 32.sp,
                    color: Colors.green.shade700,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desktop Layout (LG)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        Text(
                          'Three column layout with sidebar',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            xl: (context) => Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.tv, size: 32.sp, color: Colors.purple.shade700),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Large Desktop Layout (XL)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade900,
                          ),
                        ),
                        Text(
                          'Wide layout with multiple columns',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptiveContainerDemo() {
    return Container(
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
          Row(
            children: [
              Icon(Icons.fit_screen, color: Colors.amber.shade700, size: 24.sp),
              10.horizontalSpace,
              Text(
                'AdaptiveContainer',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'Container that adapts properties based on breakpoints',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          15.verticalSpace,
          SimpleAdaptiveContainer(
            widthXs: double.infinity,
            widthMd: 400,
            widthLg: 600,
            paddingXs: 12,
            paddingMd: 20,
            paddingLg: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade400, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  'Adaptive Container',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'Width and padding adapt to breakpoints',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptiveValuesDemo() {
    final adaptive = context.adaptive();

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.cyan.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: Colors.cyan.shade700, size: 24.sp),
              10.horizontalSpace,
              Text(
                'AdaptiveValues',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'Get responsive values that combine breakpoints with responsive sizing',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          15.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildValueRow(
                  'Width',
                  adaptive.width(xs: 50, md: 100, lg: 150).toStringAsFixed(1),
                ),
                _buildValueRow(
                  'Height',
                  adaptive.height(xs: 30, md: 50, lg: 70).toStringAsFixed(1),
                ),
                _buildValueRow(
                  'Font Size',
                  adaptive.fontSize(xs: 12, md: 16, lg: 20).toStringAsFixed(1),
                ),
                _buildValueRow(
                  'Radius',
                  adaptive.radius(xs: 4, md: 8, lg: 12).toStringAsFixed(1),
                ),
              ],
            ),
          ),
          15.verticalSpace,
          Container(
            width: adaptive.width(xs: 100, md: 200, lg: 300),
            height: adaptive.height(xs: 50, md: 80, lg: 100),
            decoration: BoxDecoration(
              color: Colors.cyan.shade400,
              borderRadius: BorderRadius.circular(
                adaptive.radius(xs: 8, md: 12, lg: 16),
              ),
            ),
            child: Center(
              child: Text(
                'Adaptive Box',
                style: TextStyle(
                  fontSize: adaptive.fontSize(xs: 12, md: 16, lg: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow(String label, String value) {
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
                    textAlign: TextAlign.center,
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink.shade900,
                      height: 1.0,
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
          'RText Widget & TextStyle Extensions',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'Automatically scales font sizes with proper line height handling',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,

        // RText Basic Demo
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
              Text(
                'RText Widget',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
              10.verticalSpace,
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

        15.verticalSpace,

        // TextStyleExtension Demo
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.blue.shade200, width: 2.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TextStyle Extensions',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              10.verticalSpace,
              Text(
                'Use .r, .withLineHeight(), or .withAutoLineHeight() for responsive text',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              15.verticalSpace,

              // .r extension demo
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '.r Extension',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'This text uses TextStyle(fontSize: 16, height: 1.5).r',
                      style: const TextStyle(fontSize: 16, height: 1.5).r,
                    ),
                    5.verticalSpace,
                    Text(
                      'Font size scales, height multiplier preserved',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              12.verticalSpace,

              // .withLineHeight() demo
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '.withLineHeight() Method',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'This text uses TextStyle(fontSize: 16).withLineHeight(1.8)',
                      style: const TextStyle(fontSize: 16).withLineHeight(1.8),
                    ),
                    5.verticalSpace,
                    Text(
                      'Custom line height multiplier: 1.8',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              12.verticalSpace,

              // .withAutoLineHeight() demo
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '.withAutoLineHeight() Method',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'This text uses TextStyle(fontSize: 16).withAutoLineHeight()',
                      style: const TextStyle(fontSize: 16).withAutoLineHeight(),
                    ),
                    5.verticalSpace,
                    Text(
                      'Default line height multiplier: 1.2',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        15.verticalSpace,

        // Line Height Comparison
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.purple.shade200, width: 2.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Line Height Comparison',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade900,
                ),
              ),
              10.verticalSpace,
              Text(
                'See how different line heights affect text readability',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              15.verticalSpace,

              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tight (1.0)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'This is a sample text with tight line height. Notice how the lines are closer together.',
                      style: const TextStyle(fontSize: 14).withLineHeight(1.0),
                    ),
                  ],
                ),
              ),

              12.verticalSpace,

              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Normal (1.5)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'This is a sample text with normal line height. This is the recommended setting for body text.',
                      style: const TextStyle(fontSize: 14).withLineHeight(1.5),
                    ),
                  ],
                ),
              ),

              12.verticalSpace,

              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loose (2.0)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      'This is a sample text with loose line height. Notice the increased spacing between lines.',
                      style: const TextStyle(fontSize: 14).withLineHeight(2.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdaptiveTextDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AdaptiveText Widget',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        10.verticalSpace,
        Text(
          'Text that adapts its style based on screen breakpoints',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        15.verticalSpace,

        // AdaptiveText Widget Demo
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.indigo.shade200, width: 2.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.text_fields,
                    color: Colors.indigo.shade700,
                    size: 24.sp,
                  ),
                  10.horizontalSpace,
                  Text(
                    'AdaptiveText Widget',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Text(
                'Resize your window to see the text adapt!',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              15.verticalSpace,

              // Example 1: Font size adaptation
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Font Size Adaptation',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    8.verticalSpace,
                    const AdaptiveText(
                      'This text changes size: XS(14) → MD(16) → LG(20)',
                      fontSizeXs: 14,
                      fontSizeMd: 16,
                      fontSizeLg: 20,
                    ),
                    5.verticalSpace,
                    Text(
                      'Current breakpoint: ${context.breakpoint.name.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              12.verticalSpace,

              // Example 2: Font weight adaptation
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Font Weight Adaptation',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                    8.verticalSpace,
                    const AdaptiveText(
                      'This text gets bolder on larger screens',
                      fontSizeXs: 14,
                      fontSizeMd: 16,
                      fontWeightXs: FontWeight.normal,
                      fontWeightMd: FontWeight.w600,
                      fontWeightLg: FontWeight.bold,
                    ),
                  ],
                ),
              ),

              12.verticalSpace,

              // Example 3: Color adaptation
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Color Adaptation',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    8.verticalSpace,
                    AdaptiveText(
                      'This text changes color: Blue → Purple → Red',
                      fontSizeXs: 14,
                      fontSizeMd: 16,
                      colorXs: Colors.blue.shade700,
                      colorMd: Colors.purple.shade700,
                      colorLg: Colors.red.shade700,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        15.verticalSpace,

        // Context Extension Demo
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.teal.shade200, width: 2.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.code, color: Colors.teal.shade700, size: 24.sp),
                  10.horizontalSpace,
                  Text(
                    'Context Extension',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Text(
                'Use context.adaptiveTextStyle() for more flexibility',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
              15.verticalSpace,

              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adaptive Style Example',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      'This uses context.adaptiveTextStyle() with multiple properties',
                      style: context.adaptiveTextStyle(
                        fontSizeXs: 13,
                        fontSizeMd: 15,
                        fontSizeLg: 17,
                        lineHeightXs: 1.3,
                        lineHeightMd: 1.5,
                        fontWeightLg: FontWeight.w600,
                        baseStyle: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
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

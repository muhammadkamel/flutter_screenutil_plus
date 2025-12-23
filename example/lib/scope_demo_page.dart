import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Demo page showcasing the new ScreenUtilPlusScope features
class ScopeDemoPage extends StatefulWidget {
  const ScopeDemoPage({super.key});

  @override
  State<ScopeDemoPage> createState() => _ScopeDemoPageState();
}

class _ScopeDemoPageState extends State<ScopeDemoPage> {
  bool _autoRebuild = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScreenUtilPlusScope Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            20.verticalSpace,
            _buildAutoRebuildToggle(),
            20.verticalSpace,
            _buildContextSuDemo(),
            20.verticalSpace,
            _buildRebuildCounters(),
            20.verticalSpace,
            _buildPerformanceInfo(),
            20.verticalSpace,
            _buildUsageExamples(),
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
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.widgets, size: 32.sp, color: Colors.white),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  'InheritedWidget Power!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'Efficient reactivity using Flutter\'s InheritedWidget pattern',
            style: TextStyle(fontSize: 14.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoRebuildToggle() {
    return Container(
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
          Row(
            children: [
              Icon(Icons.settings, color: Colors.blue.shade700, size: 24.sp),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  'autoRebuild Parameter',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'Control whether the entire widget tree rebuilds on screen changes',
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
                SwitchListTile(
                  title: Text(
                    'Auto Rebuild: ${_autoRebuild ? "ON" : "OFF"}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    _autoRebuild
                        ? 'Tree walking enabled (backward compatible)'
                        : 'Only InheritedWidget rebuilds (optimized)',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  value: _autoRebuild,
                  onChanged: (value) {
                    setState(() {
                      _autoRebuild = value;
                    });
                  },
                ),
                10.verticalSpace,
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: _autoRebuild
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _autoRebuild ? Icons.warning : Icons.check_circle,
                        size: 16.sp,
                        color: _autoRebuild
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          _autoRebuild
                              ? 'Default mode: All widgets rebuild'
                              : 'Performance mode: Only dependent widgets rebuild',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextSuDemo() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: Colors.green.shade700, size: 24.sp),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  'context.su Extension',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            'Convenient access to ScreenUtilPlus with automatic dependency registration',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          15.verticalSpace,
          const _ContextAwareWidget(),
        ],
      ),
    );
  }

  Widget _buildRebuildCounters() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade200, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange.shade700,
                size: 24.sp,
              ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  'How It Works',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18.sp,
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
                _buildExplanationRow(
                  Icons.extension,
                  'Extension Methods (.w, .h, .sp)',
                  'Access singleton directly - rebuild with autoRebuild: true',
                  Colors.orange,
                ),
                10.verticalSpace,
                _buildExplanationRow(
                  Icons.code,
                  'context.su',
                  'Registers InheritedWidget dependency - always rebuilds when metrics change',
                  Colors.green,
                ),
                10.verticalSpace,
                _buildExplanationRow(
                  Icons.widgets,
                  'R-Widgets (RContainer, RText)',
                  'Use context.su internally - always rebuild when metrics change',
                  Colors.blue,
                ),
              ],
            ),
          ),
          15.verticalSpace,
          _ContextAwareWidget(),
          15.verticalSpace,
          _RegularWidget(),
        ],
      ),
    );
  }

  Widget _buildExplanationRow(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: color),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              4.verticalSpace,
              Text(
                description,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceInfo() {
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
              Icon(Icons.speed, color: Colors.purple.shade700, size: 24.sp),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  'Performance Benefits',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          _buildBenefitRow(
            Icons.check_circle,
            'Efficient Rebuilds',
            'Only widgets that need it rebuild',
          ),
          _buildBenefitRow(
            Icons.architecture,
            'Idiomatic Flutter',
            'Uses standard InheritedWidget pattern',
          ),
          _buildBenefitRow(
            Icons.tune,
            'Opt-in Control',
            'Choose between compatibility and performance',
          ),
          _buildBenefitRow(
            Icons.code,
            'Explicit Dependencies',
            'Clear which widgets depend on screen metrics',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: Colors.purple.shade700),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                2.verticalSpace,
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageExamples() {
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
                Icons.integration_instructions,
                color: Colors.teal.shade700,
                size: 24.sp,
              ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  'Usage Examples',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          _buildCodeExample('Using context.su', '''
Widget build(BuildContext context) {
  final su = context.su;
  return Container(
    width: su.setWidth(100),
    height: su.setHeight(50),
  );
}'''),
          15.verticalSpace,
          _buildCodeExample('Using ScreenUtilPlus.of(context)', '''
Widget build(BuildContext context) {
  final su = ScreenUtilPlus.of(context);
  return Text(
    'Hello',
    style: TextStyle(fontSize: su.setSp(16)),
  );
}'''),
          15.verticalSpace,
          _buildCodeExample('With autoRebuild: false', '''
ScreenUtilPlusInit(
  designSize: const Size(375, 812),
  autoRebuild: false, // Performance mode
  child: MyApp(),
)'''),
        ],
      ),
    );
  }

  Widget _buildCodeExample(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.teal.shade700,
          ),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            code,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'monospace',
              color: Colors.green.shade300,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget that uses context.su to register dependency
class _ContextAwareWidget extends StatelessWidget {
  const _ContextAwareWidget();

  @override
  Widget build(BuildContext context) {
    // Register dependency on ScreenUtilPlusScope
    final su = context.su;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, size: 16.sp, color: Colors.green),
              8.horizontalSpace,
              Flexible(
                child: Text(
                  'Context-Aware Widget',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            'This widget uses context.su and will rebuild when screen metrics change',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          8.verticalSpace,
          Container(
            width: su.setWidth(100),
            height: su.setHeight(50),
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                '100.w x 50.h',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget that doesn't use context.su
class _RegularWidget extends StatelessWidget {
  const _RegularWidget();

  @override
  Widget build(BuildContext context) {
    // Does NOT register dependency

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, size: 16.sp, color: Colors.blue),
              8.horizontalSpace,
              Flexible(
                child: Text(
                  'Regular Widget',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            'This widget does NOT use context.su. With autoRebuild: false, it won\'t rebuild on screen changes',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          8.verticalSpace,
          Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'Static Size',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

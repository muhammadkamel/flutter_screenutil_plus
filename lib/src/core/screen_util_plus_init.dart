import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/src/utils/font_size_resolvers.dart';
import 'package:flutter_screenutil_plus/src/utils/rebuild_factor.dart';
import 'package:flutter_screenutil_plus/src/utils/rebuild_factors.dart';
import 'package:flutter_screenutil_plus/src/utils/screen_util_init_builder.dart';

import '../internal/_flutter_widgets.dart';
import '../mixins/screenutil_mixin.dart';
import 'screen_util_plus.dart';

class ScreenUtilPlusInit extends StatefulWidget {
  /// A helper widget that initializes [ScreenUtilPlus].
  const ScreenUtilPlusInit({
    super.key,
    this.builder,
    this.child,
    this.rebuildFactor = RebuildFactors.size,
    this.designSize = ScreenUtilPlus.defaultSize,
    this.splitScreenMode = false,
    this.minTextAdapt = false,
    this.ensureScreenSize = false,
    this.enableScaleWH,
    this.enableScaleText,
    this.responsiveWidgets,
    this.fontSizeResolver = FontSizeResolvers.width,
  });

  final ScreenUtilInitBuilder? builder;
  final Widget? child;
  final bool splitScreenMode;
  final bool minTextAdapt;
  final bool ensureScreenSize;
  final bool Function()? enableScaleWH;
  final bool Function()? enableScaleText;
  final RebuildFactor rebuildFactor;
  final FontSizeResolver fontSizeResolver;

  /// The [Size] of the device in the design draft, in dp.
  final Size designSize;
  final Iterable<String>? responsiveWidgets;

  @override
  State<ScreenUtilPlusInit> createState() => _ScreenUtilPlusInitState();
}

class _ScreenUtilPlusInitState extends State<ScreenUtilPlusInit>
    with WidgetsBindingObserver {
  final _canMarkedToBuild = HashSet<String>();
  MediaQueryData? _mediaQueryData;
  final _binding = WidgetsBinding.instance;
  final _screenSizeCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    if (widget.responsiveWidgets != null) {
      _canMarkedToBuild.addAll(widget.responsiveWidgets!);
    }

    ScreenUtilPlus.enableScale(
      enableWH: widget.enableScaleWH,
      enableText: widget.enableScaleText,
    );

    if (widget.ensureScreenSize) {
      ScreenUtilPlus.ensureScreenSize().then(_screenSizeCompleter.complete);
    } else {
      _screenSizeCompleter.complete();
    }

    _binding.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _revalidate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _revalidate();
  }

  MediaQueryData? _getMediaQueryData() {
    final view = View.maybeOf(context);
    return view != null ? MediaQueryData.fromView(view) : null;
  }

  bool _shouldMarkForBuild(Element element) {
    final widgetName = element.widget.runtimeType.toString();

    // Always rebuild if widget uses SU mixin
    if (element.widget is SU) return true;

    // Rebuild if explicitly in responsive widgets list
    if (_canMarkedToBuild.contains(widgetName)) return true;

    // Don't rebuild Flutter widgets or private widgets
    if (widgetName.startsWith('_') || flutterWidgets.contains(widgetName)) {
      return false;
    }

    return true;
  }

  void _markNeedsBuildIfAllowed(Element element) {
    if (_shouldMarkForBuild(element)) {
      element.markNeedsBuild();
    }
  }

  void _updateTree(Element el) {
    _markNeedsBuildIfAllowed(el);
    el.visitChildren(_updateTree);
  }

  void _revalidate([void Function()? callback]) {
    final newData = _getMediaQueryData();
    if (newData == null) return;

    final oldData = _mediaQueryData;
    final shouldUpdate =
        oldData == null || widget.rebuildFactor(oldData, newData);

    if (shouldUpdate) {
      setState(() {
        _mediaQueryData = newData;
        _updateTree(context as Element);
        callback?.call();
      });
    }
  }

  void _configureScreenUtil(MediaQueryData mediaQueryData) {
    ScreenUtilPlus.configure(
      data: mediaQueryData,
      designSize: widget.designSize,
      splitScreenMode: widget.splitScreenMode,
      minTextAdapt: widget.minTextAdapt,
      fontSizeResolver: widget.fontSizeResolver,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = _mediaQueryData;
    if (mediaQueryData == null) {
      return const SizedBox.shrink();
    }

    _configureScreenUtil(mediaQueryData);

    if (!widget.ensureScreenSize) {
      return widget.builder?.call(context, widget.child) ?? widget.child!;
    }

    return FutureBuilder<void>(
      future: _screenSizeCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.builder?.call(context, widget.child) ?? widget.child!;
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _binding.removeObserver(this);
    super.dispose();
  }
}

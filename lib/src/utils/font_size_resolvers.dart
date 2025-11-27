import 'package:flutter_screenutil_plus/src/core/screen_util_plus.dart';

abstract class FontSizeResolvers {
  static double width(num fontSize, ScreenUtilPlus instance) {
    return instance.setWidth(fontSize);
  }

  static double height(num fontSize, ScreenUtilPlus instance) {
    return instance.setHeight(fontSize);
  }

  static double radius(num fontSize, ScreenUtilPlus instance) {
    return instance.radius(fontSize);
  }

  static double diameter(num fontSize, ScreenUtilPlus instance) {
    return instance.diameter(fontSize);
  }

  static double diagonal(num fontSize, ScreenUtilPlus instance) {
    return instance.diagonal(fontSize);
  }
}

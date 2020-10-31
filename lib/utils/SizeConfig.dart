import 'package:flutter/cupertino.dart';

class SizeConfig {
  static MediaQueryData mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double _dpi;
  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    // width = screenWidth / 100;
    // height = screenHeight / 100;
    _dpi = mediaQueryData.devicePixelRatio;
  }
}

extension Int2px on int {
  double get dp {
    return this *SizeConfig._dpi;
  }
}
extension Double2px on double {
  double get dp {
    return this *SizeConfig._dpi;
  }
}

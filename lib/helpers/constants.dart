import 'package:flutter/material.dart';

class Constants {
  static Size screenSize = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single)
      .size;
  static double screenHeight = screenSize.height;
  static double screenWidth = screenSize.width;
  static double statusBarHeight = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single)
      .padding
      .top;
}

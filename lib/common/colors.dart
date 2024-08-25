import 'package:flutter/material.dart';

class MyColors {
  static var appLightColor = const Color(0xFFfcdeb4);
  static var appLightLevel1 = const Color(0xFFfbc2a6);
  static var appDarkLevel1 = const Color(0xFFf47880);
  static var appDarkLevel2 = const Color(0xFF1F2327);
  static var appDark = const Color(0xFFec4d69);
  static var blackColor = const Color(0xFF111111);
  static var whiteColor = const Color(0xFFFFFFFF);
}

class MyGradientColors {
  static var gradientList = <List<Color>>[
    [
      const Color.fromRGBO(0, 70, 255, 1),
      const Color.fromRGBO(0, 150, 255, 1),
      // Color.fromRGBO(255, 90, 92, 1)
    ],
    [
      const Color.fromRGBO(0, 155, 60, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(255, 150, 0, 1),
      const Color.fromRGBO(255, 235, 0, 1),
    ],
    [
      const Color.fromRGBO(255, 0, 0, 1.0),
      const Color.fromRGBO(255, 90, 92, 1),
    ],
    [
      const Color.fromRGBO(100, 100, 100, 1),
      const Color.fromRGBO(180, 180, 180, 1),
      // Color.fromRGBO(255, 90, 92, 1),
    ],
  ];
}

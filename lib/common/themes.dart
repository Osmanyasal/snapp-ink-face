import 'package:flutter/material.dart';

import 'colors.dart';

class Themes {
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      hintColor: Colors.grey,
      scaffoldBackgroundColor: MyColors.appLightColor,
      appBarTheme: AppBarTheme(color: MyColors.appDarkLevel2),
      useMaterial3: false,
    );
  }
}

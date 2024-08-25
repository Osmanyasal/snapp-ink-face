import 'package:filter/view/screens/home/home_screen.dart';
import 'package:filter/view/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final Widget view;
    switch (settings.name) {
      case SplashScreen.routeName:
        view = const SplashScreen();
        break;
      case HomeScreen.routeName:
        view = const HomeScreen();
        break;
      default:
        view = const SplashScreen();
    }
    return MaterialPageRoute(builder: (_) => view, settings: settings);
  }
}

import 'package:filter/route_generator.dart';
import 'package:filter/utils/navigation_service.dart';
import 'package:filter/view/screens/splash/splash_screen.dart';
import 'package:filter/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;

import 'common/themes.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => di.serviceLocator<HomeViewModel>(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          title: 'Simply Filter',
          debugShowCheckedModeBanner: false,
          theme: Themes.darkTheme(context).copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
          //generate routes using the route generator class
          onGenerateRoute: RouteGenerator.generateRoute,
          onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (_) => const SplashScreen(), settings: settings),
        ),
      ),
    );
  }
}

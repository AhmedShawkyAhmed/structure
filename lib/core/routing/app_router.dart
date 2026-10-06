import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/features/auth/ui/screens/login_screen.dart';
import 'package:structure/features/auth/ui/screens/register_screen.dart';
import 'package:structure/features/device_info/ui/screens/device_diagnostics_screen.dart';
import 'package:structure/features/home/ui/views/home_view.dart';
import 'package:structure/features/on_boarding/ui/screens/on_boarding_screen.dart';
import 'package:structure/features/shared/ui/screens/un_known_screen.dart';
import 'package:structure/features/splash/ui/screens/splash_screen.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name == '/'
        ? AppRoutes.home.path
        : settings.name ?? '';

    final AppRoutes navigatedRoute =
        AppRoutes.values.firstWhereOrNull((route) => route.path == routeName) ??
        AppRoutes.unknown;

    AppLogs.routeLog('NavigatedRoute: $navigatedRoute', runtimeType: AppRouter);

    switch (navigatedRoute) {
      case AppRoutes.unknown:
        return RouteTransition.fade(page: const UnKnownScreen());
      case AppRoutes.deviceInfo:
        return RouteTransition.fade(page: const DeviceDiagnosticsScreen());
      case AppRoutes.splash:
        return RouteTransition.fade(page: const SplashScreen());
      case AppRoutes.onBoarding:
        return RouteTransition.fade(page: const OnBoardingScreen());
      case AppRoutes.register:
        return RouteTransition.fade(page: const RegisterScreen());
      case AppRoutes.login:
        return RouteTransition.fade(page: const LoginScreen());
      case AppRoutes.home:
        return RouteTransition.fade(page: const HomeView());
    }
  }
}

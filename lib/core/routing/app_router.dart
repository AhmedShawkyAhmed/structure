import 'package:flutter/material.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/features/auth/ui/screens/login_screen.dart';
import 'package:structure/features/auth/ui/screens/register_screen.dart';
import 'package:structure/features/device_info/ui/screens/device_diagnostics_screen.dart';
import 'package:structure/features/home/ui/views/home_view.dart';
import 'package:structure/features/issue_reporting/data/issue_report.dart';
import 'package:structure/features/issue_reporting/ui/issue_report_view.dart';
import 'package:structure/features/issue_reporting/ui/issue_reporting_home_view.dart';
import 'package:structure/features/on_boarding/ui/screens/on_boarding_screen.dart';
import 'package:structure/features/shared/ui/screens/un_known_screen.dart';
import 'package:structure/features/splash/ui/screens/splash_screen.dart';
import 'package:structure/features/twist/ui/views/twist_view.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name == '/' ? AppRoutes.home.path : settings.name;
    final route = AppRoutes.values.firstWhere(
      (route) => route.path == name,
      orElse: () => AppRoutes.unknown,
    );
    final Widget page = switch (route) {
      AppRoutes.unknown => const UnKnownScreen(),
      AppRoutes.deviceInfo => const DeviceDiagnosticsScreen(),
      AppRoutes.twist => const TwistView(),
      AppRoutes.issueReporting => const IssueReportingHomeView(),
      AppRoutes.issueReport => IssueReportView(
        arguments: settings.arguments is IssueReportArguments
            ? settings.arguments! as IssueReportArguments
            : IssueReportArguments(screen: AppRoutes.home.path),
      ),
      AppRoutes.splash => const SplashScreen(),
      AppRoutes.onBoarding => const OnBoardingScreen(),
      AppRoutes.register => const RegisterScreen(),
      AppRoutes.login => const LoginScreen(),
      AppRoutes.home => const HomeView(),
    };
    // Keep route names available to the reporter before its form opens.
    return PageRouteBuilder<dynamic>(
      settings: RouteSettings(name: route.path, arguments: settings.arguments),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}

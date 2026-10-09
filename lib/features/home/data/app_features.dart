import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../localization/generated/app_localizations.dart';

class AppFeature {
  const AppFeature({
    required this.route,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
  final AppRoutes route;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) subtitle;
  final IconData icon;
  final Color color;
}

/// Add a route and one entry here to expose a feature in the launcher.
final appFeatures = <AppFeature>[
  AppFeature(
    route: AppRoutes.twist,
    title: (l) => l.twistFeatureTitle,
    subtitle: (l) => l.twistFeatureSubtitle,
    icon: Icons.graphic_eq_rounded,
    color: const Color(0xff7C5CFC),
  ),
  AppFeature(
    route: AppRoutes.deviceInfo,
    title: (l) => l.deviceFeatureTitle,
    subtitle: (l) => l.deviceFeatureSubtitle,
    icon: Icons.phonelink_setup_rounded,
    color: const Color(0xff087E78),
  ),
  AppFeature(
    route: AppRoutes.issueReporting,
    title: (l) => l.reportFeatureTitle,
    subtitle: (l) => l.reportFeatureSubtitle,
    icon: Icons.bug_report_outlined,
    color: const Color(0xffDD7941),
  ),
  AppFeature(
    route: AppRoutes.login,
    title: (l) => l.loginFeatureTitle,
    subtitle: (l) => l.loginFeatureSubtitle,
    icon: Icons.login_rounded,
    color: const Color(0xff477DD6),
  ),
  AppFeature(
    route: AppRoutes.register,
    title: (l) => l.registerFeatureTitle,
    subtitle: (l) => l.registerFeatureSubtitle,
    icon: Icons.person_add_alt_rounded,
    color: const Color(0xff9C57A5),
  ),
  AppFeature(
    route: AppRoutes.onBoarding,
    title: (l) => l.onboardingFeatureTitle,
    subtitle: (l) => l.onboardingFeatureSubtitle,
    icon: Icons.auto_awesome_rounded,
    color: const Color(0xffAE8531),
  ),
];

import 'package:flutter/material.dart';
import 'package:navigation_service/navigation_service.dart';
import 'package:structure/core/helpers/localization_helper.dart';
import 'package:structure/core/routing/app_router.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

import 'app_builder.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter routes = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocalizationHelper.localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          builder: defaultAppBuilder,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routes.onGenerateRoute,
          initialRoute: '/',
          theme: ThemeData(
            fontFamily: LocalizationHelper.isArabic
                ? 'Cairo'
                : 'CenturyGothicPaneuropean',
            colorSchemeSeed: const Color(0xff7210FF),
            useMaterial3: true,
          ),
          title: 'Structure',
        );
      },
    );
  }
}
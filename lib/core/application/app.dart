import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:navigation_service/navigation_service.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/helpers/localization_helper.dart';
import 'package:structure/core/resources/app_theme.dart';
import 'package:structure/core/routing/app_router.dart';
import 'package:structure/features/issue_reporting/data/issue_reporting_controller.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';
import 'package:twist_music_player/twist_music_player.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppSizeConfig.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocalizationHelper.localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          builder: defaultAppBuilder,
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            TwistMusicLocalizations.delegate,
          ],
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
          navigatorObservers: [
            serviceLocator<IssueReportingController>().routeObserver,
          ],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routes.onGenerateRoute,
          initialRoute: '/',
          theme: AppTheme.light,
          title: 'Structure',
        );
      },
    );
  }
}

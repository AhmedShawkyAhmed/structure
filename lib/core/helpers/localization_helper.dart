import 'package:core_utils/core_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:navigation_service/navigation_service.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';
import 'package:structure/features/localization/generated/app_localizations_ar.dart';

class LocalizationHelper {
  LocalizationHelper._();

  static final LocalizationHelper _instance = LocalizationHelper._();

  factory LocalizationHelper() => _instance;

  static final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(
    Locale(
      //     DatabaseHelper.getItem(
      //   boxName: DatabaseBox.appBox,
      //   key: DatabaseKey.language,
      // ) ??
      Languages.en.name,
    ),
  );

  /// Use localization without context.
  ///
  /// If context is null, it will use [AppLocalizationsAr]
  static AppLocalizations get tr {
    var context = NavigationService.navigatorKey.currentContext;
    if (context != null) {
      return AppLocalizations.of(context);
    } else {
      AppLogs.errorLog('Localization: can\'t find context, using ar fallback');
    }
    return AppLocalizationsAr();
  }

  static bool get isArabic {
    var context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      AppLogs.errorLog('Localization: can\'t find context, using ar fallback');
      return true;
    }
    return Directionality.of(context) == TextDirection.rtl;
  }

  static String get currentLocalName {
    return localeNotifier.value.languageCode;
  }

  static void changeLocal(Languages language) {
    // DatabaseHelper.putItem(
    //   boxName: DatabaseBox.appBox,
    //   key: DatabaseKey.language,
    //   item: language.name,
    // );
    localeNotifier.value = Locale(language.name);
  }
}

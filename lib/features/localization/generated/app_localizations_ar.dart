// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get arabic => 'عربي';

  @override
  String get english => 'إنجليزي';

  @override
  String get musicHeroTitle => 'موسيقى لكل لحظة';

  @override
  String get musicHeroSubtitle =>
      'اكتشف أحدث الأغاني واستمتع بمقاطع مدتها 30 ثانية.';

  @override
  String get musicEmptyTitle => 'الموسيقى تأخذ استراحة قصيرة';

  @override
  String get musicEmptySubtitle => 'تعذر تحميل أحدث الأغاني. حاول مرة أخرى.';

  @override
  String get tryAgain => 'حاول مرة أخرى';
}

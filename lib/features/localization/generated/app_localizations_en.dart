// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get musicHeroTitle => 'Music for every moment';

  @override
  String get musicHeroSubtitle =>
      'Discover new tracks and enjoy 30-second previews.';

  @override
  String get musicEmptyTitle => 'Music is taking a quick break';

  @override
  String get musicEmptySubtitle =>
      'We couldn\'t load the latest tracks. Please try again.';

  @override
  String get tryAgain => 'Try again';
}

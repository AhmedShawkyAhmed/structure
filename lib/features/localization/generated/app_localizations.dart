import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'عربي'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'إنجليزي'**
  String get english;

  /// No description provided for @musicHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'موسيقى لكل لحظة'**
  String get musicHeroTitle;

  /// No description provided for @musicHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف أحدث الأغاني واستمتع بمقاطع مدتها 30 ثانية.'**
  String get musicHeroSubtitle;

  /// No description provided for @musicEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'الموسيقى تأخذ استراحة قصيرة'**
  String get musicEmptyTitle;

  /// No description provided for @musicEmptySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل أحدث الأغاني. حاول مرة أخرى.'**
  String get musicEmptySubtitle;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get tryAgain;

  /// No description provided for @featureHubTitle.
  ///
  /// In ar, this message translates to:
  /// **'مساحة الميزات'**
  String get featureHubTitle;

  /// No description provided for @featureHubSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استكشف كل ميزة في مساحة مستقلة.'**
  String get featureHubSubtitle;

  /// No description provided for @twistFeatureTitle.
  ///
  /// In ar, this message translates to:
  /// **'موسيقى تويست'**
  String get twistFeatureTitle;

  /// No description provided for @twistFeatureSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف الأغاني واستمع إلى المقاطع الموسيقية.'**
  String get twistFeatureSubtitle;

  /// No description provided for @deviceFeatureTitle.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الجهاز'**
  String get deviceFeatureTitle;

  /// No description provided for @deviceFeatureSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استكشف هوية الجهاز ومواصفاته وبيانات التشخيص.'**
  String get deviceFeatureSubtitle;

  /// No description provided for @reportFeatureTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن مشكلة'**
  String get reportFeatureTitle;

  /// No description provided for @reportFeatureSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أرسل ملاحظاتك مع صور الشاشة والفيديو.'**
  String get reportFeatureSubtitle;

  /// No description provided for @loginFeatureTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginFeatureTitle;

  /// No description provided for @loginFeatureSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'جرّب خطوات المصادقة وتسجيل الدخول.'**
  String get loginFeatureSubtitle;

  /// No description provided for @registerFeatureTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get registerFeatureTitle;

  /// No description provided for @registerFeatureSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استكشف تسجيل حساب جديد.'**
  String get registerFeatureSubtitle;

  /// No description provided for @onboardingFeatureTitle.
  ///
  /// In ar, this message translates to:
  /// **'التعريف بالتطبيق'**
  String get onboardingFeatureTitle;

  /// No description provided for @onboardingFeatureSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استعرض مقدمة التطبيق.'**
  String get onboardingFeatureSubtitle;

  /// No description provided for @reportIssue.
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن مشكلة'**
  String get reportIssue;

  /// No description provided for @reportSimulationNotice.
  ///
  /// In ar, this message translates to:
  /// **'وضع الاختبار: يتم محاكاة الإرسال دون رفع أي بلاغ.'**
  String get reportSimulationNotice;

  /// No description provided for @reportSimulatedTitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتملت المحاكاة'**
  String get reportSimulatedTitle;

  /// No description provided for @reportSimulatedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم رفع أي بلاغ. راجع وحدة التحكم للاطلاع على الطلب والاستجابة التجريبية.'**
  String get reportSimulatedSubtitle;

  /// No description provided for @reportPrompt.
  ///
  /// In ar, this message translates to:
  /// **'صف المشكلة واختر ما تريد مشاركته مع فريق دعم التطبيق. لن يتم رفع أي شيء حتى تراجع التقرير وتضغط إرسال.'**
  String get reportPrompt;

  /// No description provided for @includeScreenshot.
  ///
  /// In ar, this message translates to:
  /// **'إرفاق الشاشة الحالية'**
  String get includeScreenshot;

  /// No description provided for @screenshotConsent.
  ///
  /// In ar, this message translates to:
  /// **'سيتم التقاط شاشة التطبيق بعد المتابعة. يمكنك معاينتها وإزالتها قبل الإرسال.'**
  String get screenshotConsent;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @continueReport.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueReport;

  /// No description provided for @screenshotFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر التقاط الشاشة. يمكنك إرفاق صورة من معرض الصور.'**
  String get screenshotFailed;

  /// No description provided for @shakeToReport.
  ///
  /// In ar, this message translates to:
  /// **'هز الجهاز للإبلاغ'**
  String get shakeToReport;

  /// No description provided for @shakeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'هز جهازك أثناء فتح التطبيق لبدء تقرير.'**
  String get shakeSubtitle;

  /// No description provided for @reportHomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'ساعدنا على التحسين'**
  String get reportHomeTitle;

  /// No description provided for @reportHomeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أخبرنا بالمشكلة واختر الصور والفيديو والتفاصيل التقنية التي تريد مشاركتها.'**
  String get reportHomeSubtitle;

  /// No description provided for @startReport.
  ///
  /// In ar, this message translates to:
  /// **'بدء تقرير'**
  String get startReport;

  /// No description provided for @reportMediaLimits.
  ///
  /// In ar, this message translates to:
  /// **'حتى ٣ صور JPG/PNG وفيديو MP4/MOV واحد. الحد الأقصى ٥٠ ميجابايت لكل ملف و٦٠ ثانية للفيديو.'**
  String get reportMediaLimits;

  /// No description provided for @reportDraftNotice.
  ///
  /// In ar, this message translates to:
  /// **'يتم حفظ الوصف والملفات المختارة كمسودة على هذا الجهاز حتى ترسلها أو تحذفها.'**
  String get reportDraftNotice;

  /// No description provided for @uploadNotConfigured.
  ///
  /// In ar, this message translates to:
  /// **'رفع التقارير غير متاح بعد. يمكنك إعداد مسودة وإرسالها عند توصيل خدمة الدعم.'**
  String get uploadNotConfigured;

  /// No description provided for @reportDescription.
  ///
  /// In ar, this message translates to:
  /// **'ماذا حدث؟'**
  String get reportDescription;

  /// No description provided for @reportDescriptionHint.
  ///
  /// In ar, this message translates to:
  /// **'صف المشكلة والخطوات التي تؤدي إليها…'**
  String get reportDescriptionHint;

  /// No description provided for @reportExpected.
  ///
  /// In ar, this message translates to:
  /// **'ماذا توقعت أن يحدث؟ (اختياري)'**
  String get reportExpected;

  /// No description provided for @reportExpectedHint.
  ///
  /// In ar, this message translates to:
  /// **'أخبرنا بما كان ينبغي أن يحدث…'**
  String get reportExpectedHint;

  /// No description provided for @reportAttachments.
  ///
  /// In ar, this message translates to:
  /// **'المرفقات'**
  String get reportAttachments;

  /// No description provided for @addScreenshots.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صور'**
  String get addScreenshots;

  /// No description provided for @addVideo.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فيديو'**
  String get addVideo;

  /// No description provided for @removeAttachment.
  ///
  /// In ar, this message translates to:
  /// **'إزالة المرفق'**
  String get removeAttachment;

  /// No description provided for @previewAttachment.
  ///
  /// In ar, this message translates to:
  /// **'معاينة المرفق'**
  String get previewAttachment;

  /// No description provided for @reportDiagnostics.
  ///
  /// In ar, this message translates to:
  /// **'تضمين التفاصيل التقنية'**
  String get reportDiagnostics;

  /// No description provided for @reportDiagnosticsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إصدار التطبيق ونظام التشغيل وطراز الجهاز والمنصة فقط. راجع التفاصيل التي تم جمعها أدناه.'**
  String get reportDiagnosticsSubtitle;

  /// No description provided for @reportConsent.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على مشاركة هذا الوصف والمرفقات المختارة وأي تفاصيل تقنية مفعّلة مع فريق دعم التطبيق.'**
  String get reportConsent;

  /// No description provided for @sendReport.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقرير'**
  String get sendReport;

  /// No description provided for @retryReport.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال'**
  String get retryReport;

  /// No description provided for @sendingReport.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ إرسال التقرير…'**
  String get sendingReport;

  /// No description provided for @cancelUpload.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الرفع'**
  String get cancelUpload;

  /// No description provided for @reportSentTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم استلام التقرير'**
  String get reportSentTitle;

  /// No description provided for @reportSentSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لك. استلم فريق دعم التطبيق تقريرك.'**
  String get reportSentSubtitle;

  /// No description provided for @reportReference.
  ///
  /// In ar, this message translates to:
  /// **'الرقم المرجعي'**
  String get reportReference;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @discardDraft.
  ///
  /// In ar, this message translates to:
  /// **'حذف المسودة'**
  String get discardDraft;

  /// No description provided for @discardDraftPrompt.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف مسودة التقرير والنسخ المحلية من المرفقات؟'**
  String get discardDraftPrompt;

  /// No description provided for @discard.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get discard;

  /// No description provided for @reportDescriptionRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى وصف المشكلة.'**
  String get reportDescriptionRequired;

  /// No description provided for @reportConsentRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى الموافقة على مشاركة التقرير قبل إرساله.'**
  String get reportConsentRequired;

  /// No description provided for @reportTooManyImages.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك إرفاق ٣ صور كحد أقصى.'**
  String get reportTooManyImages;

  /// No description provided for @reportTooManyVideos.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك إرفاق فيديو واحد.'**
  String get reportTooManyVideos;

  /// No description provided for @reportFileTooLarge.
  ///
  /// In ar, this message translates to:
  /// **'اختر ملفاً غير فارغ لا يزيد حجمه عن ٥٠ ميجابايت.'**
  String get reportFileTooLarge;

  /// No description provided for @reportUnsupportedMedia.
  ///
  /// In ar, this message translates to:
  /// **'اختر صورة JPG/PNG أو فيديو MP4/MOV.'**
  String get reportUnsupportedMedia;

  /// No description provided for @reportVideoTooLong.
  ///
  /// In ar, this message translates to:
  /// **'اختر فيديو لا تتجاوز مدته ٦٠ ثانية.'**
  String get reportVideoTooLong;

  /// No description provided for @reportMediaUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح الملف. جرّب ملفاً آخر.'**
  String get reportMediaUnavailable;

  /// No description provided for @reportStorageUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ المسودة محلياً. حاول مرة أخرى.'**
  String get reportStorageUnavailable;

  /// No description provided for @reportDiagnosticsUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'تعذر جمع التفاصيل التقنية. يمكنك إرسال التقرير بدونها.'**
  String get reportDiagnosticsUnavailable;

  /// No description provided for @reportUploadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إرسال التقرير. تم الاحتفاظ بالمسودة؛ حاول مجدداً.'**
  String get reportUploadFailed;

  /// No description provided for @reportInvalidResponse.
  ///
  /// In ar, this message translates to:
  /// **'لم تؤكد خدمة الدعم استلام التقرير. تم الاحتفاظ بالمسودة؛ إعادة المحاولة تستخدم نفس معرّف التقرير.'**
  String get reportInvalidResponse;

  /// No description provided for @reportCancelled.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الرفع والاحتفاظ بالمسودة. قد يكون الخادم استلم التقرير بالفعل؛ إعادة المحاولة تستخدم نفس معرّفه.'**
  String get reportCancelled;

  /// No description provided for @shakeSettingFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ إعداد الهز. حاول مرة أخرى.'**
  String get shakeSettingFailed;

  /// No description provided for @videoPreviewFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذرت معاينة الفيديو.'**
  String get videoPreviewFailed;

  /// No description provided for @reportScreen.
  ///
  /// In ar, this message translates to:
  /// **'الشاشة التي حدثت فيها المشكلة'**
  String get reportScreen;

  /// No description provided for @workspaceEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'مساحتك اليومية'**
  String get workspaceEyebrow;

  /// No description provided for @exploreFeatures.
  ///
  /// In ar, this message translates to:
  /// **'استكشف مساحتك'**
  String get exploreFeatures;

  /// No description provided for @openMusic.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف الموسيقى'**
  String get openMusic;

  /// No description provided for @quickReportTitle.
  ///
  /// In ar, this message translates to:
  /// **'هل واجهت مشكلة؟'**
  String get quickReportTitle;

  /// No description provided for @quickReportSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'هزة سريعة تبدأ تقريراً.'**
  String get quickReportSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك وتابع من حيث توقفت.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @firstNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الأول'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم العائلة'**
  String get lastNameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPasswordLabel;

  /// No description provided for @createAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'مساحتك بانتظارك'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك للبدء.'**
  String get createAccountSubtitle;

  /// No description provided for @noAccount.
  ///
  /// In ar, this message translates to:
  /// **'جديد هنا؟'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟'**
  String get haveAccount;

  /// No description provided for @showPassword.
  ///
  /// In ar, this message translates to:
  /// **'إظهار كلمة المرور'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء كلمة المرور'**
  String get hidePassword;

  /// No description provided for @emailRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريداً إلكترونياً صحيحاً.'**
  String get emailRequired;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إكمال هذا الحقل.'**
  String get fieldRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين.'**
  String get passwordMismatch;

  /// No description provided for @onboardingTitle.
  ///
  /// In ar, this message translates to:
  /// **'مساحة للأشياء التي تحبها'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف الموسيقى وتعرّف على جهازك وساعد في تحسين كل تجربة.'**
  String get onboardingSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In ar, this message translates to:
  /// **'لنبدأ الاستكشاف'**
  String get getStarted;

  /// No description provided for @reportDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'أخبرنا بالتفاصيل'**
  String get reportDetailsTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنت من يقرر'**
  String get privacyTitle;

  /// No description provided for @pageNotFound.
  ///
  /// In ar, this message translates to:
  /// **'هذه الصفحة غير متاحة'**
  String get pageNotFound;

  /// No description provided for @backToHome.
  ///
  /// In ar, this message translates to:
  /// **'العودة لمساحتك'**
  String get backToHome;

  /// No description provided for @deviceDiagnosticsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نظرة أقرب إلى الجهاز بين يديك.'**
  String get deviceDiagnosticsSubtitle;

  /// No description provided for @deviceDataTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الجهاز'**
  String get deviceDataTitle;

  /// No description provided for @deviceFieldCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} حقلاً'**
  String deviceFieldCount(int count);

  /// No description provided for @selectedDeviceId.
  ///
  /// In ar, this message translates to:
  /// **'معرّف الجهاز'**
  String get selectedDeviceId;

  /// No description provided for @collectingDeviceData.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ جمع البيانات…'**
  String get collectingDeviceData;

  /// No description provided for @copyDeviceData.
  ///
  /// In ar, this message translates to:
  /// **'نسخ تفاصيل الجهاز'**
  String get copyDeviceData;

  /// No description provided for @deviceDataCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ تفاصيل الجهاز'**
  String get deviceDataCopied;

  /// No description provided for @refreshDeviceData.
  ///
  /// In ar, this message translates to:
  /// **'تحديث التفاصيل'**
  String get refreshDeviceData;

  /// No description provided for @deviceDataFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر جمع تفاصيل الجهاز'**
  String get deviceDataFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

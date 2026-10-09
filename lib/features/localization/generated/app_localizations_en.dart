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

  @override
  String get featureHubTitle => 'Your feature workspace';

  @override
  String get featureHubSubtitle => 'Explore each feature in its own space.';

  @override
  String get twistFeatureTitle => 'Twist music';

  @override
  String get twistFeatureSubtitle =>
      'Discover tracks and listen to music previews.';

  @override
  String get deviceFeatureTitle => 'Device info';

  @override
  String get deviceFeatureSubtitle =>
      'Explore device identity, hardware, and diagnostics.';

  @override
  String get reportFeatureTitle => 'Issue reporting';

  @override
  String get reportFeatureSubtitle =>
      'Send feedback with screenshots and videos.';

  @override
  String get loginFeatureTitle => 'Login';

  @override
  String get loginFeatureSubtitle => 'Try the authentication and login flow.';

  @override
  String get registerFeatureTitle => 'Register';

  @override
  String get registerFeatureSubtitle => 'Explore account registration.';

  @override
  String get onboardingFeatureTitle => 'Onboarding';

  @override
  String get onboardingFeatureSubtitle => 'Preview the app introduction.';

  @override
  String get reportIssue => 'Report an issue';

  @override
  String get reportSimulationNotice =>
      'Test mode: submissions are simulated. No report is uploaded.';

  @override
  String get reportSimulatedTitle => 'Simulation complete';

  @override
  String get reportSimulatedSubtitle =>
      'No report was uploaded. Check the debug console for the request and simulated response.';

  @override
  String get reportPrompt =>
      'Describe an issue and choose what to share with the app support team. Nothing is uploaded until you review the report and tap Send.';

  @override
  String get includeScreenshot => 'Attach the current screen';

  @override
  String get screenshotConsent =>
      'Capture this app screen after you continue. You can preview and remove it before sending.';

  @override
  String get cancel => 'Cancel';

  @override
  String get continueReport => 'Continue';

  @override
  String get screenshotFailed =>
      'Could not capture this screen. You can attach a screenshot from your gallery.';

  @override
  String get shakeToReport => 'Shake to report';

  @override
  String get shakeSubtitle =>
      'Shake your device while the app is open to start a report.';

  @override
  String get reportHomeTitle => 'Help us improve';

  @override
  String get reportHomeSubtitle =>
      'Tell us what went wrong. You choose which screenshots, videos, and technical details to share.';

  @override
  String get startReport => 'Start a report';

  @override
  String get reportMediaLimits =>
      'Up to 3 JPG/PNG images and 1 MP4/MOV video. Maximum 50 MB per file and 60 seconds per video.';

  @override
  String get reportDraftNotice =>
      'Your description and selected media are stored as a draft on this device until you send or discard them.';

  @override
  String get uploadNotConfigured =>
      'Report uploads are not available yet. You can prepare a draft and send it when support is connected.';

  @override
  String get reportDescription => 'What happened?';

  @override
  String get reportDescriptionHint =>
      'Describe the issue and the steps to reproduce it…';

  @override
  String get reportExpected => 'What did you expect? (optional)';

  @override
  String get reportExpectedHint => 'Tell us what should have happened…';

  @override
  String get reportAttachments => 'Attachments';

  @override
  String get addScreenshots => 'Add images';

  @override
  String get addVideo => 'Add video';

  @override
  String get removeAttachment => 'Remove attachment';

  @override
  String get previewAttachment => 'Preview attachment';

  @override
  String get reportDiagnostics => 'Include technical details';

  @override
  String get reportDiagnosticsSubtitle =>
      'App version, OS version, device model, and platform only. Review the collected details below.';

  @override
  String get reportConsent =>
      'I agree to share this description, selected attachments, and any enabled technical details with the app support team.';

  @override
  String get sendReport => 'Send report';

  @override
  String get retryReport => 'Retry sending';

  @override
  String get sendingReport => 'Sending report…';

  @override
  String get cancelUpload => 'Cancel upload';

  @override
  String get reportSentTitle => 'Report received';

  @override
  String get reportSentSubtitle =>
      'Thank you. Your report was received by the app support team.';

  @override
  String get reportReference => 'Reference';

  @override
  String get done => 'Done';

  @override
  String get discardDraft => 'Discard draft';

  @override
  String get discardDraftPrompt =>
      'Delete this report draft and its local attachment copies?';

  @override
  String get discard => 'Discard';

  @override
  String get reportDescriptionRequired => 'Please describe the issue.';

  @override
  String get reportConsentRequired =>
      'Please agree to sharing the report before sending.';

  @override
  String get reportTooManyImages => 'You can attach up to 3 images.';

  @override
  String get reportTooManyVideos => 'You can attach 1 video.';

  @override
  String get reportFileTooLarge =>
      'Choose a non-empty file no larger than 50 MB.';

  @override
  String get reportUnsupportedMedia =>
      'Choose a JPG/PNG image or an MP4/MOV video.';

  @override
  String get reportVideoTooLong => 'Choose a video no longer than 60 seconds.';

  @override
  String get reportMediaUnavailable =>
      'Could not open this media. Try another file.';

  @override
  String get reportStorageUnavailable =>
      'Could not save the local draft. Please try again.';

  @override
  String get reportDiagnosticsUnavailable =>
      'Could not collect technical details. You can send the report without them.';

  @override
  String get reportUploadFailed =>
      'Could not send the report. Your draft is kept; please retry.';

  @override
  String get reportInvalidResponse =>
      'Support did not confirm receipt. Your draft is kept; retrying uses the same report ID.';

  @override
  String get reportCancelled =>
      'Upload cancelled. Your draft is kept. The server may already have received it; retrying uses the same report ID.';

  @override
  String get shakeSettingFailed =>
      'Could not save your shake preference. Please try again.';

  @override
  String get videoPreviewFailed => 'Could not preview this video.';

  @override
  String get reportScreen => 'Screen where the issue occurred';
}

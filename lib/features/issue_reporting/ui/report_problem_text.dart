import '../../localization/generated/app_localizations.dart';
import '../data/issue_report.dart';

String reportProblemText(AppLocalizations l, ReportProblem problem) =>
    switch (problem) {
      ReportProblem.descriptionRequired => l.reportDescriptionRequired,
      ReportProblem.consentRequired => l.reportConsentRequired,
      ReportProblem.tooManyImages => l.reportTooManyImages,
      ReportProblem.tooManyVideos => l.reportTooManyVideos,
      ReportProblem.fileTooLarge => l.reportFileTooLarge,
      ReportProblem.unsupportedMedia => l.reportUnsupportedMedia,
      ReportProblem.videoTooLong => l.reportVideoTooLong,
      ReportProblem.mediaUnavailable => l.reportMediaUnavailable,
      ReportProblem.storageUnavailable => l.reportStorageUnavailable,
      ReportProblem.diagnosticsUnavailable => l.reportDiagnosticsUnavailable,
      ReportProblem.notConfigured => l.uploadNotConfigured,
      ReportProblem.uploadFailed => l.reportUploadFailed,
      ReportProblem.invalidResponse => l.reportInvalidResponse,
      ReportProblem.cancelled => l.reportCancelled,
    };

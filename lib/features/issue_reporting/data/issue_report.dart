import 'package:image_picker/image_picker.dart';

enum AttachmentKind { image, video }

enum ReportStatus { editing, sending, sent, failed }

enum ReportProblem {
  descriptionRequired,
  consentRequired,
  tooManyImages,
  tooManyVideos,
  fileTooLarge,
  unsupportedMedia,
  videoTooLong,
  mediaUnavailable,
  storageUnavailable,
  diagnosticsUnavailable,
  notConfigured,
  uploadFailed,
  invalidResponse,
  cancelled,
}

class ReportException implements Exception {
  const ReportException(this.problem);
  final ReportProblem problem;
}

class ReportAttachment {
  const ReportAttachment({
    required this.path,
    required this.name,
    required this.kind,
    required this.bytes,
    required this.mimeType,
  });

  final String path;
  final String name;
  final AttachmentKind kind;
  final int bytes;
  final String mimeType;

  XFile get file => XFile(path, name: name, mimeType: mimeType);

  Map<String, Object?> toJson() => {
    'path': path,
    'name': name,
    'kind': kind.name,
    'bytes': bytes,
    'mimeType': mimeType,
  };

  factory ReportAttachment.fromJson(Map<String, dynamic> json) =>
      ReportAttachment(
        path: json['path'] as String,
        name: json['name'] as String,
        kind: AttachmentKind.values.byName(json['kind'] as String),
        bytes: json['bytes'] as int,
        mimeType: json['mimeType'] as String,
      );
}

class IssueReportState {
  const IssueReportState({
    required this.id,
    required this.screen,
    this.description = '',
    this.expected = '',
    this.attachments = const [],
    this.diagnostics,
    this.consent = false,
    this.status = ReportStatus.editing,
    this.progress = 0,
    this.preparing = false,
    this.problem,
    this.reference,
  });

  final String id;
  final String screen;
  final String description;
  final String expected;
  final List<ReportAttachment> attachments;
  final Map<String, Object?>? diagnostics;
  final bool consent;
  final ReportStatus status;
  final double progress;
  final bool preparing;
  final ReportProblem? problem;
  final String? reference;

  bool get sending => status == ReportStatus.sending;

  IssueReportState copyWith({
    String? id,
    String? description,
    String? expected,
    List<ReportAttachment>? attachments,
    Map<String, Object?>? diagnostics,
    bool removeDiagnostics = false,
    bool? consent,
    ReportStatus? status,
    double? progress,
    bool? preparing,
    ReportProblem? problem,
    String? reference,
  }) => IssueReportState(
    id: id ?? this.id,
    screen: screen,
    description: description ?? this.description,
    expected: expected ?? this.expected,
    attachments: attachments ?? this.attachments,
    diagnostics: removeDiagnostics ? null : diagnostics ?? this.diagnostics,
    consent: consent ?? this.consent,
    status: status ?? this.status,
    progress: progress ?? this.progress,
    preparing: preparing ?? this.preparing,
    problem: problem,
    reference: reference ?? this.reference,
  );

  // Diagnostic data and consent are deliberately excluded from local drafts.
  Map<String, Object?> toDraftJson() => {
    'id': id,
    'screen': screen,
    'description': description,
    'expected': expected,
    'hadDiagnostics': diagnostics != null,
    'attachments': attachments.map((item) => item.toJson()).toList(),
  };

  factory IssueReportState.fromDraftJson(Map<String, dynamic> json) =>
      IssueReportState(
        id: json['id'] as String,
        screen: json['screen'] as String,
        description: json['description'] as String,
        expected: json['expected'] as String,
        attachments: (json['attachments'] as List<dynamic>)
            .map(
              (item) => ReportAttachment.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
}

class IssueReportArguments {
  const IssueReportArguments({required this.screen, this.screenshot});
  final String screen;
  final XFile? screenshot;
}

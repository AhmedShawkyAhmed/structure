import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'issue_draft_store.dart';
import 'issue_report.dart';

class ReportMediaService {
  ReportMediaService(this._store, {ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  static const maxImages = 3;
  static const maxVideos = 1;
  static const maxFileBytes = 50 * 1024 * 1024;
  static const maxVideoDuration = Duration(seconds: 60);

  final IssueDraftStore _store;
  final ImagePicker _picker;

  Future<List<XFile>> pickImages() => _picker.pickMultiImage(
    maxWidth: 1920,
    maxHeight: 1920,
    imageQuality: 85,
    requestFullMetadata: false,
  );

  Future<XFile?> pickVideo() => _picker.pickVideo(source: ImageSource.gallery);

  Future<List<XFile>> recoverLostMedia() async {
    if (!Platform.isAndroid) {
      return const [];
    }
    final lost = await _picker.retrieveLostData();
    if (lost.exception != null) {
      throw const ReportException(ReportProblem.mediaUnavailable);
    }
    return lost.files ?? const [];
  }

  Future<ReportAttachment> prepare(
    XFile file,
    List<ReportAttachment> existing,
  ) async {
    final length = await file.length();
    if (length == 0 || length > maxFileBytes) {
      throw const ReportException(ReportProblem.fileTooLarge);
    }
    // Match file signatures rather than trusting the gallery filename.
    final header = await file
        .openRead(0, length < 64 ? length : 64)
        .fold<List<int>>([], (bytes, chunk) => bytes..addAll(chunk));
    final mime = _mimeType(header);
    if (mime == null) {
      throw const ReportException(ReportProblem.unsupportedMedia);
    }
    final kind = mime.startsWith('image/')
        ? AttachmentKind.image
        : AttachmentKind.video;
    final count = existing.where((item) => item.kind == kind).length;
    if (count >= (kind == AttachmentKind.image ? maxImages : maxVideos)) {
      throw ReportException(
        kind == AttachmentKind.image
            ? ReportProblem.tooManyImages
            : ReportProblem.tooManyVideos,
      );
    }
    if (kind == AttachmentKind.video) {
      final player = VideoPlayerController.file(File(file.path));
      try {
        await player.initialize().timeout(const Duration(seconds: 15));
        if (player.value.duration > maxVideoDuration) {
          throw const ReportException(ReportProblem.videoTooLong);
        }
      } finally {
        await player.dispose();
      }
    }
    return _store.importFile(file, kind: kind, mimeType: mime);
  }

  static String? _mimeType(List<int> bytes) {
    if (bytes.length < 12) {
      return null;
    }
    if (bytes[0] == 0xff && bytes[1] == 0xd8 && bytes[2] == 0xff) {
      return 'image/jpeg';
    }
    if (bytes.take(8).join(',') == '137,80,78,71,13,10,26,10') {
      return 'image/png';
    }
    if (String.fromCharCodes(bytes.sublist(4, 8)) == 'ftyp') {
      final brand = String.fromCharCodes(bytes.sublist(8, 12));
      if (brand == 'qt  ') {
        return 'video/quicktime';
      }
      if ([
        'isom',
        'iso2',
        'mp41',
        'mp42',
        'avc1',
        'M4V ',
        'MSNV',
      ].contains(brand)) {
        return 'video/mp4';
      }
    }
    return null;
  }
}

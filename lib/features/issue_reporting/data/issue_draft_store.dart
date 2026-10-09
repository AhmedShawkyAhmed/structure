import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'issue_report.dart';

class IssueDraftStore {
  IssueDraftStore({Directory? directory}) : _root = directory;
  final Directory? _root;
  Future<void> _pending = Future<void>.value();

  Future<Directory> _directory() async {
    final root = _root ?? await getApplicationSupportDirectory();
    return Directory('${root.path}/issue_reporting').create(recursive: true);
  }

  Future<IssueReportState?> load() async {
    final directory = await _directory();
    final file = File('${directory.path}/draft.json');
    if (!await file.exists()) {
      return null;
    }
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    var draft = IssueReportState.fromDraftJson(json);
    if (json['hadDiagnostics'] == true) {
      draft = draft.copyWith(id: const Uuid().v4());
    }
    final available = <ReportAttachment>[];
    for (final item in draft.attachments) {
      if (await File(item.path).exists()) {
        available.add(item);
      }
    }
    return draft.copyWith(
      id: available.length == draft.attachments.length
          ? draft.id
          : const Uuid().v4(),
      attachments: available,
    );
  }

  Future<ReportAttachment> importFile(
    XFile file, {
    required AttachmentKind kind,
    required String mimeType,
  }) async {
    final directory = await _directory();
    final extension = kind == AttachmentKind.image
        ? (mimeType == 'image/png' ? 'png' : 'jpg')
        : (mimeType == 'video/quicktime' ? 'mov' : 'mp4');
    final name = '${kind.name}_${const Uuid().v4()}.$extension';
    final path = '${directory.path}/$name';
    await file.saveTo(path);
    return ReportAttachment(
      path: path,
      name: name,
      kind: kind,
      bytes: await File(path).length(),
      mimeType: mimeType,
    );
  }

  // Serialize writes so rapid typing cannot restore an older version.
  Future<void> save(IssueReportState state) {
    final result = _pending.then((_) async {
      final directory = await _directory();
      final temporary = File('${directory.path}/draft.tmp');
      await temporary.writeAsString(
        jsonEncode(state.toDraftJson()),
        flush: true,
      );
      await temporary.rename('${directory.path}/draft.json');
    });
    _pending = result.catchError((Object _) {});
    return result;
  }

  Future<void> removeAttachment(ReportAttachment item) async {
    final directory = await _directory();
    // Only delete files owned by the reporter, never gallery originals.
    if (File(item.path).parent.path != directory.path) {
      return;
    }
    final file = File(item.path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clear() async {
    await _pending;
    final directory = await _directory();
    await directory.delete(recursive: true);
  }
}

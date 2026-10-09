import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:structure/features/issue_reporting/data/issue_draft_store.dart';
import 'package:structure/features/issue_reporting/data/issue_report.dart';
import 'package:structure/features/issue_reporting/data/report_media_service.dart';

void main() {
  late Directory root;
  late IssueDraftStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('issue-draft-');
    store = IssueDraftStore(directory: root);
  });
  tearDown(() => root.delete(recursive: true));

  test(
    'saves latest draft, clears consent and excludes diagnostic values',
    () async {
      const first = IssueReportState(
        id: 'first',
        screen: '/twist',
        description: 'first',
      );
      final second = first.copyWith(
        description: 'latest',
        consent: true,
        diagnostics: {'deviceModel': 'private-model'},
      );
      await Future.wait([store.save(first), store.save(second)]);
      final saved = await store.load();
      expect(saved!.description, 'latest');
      expect(saved.consent, false);
      expect(saved.diagnostics, null);
      // Content differs without the previous diagnostic values, so retry ID rotates.
      expect(saved.id, isNot('first'));
      expect(
        await File('${root.path}/issue_reporting/draft.json').readAsString(),
        isNot(contains('private-model')),
      );
    },
  );

  test(
    'copies attachments, restores them and never deletes gallery originals',
    () async {
      final original = await File(
        '${root.path}/original.png',
      ).writeAsBytes([137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 0]);
      final media = ReportMediaService(store);
      final attachment = await media.prepare(XFile(original.path), []);
      expect(attachment.path, isNot(original.path));
      await store.save(
        IssueReportState(id: 'id', screen: '/home', attachments: [attachment]),
      );
      expect((await store.load())!.attachments.single.path, attachment.path);
      await store.clear();
      expect(await original.exists(), true);
      expect(await File(attachment.path).exists(), false);
    },
  );

  test(
    'validates screenshot bytes, attachment count, and media signatures',
    () async {
      final media = ReportMediaService(store);
      final screenshot = XFile.fromData(
        Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 0]),
        name: 'screen.png',
      );
      final attachment = await media.prepare(screenshot, []);
      expect(attachment.mimeType, 'image/png');
      await expectLater(
        media.prepare(screenshot, [attachment, attachment, attachment]),
        throwsA(
          isA<ReportException>().having(
            (e) => e.problem,
            'problem',
            ReportProblem.tooManyImages,
          ),
        ),
      );
      await expectLater(
        media.prepare(
          XFile.fromData(
            Uint8List.fromList(List.filled(20, 0)),
            name: 'fake.png',
          ),
          [],
        ),
        throwsA(
          isA<ReportException>().having(
            (e) => e.problem,
            'problem',
            ReportProblem.unsupportedMedia,
          ),
        ),
      );
      await expectLater(
        media.prepare(XFile.fromData(Uint8List(0), name: 'empty.png'), []),
        throwsA(
          isA<ReportException>().having(
            (e) => e.problem,
            'problem',
            ReportProblem.fileTooLarge,
          ),
        ),
      );
    },
  );

  test(
    'restores a draft without attachments whose files were removed',
    () async {
      const attachment = ReportAttachment(
        path: '/missing-screen.png',
        name: 'screen.png',
        kind: AttachmentKind.image,
        bytes: 42,
        mimeType: 'image/png',
      );
      await store.save(
        const IssueReportState(
          id: 'retry-id',
          screen: '/home',
          description: 'Unsaved issue',
          attachments: [attachment],
        ),
      );
      final restored = await store.load();
      expect(restored!.description, 'Unsaved issue');
      expect(restored.attachments, isEmpty);
    },
  );
}

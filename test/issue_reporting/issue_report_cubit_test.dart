import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:structure/features/issue_reporting/cubit/issue_report_cubit.dart';
import 'package:structure/features/issue_reporting/data/issue_draft_store.dart';
import 'package:structure/features/issue_reporting/data/issue_report.dart';
import 'package:structure/features/issue_reporting/data/issue_report_repository.dart';
import 'package:structure/features/issue_reporting/data/report_diagnostics_service.dart';
import 'package:structure/features/issue_reporting/data/report_media_service.dart';

class _Repository extends Mock implements IssueReportRepository {}

class _Store extends Mock implements IssueDraftStore {}

class _Media extends Mock implements ReportMediaService {}

class _Diagnostics extends Mock implements ReportDiagnosticsService {}

void main() {
  late _Repository repository;
  late _Store store;
  late _Diagnostics diagnostics;
  late IssueReportCubit cubit;

  setUpAll(() {
    registerFallbackValue(const IssueReportState(id: 'id', screen: '/home'));
    registerFallbackValue(CancelToken());
    registerFallbackValue((int sent, int total) {});
  });
  setUp(() {
    repository = _Repository();
    store = _Store();
    diagnostics = _Diagnostics();
    when(() => repository.configured).thenReturn(true);
    when(() => store.save(any())).thenAnswer((_) async {});
    when(() => store.clear()).thenAnswer((_) async {});
    cubit = IssueReportCubit(
      repository: repository,
      store: store,
      media: _Media(),
      diagnostics: diagnostics,
      screen: '/twist',
    );
  });
  tearDown(() => cubit.close());

  test('blocks submission without description and explicit consent', () async {
    await cubit.submit();
    expect(cubit.state.problem, ReportProblem.descriptionRequired);
    cubit.descriptionChanged('Music stops unexpectedly');
    await cubit.submit();
    expect(cubit.state.problem, ReportProblem.consentRequired);
    verifyNever(
      () => repository.submit(
        any(),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    );
  });

  test('content edits revoke consent and rotate the request ID', () {
    cubit.descriptionChanged('Broken');
    cubit.consentChanged(consent: true);
    final id = cubit.state.id;
    cubit.expectedChanged('Music should play');
    expect(cubit.state.consent, false);
    expect(cubit.state.id, isNot(id));
  });

  test(
    'technical details are collected only on opt-in and removed on opt-out',
    () async {
      verifyNever(() => diagnostics.collect());
      when(
        () => diagnostics.collect(),
      ).thenAnswer((_) async => {'appVersion': '1.0'});
      cubit.consentChanged(consent: true);
      await cubit.diagnosticsChanged(enabled: true);
      expect(cubit.state.diagnostics, {'appVersion': '1.0'});
      expect(cubit.state.consent, false);
      await cubit.diagnosticsChanged(enabled: false);
      expect(cubit.state.diagnostics, null);
      verify(() => diagnostics.collect()).called(1);
    },
  );

  test(
    'failed uploads keep draft and reuse ID; successful uploads clear it',
    () async {
      final ids = <String>[];
      when(
        () => repository.submit(
          any(),
          cancelToken: any(named: 'cancelToken'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((invocation) async {
        ids.add((invocation.positionalArguments.single as IssueReportState).id);
        if (ids.length == 1) {
          throw const ReportException(ReportProblem.uploadFailed);
        }
        return 'REPORT-42';
      });
      cubit.descriptionChanged('Music stops');
      cubit.consentChanged(consent: true);
      await cubit.submit();
      expect(cubit.state.status, ReportStatus.failed);
      expect(cubit.state.description, 'Music stops');
      verifyNever(() => store.clear());
      await cubit.submit();
      expect(ids[0], ids[1]);
      expect(cubit.state.status, ReportStatus.sent);
      expect(cubit.state.reference, 'REPORT-42');
      verify(() => store.clear()).called(1);
    },
  );

  test('prevents duplicate sends and content changes during upload', () async {
    final pending = Completer<String>();
    when(
      () => repository.submit(
        any(),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) => pending.future);
    cubit.descriptionChanged('Music stops');
    cubit.consentChanged(consent: true);
    final sending = cubit.submit();
    await pumpEventQueue();
    await cubit.submit();
    cubit.descriptionChanged('Changed');
    cubit.consentChanged(consent: false);
    expect(cubit.state.description, 'Music stops');
    expect(cubit.state.consent, true);
    verify(
      () => repository.submit(
        any(),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).called(1);
    pending.complete('REPORT-42');
    await sending;
  });

  test('cancels upload without clearing the draft', () async {
    when(
      () => repository.submit(
        any(),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((invocation) async {
      final token = invocation.namedArguments[#cancelToken] as CancelToken;
      await token.whenCancel;
      throw const ReportException(ReportProblem.cancelled);
    });
    cubit.descriptionChanged('Music stops');
    cubit.consentChanged(consent: true);
    final sending = cubit.submit();
    await pumpEventQueue();
    cubit.cancelUpload();
    await sending;
    expect(cubit.state.status, ReportStatus.editing);
    expect(cubit.state.problem, ReportProblem.cancelled);
    verifyNever(() => store.clear());
  });

  test('discarding and closing cannot recreate the deleted draft', () async {
    cubit.descriptionChanged('Discard this report');
    await cubit.discard();
    await cubit.close();
    expect(cubit.state.description, isEmpty);
    verify(() => store.clear()).called(1);
    verifyNever(() => store.save(any()));
  });
}

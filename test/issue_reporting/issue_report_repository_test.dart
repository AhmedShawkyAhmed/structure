import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:structure/features/issue_reporting/data/issue_report.dart';
import 'package:structure/features/issue_reporting/data/issue_report_repository.dart';
import 'package:structure/features/issue_reporting/data/simulated_issue_report_adapter.dart';

void main() {
  test(
    'simulation logs actual JSON and streams media without a backend',
    () async {
      final messages = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        messages.add(message);
      }
      };
      addTearDown(() => debugPrint = originalDebugPrint);
      final directory = await Directory.systemTemp.createTemp(
        'issue-simulation-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = await File('${directory.path}/image.png')
          .writeAsBytes([137, 80, 78, 71]);
      final client = Dio()
        ..httpClientAdapter = SimulatedIssueReportAdapter(
          responseDelay: Duration.zero,
        );
      addTearDown(() => client.close(force: true));
      final repository = HttpIssueReportRepository(
        client: client,
        endpoint: 'https://issue-report.invalid/reports',
        simulated: true,
      );
      final report = IssueReportState(
        id: 'same-id',
        screen: '/twist',
        description: '  Playback stops  ',
        expected: '  Keep playing  ',
        consent: true,
        diagnostics: const {'platform': 'ios', 'appVersion': '1.0.0'},
        attachments: [
          ReportAttachment(
            path: file.path,
            name: 'image.png',
            kind: AttachmentKind.image,
            bytes: 4,
            mimeType: 'image/png',
          ),
        ],
      );
      var uploaded = 0;
      var total = 0;
      Future<String> send() => repository.submit(
        report,
        cancelToken: CancelToken(),
        onProgress: (sent, length) {
          uploaded = sent;
          total = length;
        },
      );
      expect(repository.simulated, true);
      expect(await send(), 'SIMULATED-same-id');
      expect(uploaded, total);
      expect(total, greaterThan(file.lengthSync()));
      final payload = jsonDecode(messages[1]) as Map<String, dynamic>;
      expect(payload['description'], 'Playback stops');
      expect(payload['expectedBehavior'], 'Keep playing');
      expect(payload['consent']['includeDiagnostics'], true);
      expect(payload['diagnostics'], report.diagnostics);
      expect(payload['attachments'][0]['name'], 'image.png');
      expect(messages.join('\n'), isNot(contains(file.path)));
      expect(messages[2], contains('SIMULATED response 201'));
      expect(jsonDecode(messages[3]), {'reference': 'SIMULATED-same-id'});
      expect(await send(), 'SIMULATED-same-id');
      messages.clear();
      await expectLater(
        repository.submit(
          report.copyWith(consent: false),
          cancelToken: CancelToken(),
          onProgress: (_, _) {},
        ),
        throwsA(isA<ReportException>()),
      );
      expect(messages, isEmpty);
    },
  );

  test('simulation cancellation never produces a successful receipt', () async {
    final client = Dio()..httpClientAdapter = SimulatedIssueReportAdapter();
    addTearDown(() => client.close(force: true));
    final repository = HttpIssueReportRepository(
      client: client,
      endpoint: 'https://issue-report.invalid/reports',
      simulated: true,
    );
    final token = CancelToken();
    final sending = repository.submit(
      const IssueReportState(
        id: 'cancel-id',
        screen: '/home',
        description: 'Broken',
        consent: true,
      ),
      cancelToken: token,
      onProgress: (_, _) {},
    );
    final expectation = expectLater(
      sending,
      throwsA(
        isA<ReportException>().having(
          (error) => error.problem,
          'problem',
          ReportProblem.cancelled,
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    token.cancel();
    await expectation;
  });

  test('never makes a request without consent or a description', () async {
    final client = Dio();
    var requests = 0;
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests++;
          handler.resolve(
            Response(requestOptions: options, data: {'reference': 'R1'}),
          );
        },
      ),
    );
    final repository = HttpIssueReportRepository(
      client: client,
      endpoint: 'https://support.example/reports',
    );
    Future<String> send(IssueReportState report) => repository.submit(
      report,
      cancelToken: CancelToken(),
      onProgress: (_, _) {},
    );
    await expectLater(
      send(
        const IssueReportState(
          id: 'id',
          screen: '/twist',
          description: 'Broken',
        ),
      ),
      throwsA(
        isA<ReportException>().having(
          (e) => e.problem,
          'problem',
          ReportProblem.consentRequired,
        ),
      ),
    );
    await expectLater(
      send(const IssueReportState(id: 'id', screen: '/twist', consent: true)),
      throwsA(
        isA<ReportException>().having(
          (e) => e.problem,
          'problem',
          ReportProblem.descriptionRequired,
        ),
      ),
    );
    expect(requests, 0);
  });

  test('builds multipart media with consent and a stable retry ID', () async {
    final directory = await Directory.systemTemp.createTemp(
      'issue-repository-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = await File('${directory.path}/screen.png')
        .writeAsBytes([137, 80, 78, 71]);
    final client = Dio();
    late RequestOptions request;
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 201,
              data: {'reference': 'REPORT-42'},
            ),
          );
        },
      ),
    );
    final repository = HttpIssueReportRepository(
      client: client,
      endpoint: 'https://support.example/reports',
    );
    final report = IssueReportState(
      id: 'stable-id',
      screen: '/twist',
      description: '  Playback stops  ',
      consent: true,
      attachments: [
        ReportAttachment(
          path: file.path,
          name: 'screen.png',
          kind: AttachmentKind.image,
          bytes: 4,
          mimeType: 'image/png',
        ),
      ],
    );
    expect(
      await repository.submit(
        report,
        cancelToken: CancelToken(),
        onProgress: (_, _) {},
      ),
      'REPORT-42',
    );
    expect(request.headers['Idempotency-Key'], 'stable-id');
    expect(request.headers.containsKey('X-Device-Id'), false);
    final form = request.data as FormData;
    final payload =
        jsonDecode(form.fields.single.value) as Map<String, dynamic>;
    expect(payload['description'], 'Playback stops');
    expect(payload['screen'], '/twist');
    expect(payload['consent']['shareReport'], true);
    expect(payload['consent']['includeDiagnostics'], false);
    expect(payload.containsKey('diagnostics'), false);
    expect(form.files.single.key, 'attachments');
    expect(form.files.single.value.contentType.toString(), 'image/png');
  });

  test(
    'requires a confirmed reference and refuses unconfigured endpoints',
    () async {
      final client = Dio();
      client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'ok': true},
              ),
            );
          },
        ),
      );
      const report = IssueReportState(
        id: 'id',
        screen: '/home',
        description: 'Broken',
        consent: true,
      );
      final repository = HttpIssueReportRepository(
        client: client,
        endpoint: 'https://support.example/reports',
      );
      await expectLater(
        repository.submit(
          report,
          cancelToken: CancelToken(),
          onProgress: (_, _) {},
        ),
        throwsA(
          isA<ReportException>().having(
            (e) => e.problem,
            'problem',
            ReportProblem.invalidResponse,
          ),
        ),
      );
      for (final endpoint in [
        '',
        'http://support.example/reports',
        'not-a-url',
      ]) {
        final unconfigured = HttpIssueReportRepository(
          client: client,
          endpoint: endpoint,
        );
        expect(unconfigured.configured, false);
        await expectLater(
          unconfigured.submit(
            report,
            cancelToken: CancelToken(),
            onProgress: (_, _) {},
          ),
          throwsA(
            isA<ReportException>().having(
              (e) => e.problem,
              'problem',
              ReportProblem.notConfigured,
            ),
          ),
        );
      }
    },
  );
}

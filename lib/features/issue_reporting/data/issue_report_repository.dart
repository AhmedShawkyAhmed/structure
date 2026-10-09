import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import 'issue_report.dart';

abstract interface class IssueReportRepository {
  bool get configured;
  bool get simulated;

  Future<String> submit(
    IssueReportState report, {
    required CancelToken cancelToken,
    required void Function(int sent, int total) onProgress,
  });
}

class HttpIssueReportRepository implements IssueReportRepository {
  HttpIssueReportRepository({
    required this._client,
    required this._endpoint,
    bool simulated = false,
  }) : simulated = kDebugMode && simulated;

  final Dio _client;
  final String _endpoint;

  @override
  final bool simulated;

  @override
  bool get configured {
    final uri = Uri.tryParse(_endpoint);
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }

  @override
  Future<String> submit(
    IssueReportState report, {
    required CancelToken cancelToken,
    required void Function(int sent, int total) onProgress,
  }) async {
    // Enforce consent here as well as in the form, before reading any media.
    if (!report.consent) {
      throw const ReportException(ReportProblem.consentRequired);
    }
    if (report.description.trim().isEmpty) {
      throw const ReportException(ReportProblem.descriptionRequired);
    }
    if (!configured) {
      throw const ReportException(ReportProblem.notConfigured);
    }

    try {
      final payload = {
        'clientReportId': report.id,
        'description': report.description.trim(),
        'expectedBehavior': report.expected.trim(),
        'screen': report.screen,
        'consent': {
          'shareReport': true,
          'includeDiagnostics': report.diagnostics != null,
          'version': 1,
          'confirmedAt': DateTime.now().toUtc().toIso8601String(),
        },
        if (report.diagnostics != null) 'diagnostics': report.diagnostics,
        'attachments': report.attachments
            .map(
              (item) => {
                'name': item.name,
                'kind': item.kind.name,
                'mimeType': item.mimeType,
                'bytes': item.bytes,
              },
            )
            .toList(),
      };
      if (kDebugMode) {
        debugPrint(
          '[Issue report] ${simulated ? 'SIMULATED' : 'HTTP'} request JSON',
        );
        debugPrint(const JsonEncoder.withIndent('  ').convert(payload));
      }
      final form = FormData.fromMap({'report': jsonEncode(payload)});
      for (final item in report.attachments) {
        form.files.add(
          MapEntry(
            'attachments',
            await MultipartFile.fromFile(
              item.path,
              filename: item.name,
              contentType: MediaType.parse(item.mimeType),
            ),
          ),
        );
      }
      final response = await _client.post<dynamic>(
        _endpoint,
        data: form,
        cancelToken: cancelToken,
        onSendProgress: onProgress,
        options: Options(headers: {'Idempotency-Key': report.id}),
      );
      final body = response.data;
      if (kDebugMode) {
        debugPrint(
          '[Issue report] ${simulated ? 'SIMULATED' : 'HTTP'} response ${response.statusCode}',
        );
        debugPrint(const JsonEncoder.withIndent('  ').convert(body));
      }
      if (body is! Map<String, dynamic> ||
          body['reference'] is! String ||
          (body['reference'] as String).trim().isEmpty) {
        throw const ReportException(ReportProblem.invalidResponse);
      }
      return body['reference'] as String;
    } on DioException catch (error) {
      throw ReportException(
        CancelToken.isCancel(error)
            ? ReportProblem.cancelled
            : ReportProblem.uploadFailed,
      );
    } on ReportException {
      rethrow;
    } on Object {
      throw const ReportException(ReportProblem.uploadFailed);
    }
  }
}

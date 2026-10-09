import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Exercises Dio's multipart upload locally without opening a network connection.
class SimulatedIssueReportAdapter implements HttpClientAdapter {
  SimulatedIssueReportAdapter({
    this.responseDelay = const Duration(seconds: 1),
  }) {
    if (!kDebugMode) {
      throw UnsupportedError(
        'Issue report simulation is only available in debug.',
      );
    }
  }

  final Duration responseDelay;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Future<ResponseBody> respond() async {
      // Consume the actual media stream so missing files and upload progress
      // behave just as they do with the real transport.
      await requestStream?.drain<void>();
      await Future<void>.delayed(responseDelay);
      return ResponseBody.fromString(
        jsonEncode({
          'reference': 'SIMULATED-${options.headers['Idempotency-Key']}',
        }),
        201,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    return Future.any([
      respond(),
      if (cancelFuture != null)
        cancelFuture.then<ResponseBody>(
          (_) => throw DioException.requestCancelled(
            requestOptions: options,
            reason: 'Simulated submission cancelled',
          ),
        ),
    ]);
  }

  @override
  void close({bool force = false}) {}
}

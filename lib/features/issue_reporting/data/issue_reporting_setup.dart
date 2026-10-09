import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:navigation_service/navigation_service.dart';

import '../../../core/globals/globals.dart';
import 'issue_draft_store.dart';
import 'issue_report_repository.dart';
import 'issue_reporting_controller.dart';
import 'simulated_issue_report_adapter.dart';

Future<void> initializeIssueReporting(GetIt locator) async {
  const endpoint = String.fromEnvironment('ISSUE_REPORT_ENDPOINT');
  const simulationRequested = bool.fromEnvironment(
    'ISSUE_REPORT_SIMULATE',
    defaultValue: endpoint == '',
  );
  const simulated = kDebugMode && simulationRequested;
  // Reports use a dedicated client without authentication/device ID logging.
  final client = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(minutes: 3),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
  if (simulated) {
    client.httpClientAdapter = SimulatedIssueReportAdapter();
  }
  client.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = Globals.token;
        if (!simulated && token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );
  locator.registerLazySingleton<IssueReportRepository>(
    () => HttpIssueReportRepository(
      client: client,
      endpoint: simulated ? 'https://issue-report.invalid/reports' : endpoint,
      simulated: simulated,
    ),
  );
  locator.registerLazySingleton<IssueDraftStore>(() => IssueDraftStore());
  final controller = IssueReportingController(
    navigatorKey: NavigationService.navigatorKey,
  );
  locator.registerSingleton<IssueReportingController>(controller);
  await controller.initialize();
}

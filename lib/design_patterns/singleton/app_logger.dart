import 'package:core_utils/core_utils.dart';
// Singleton for Logging Across App

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  AppLogger._internal();

  factory AppLogger() => _instance;

  void debug(String message) => AppLogs.debugLog('[DEBUG] $message');

  void error(String message) => AppLogs.debugLog('[ERROR] $message');
}

void main() {
  final logger = AppLogger();
  logger.debug('App started');
  logger.error('Something went wrong');
}

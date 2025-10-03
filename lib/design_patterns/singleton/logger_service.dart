import 'package:core_utils/core_utils.dart';

// Classic Singleton (Private Constructor)

class LoggerService {
  // Private constructor
  LoggerService._internal();

  // The single instance
  static final LoggerService _instance = LoggerService._internal();

  // Getter for the instance
  static LoggerService get instance => _instance;

  void log(String message) {
    AppLogs.debugLog('[LOG]: $message');
  }
}

void main() {
  LoggerService.instance.log('App started');
  LoggerService.instance.log('User logged in');
}

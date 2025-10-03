import 'package:core_utils/core_utils.dart';
import 'package:structure/mutable_inheritance/interface/i_logger.dart';
import 'package:structure/mutable_inheritance/interface/logger_interface.dart';

class ConsoleLogger implements LoggerInterface,ILogger {
  @override
  void log(String message) {
    AppLogs.debugLog(message);
  }

  @override
  void error(String message) {
    AppLogs.errorLog(message);
  }

  @override
  void warning(String message) {
    AppLogs.responseLog(message);
  }
}
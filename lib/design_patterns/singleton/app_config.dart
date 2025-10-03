// Singleton for Configurations (Environment Variables)
import 'package:core_utils/core_utils.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  late String baseUrl;
  late String apiKey;

  AppConfig._internal();

  factory AppConfig({String? baseUrl, String? apiKey}) {
    _instance.baseUrl = baseUrl ?? 'https://default-api.com';
    _instance.apiKey = apiKey ?? '123456';
    return _instance;
  }
}

void main() {
  final config = AppConfig(baseUrl: 'https://myapi.com', apiKey: 'abcd');
  AppLogs.debugLog(config.baseUrl); // https://myapi.com

  final config2 = AppConfig();
  AppLogs.debugLog(
    config2.baseUrl,
  ); // still https://myapi.com ✅ (same instance)
}

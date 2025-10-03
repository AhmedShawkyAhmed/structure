import 'package:core_utils/core_utils.dart';
import 'package:network_service/network_service.dart';

// Singleton with Dependency (e.g., using DioFactory)

class DioProvider {
  DioProvider._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    return _instance!;
  }

  // optional: replace for tests
  static Dio setInstance(Dio dio) => _instance = dio;
}

void main() {
  final client1 = DioFactory.dio;
  final client2 = DioFactory.dio;

  AppLogs.debugLog(client1 == client2); // true ✅
}

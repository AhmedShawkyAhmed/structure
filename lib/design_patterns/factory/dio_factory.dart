import 'package:network_service/network_service.dart';
// Factory with Dio (Matches Your Service Layer)

class DioFactory {
  static final DioFactory _instance = DioFactory._internal();
  factory DioFactory() => _instance;

  DioFactory._internal();

  Dio createDio({String? token}) {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    return dio;
  }
}



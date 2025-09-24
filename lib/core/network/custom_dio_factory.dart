import 'package:core_utils/core_utils.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/core/network/api_routes.dart';

class CustomDioFactory extends DioFactory {
  static final CustomDioFactory _instance = CustomDioFactory._internal(
    baseUrl: APIRoutes.baseUrl,
  );

  CustomDioFactory._internal({required super.baseUrl});

  factory CustomDioFactory() => _instance;

  static Dio get dio => DioFactory.dio;

  static Future<void> initialize() async {
    Dio dioInstance;

    // if (false) {
    // dioInstance = await _createSecuredDio();
    // } else {
    dioInstance = _createUnsecuredDio();
    // }

    DioFactory.setDio(dioInstance);
    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogs.debugLog('API Path => ${options.path}');
          options.headers['Authorization'] = 'Bearer Token';
          handler.next(options);
        },
        onError: (error, handler) {
          AppLogs.errorLog(error);
          handler.next(error);
        },
      ),
    );
  }

  static Dio _createUnsecuredDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: APIRoutes.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 180),
        sendTimeout: const Duration(seconds: 100),
      ),
    );

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    return dio;
  }

  // static Future<Dio> _createSecuredDio() async {
  //   final dio = Dio(BaseOptions(
  //     baseUrl: APIRoutes.baseUrl,
  //     receiveDataWhenStatusError: true,
  //     connectTimeout: const Duration(seconds: 180),
  //     sendTimeout: const Duration(seconds: 100),
  //   ));
  //
  //   final context = SecurityContext(withTrustedRoots: false);
  //   final cert = await rootBundle.load('assets/certificates/my_cert.pem');
  //   context.setTrustedCertificatesBytes(cert.buffer.asUint8List());
  //
  //   final adapter = IOHttpClientAdapter();
  //   adapter.createHttpClient = () {
  //     final client = HttpClient(context: context);
  //     client.badCertificateCallback = (cert, host, port) {
  //       return true;
  //     };
  //     return client;
  //   };
  //
  //   dio.httpClientAdapter = adapter;
  //
  //   dio.interceptors.add(LogInterceptor(
  //     requestBody: true,
  //     responseBody: true,
  //     error: true,
  //   ));
  //
  //   return dio;
  // }
}

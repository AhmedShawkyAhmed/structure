import 'dart:io';

import 'package:core_utils/core_utils.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:network_service/network_service.dart';
import 'package:structure/core/globals/globals.dart';

/// Concrete implementation of DioFactory that creates
/// secured or unsecured Dio depending on environment.
class CustomDioFactory implements DioFactory {
  final Environment environment;
  final String baseUrl;

  CustomDioFactory({
    required this.environment,
    required this.baseUrl,
  });

  @override
  Future<Dio> createDio() async {
    final dio = environment == Environment.production
        ? await _createSecuredDio()
        : _createUnsecuredDio();

    // Common interceptors for all environments
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogs.debugLog('API Path => ${options.path}');
          if (Globals.token != null) {
            options.headers['Authorization'] = 'Bearer ${Globals.token}';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          AppLogs.errorLog(error);
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  Dio _createUnsecuredDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
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

  Future<Dio> _createSecuredDio() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 180),
        sendTimeout: const Duration(seconds: 100),
      ),
    );

    // SSL Pinning
    final context = SecurityContext(withTrustedRoots: false);
    final cert = await rootBundle.load('assets/certificates/my_cert.pem');
    context.setTrustedCertificatesBytes(cert.buffer.asUint8List());

    final adapter = IOHttpClientAdapter();
    adapter.createHttpClient = () {
      final client = HttpClient(context: context);
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    dio.httpClientAdapter = adapter;

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    return dio;
  }

  @override
  // TODO: implement headers
  Map<String, String>? get headers => throw UnimplementedError();
}

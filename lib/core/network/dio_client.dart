import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../auth/auth_token_storage.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient(AuthTokenStorage tokenStorage) : _dio = _build(tokenStorage);

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _build(AuthTokenStorage tokenStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage),
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    ]);

    return dio;
  }
}

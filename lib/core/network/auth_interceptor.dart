import 'package:dio/dio.dart';

import '../auth/auth_token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final AuthTokenStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final cached = _storage.cachedToken ?? await _storage.read();
    if (cached != null && cached.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $cached';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _storage.clear();
    }
    handler.next(err);
  }
}

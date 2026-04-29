import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_token_storage.dart';
import '../network/dio_client.dart';
import '../network/sse_client.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage secureStorage() => const FlutterSecureStorage();

  @lazySingleton
  Dio dio(AuthTokenStorage tokenStorage) => DioClient(tokenStorage).dio;

  @lazySingleton
  SseClient sseClient(AuthTokenStorage tokenStorage) =>
      SseClient(tokenStorage);

  @lazySingleton
  ImagePicker imagePicker() => ImagePicker();

  @preResolve
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();
}

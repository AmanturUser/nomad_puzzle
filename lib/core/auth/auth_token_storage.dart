import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthTokenStorage {
  AuthTokenStorage(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'tknr_auth_token';

  String? _cachedToken;

  String? get cachedToken => _cachedToken;

  Future<String?> read() async {
    _cachedToken ??= await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  Future<void> write(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> clear() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveSessionToken(String token) async {
    await _storage.write(key: 'session_token', value: token);
  }

  static Future<String?> getSessionToken() async {
    return await _storage.read(key: 'session_token');
  }

  static Future<void> deleteSessionToken() async {
    await _storage.delete(key: 'session_token');
  }

  static Future<void> saveUserCredentials(String email, String password) async {
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_password', value: password);
  }

  static Future<Map<String, String?>> getUserCredentials() async {
    final email = await _storage.read(key: 'user_email');
    final password = await _storage.read(key: 'user_password');
    return {'email': email, 'password': password};
  }

  static Future<void> deleteUserCredentials() async {
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_password');
  }
}

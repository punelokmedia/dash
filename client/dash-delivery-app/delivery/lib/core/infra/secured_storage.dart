import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    // ignore: deprecated_member_use
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _accessTokenKey   = 'accessToken';
  static const _isRegisteredKey  = 'is_registered'; // ✅ new key

  // ── Token ────────────────────────────────────────────────────────
  static Future<void> saveToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  static Future<String?> getToken() =>
      _storage.read(key: _accessTokenKey);

  static Future<void> deleteToken() =>
      _storage.delete(key: _accessTokenKey);

  // ── Registration flag ────────────────────────────────────────────
  static Future<void> setRegistered() =>           // ✅ call once after OTP verified
      _storage.write(key: _isRegisteredKey, value: 'true');

  static Future<bool> isRegistered() async {       // ✅ survives token expiry/logout
    final val = await _storage.read(key: _isRegisteredKey);
    return val == 'true';
  }

  // ── Clear ────────────────────────────────────────────────────────
  static Future<void> clearAll() => _storage.deleteAll(); // ⚠️ clears flag too — only use on account delete
}
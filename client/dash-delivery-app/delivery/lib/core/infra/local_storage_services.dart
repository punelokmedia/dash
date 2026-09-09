// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorageService {
//   static late final SharedPreferences _preferences;
//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   /// Storage keys
//   static const _themeModeKey = 'themeMode';
//   static const _userIdKey = 'userId';
//   static const _userKey = 'userKey';
//   static const _userData = 'userData';
//   // static const _pendingReferralCode = 'pendingReferralCode';
//   // static const _streakCountKey = 'streakCount';
//   static const _lastOpenDateKey = 'lastOpenDate';

//   static String _keyForUser(String baseKey, String uid) {
//     final trimmed = uid.trim();
//     if (trimmed.isEmpty) return baseKey;
//     return '${baseKey}_$trimmed';
//   }

//   static DateTime _dateOnly(DateTime dateTime) {
//     return DateTime(dateTime.year, dateTime.month, dateTime.day);
//   }

//   static String _formatDate(DateTime date) {
//     final year = date.year.toString().padLeft(4, '0');
//     final month = date.month.toString().padLeft(2, '0');
//     final day = date.day.toString().padLeft(2, '0');
//     return '$year-$month-$day';
//   }

//   static DateTime? _tryParseStoredDate(String value) {
//     if (value.trim().isEmpty) return null;
//     final parts = value.split('-');
//     if (parts.length != 3) return null;
//     final year = int.tryParse(parts[0]);
//     final month = int.tryParse(parts[1]);
//     final day = int.tryParse(parts[2]);
//     if (year == null || month == null || day == null) return null;
//     if (month < 1 || month > 12) return null;
//     if (day < 1 || day > 31) return null;
//     return DateTime(year, month, day);
//   }

//   //!Theme Mode
//   static String get themeModeKey =>
//       _preferences.getString(_themeModeKey) ?? 'light';
//   static set setThemeModeKey(String value) =>
//       _preferences.setString(_themeModeKey, value);

//   //!User Id
//   static String get userId => _preferences.getString(_userIdKey) ?? '';
//   static set setUserIdKey(String value) =>
//       _preferences.setString(_userIdKey, value);

//   //!User Key
//   static String get userKey => _preferences.getString(_userKey) ?? '';
//   static set setUserKey(String value) =>
//       _preferences.setString(_userKey, value);
//   //!User Data
//   static String get userData => _preferences.getString(_userData) ?? '';
//   static set setUserData(String value) =>
//       _preferences.setString(_userData, value);

//   //! Daily Streak (consecutive days app opened)
//   // static int get streakCount {
//   //   final key = _keyForUser(_streakCountKey, userId);
//   //   return _preferences.getInt(key) ?? 1;
//   // }

//   // static set setStreakCount(int value) {
//   //   final safeValue = value < 1 ? 1 : value;
//   //   final key = _keyForUser(_streakCountKey, userId);
//   //   _preferences.setInt(key, safeValue);
//   // }

//   static String get lastOpenDate {
//     final key = _keyForUser(_lastOpenDateKey, userId);
//     return _preferences.getString(key) ?? '';
//   }

//   static set setLastOpenDate(String value) {
//     final key = _keyForUser(_lastOpenDateKey, userId);
//     _preferences.setString(key, value);
//   }

//   /// Call once on app launch.
//   ///
//   /// Rules:
//   /// - Same day: do nothing.
//   /// - Next day: streak + 1.
//   // /// - >1 day gap (or missing/invalid date): reset to 1.
//   // static Future<void> updateDailyStreakOnLaunch({DateTime? now}) async {
//   //   final today = _dateOnly(now ?? DateTime.now());
//   //   final stored = _tryParseStoredDate(lastOpenDate);
//   //   final last = stored == null ? null : _dateOnly(stored);

//   //   if (last == null) {
//   //     setStreakCount = 1;
//   //     setLastOpenDate = _formatDate(today);
//   //     return;
//   //   }

//   //   final dayDiff = today.difference(last).inDays;

//   //   if (dayDiff == 0) {
//   //     return;
//   //   }

//   //   if (dayDiff == 1) {
//   //     setStreakCount = streakCount + 1;
//   //     setLastOpenDate = _formatDate(today);
//   //     return;
//   //   }

//   //   if (dayDiff > 1) {
//   //     setStreakCount = 1;
//   //     setLastOpenDate = _formatDate(today);
//   //     return;
//   //   }

//   //   // Device clock moved backwards (or other anomaly). Keep streak unchanged,
//   //   // but normalize lastOpenDate to today.
//   //   setLastOpenDate = _formatDate(today);
//   // }

//   // //!Pending Referral Code
//   // static String get pendingReferralCode =>
//   //     _preferences.getString(_pendingReferralCode) ?? '';
//   // static set setPendingReferralCode(String value) =>
//   //     _preferences.setString(_pendingReferralCode, value);
//   // static Future<void> clearPendingReferralCode() =>
//   //     _preferences.remove(_pendingReferralCode);

//   // //! Logout
//   // static Future<bool> logout() {
//   //   _preferences.setString(_userIdKey, '');
//   //   _preferences.setString(_userKey, '');
//   //   return Future.value(true);
//   // }

//   // // Delete All
//   // static Future<bool> deleteAll() {
//   //   _preferences.clear();
//   //   return Future.value(true);
//   // }
// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static const _storage = FlutterSecureStorage(
    // ignore: deprecated_member_use
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Storage keys
  static const _themeModeKey = 'themeMode';
  static const _userIdKey = 'userId';
  static const _userKey = 'userKey';
  static const _userData = 'userData';

  static const _lastOpenDateKey = 'lastOpenDate';

  static Future<String> _keyForUser(String baseKey) async {
    final uid = await userId;
    final trimmed = uid.trim();
    if (trimmed.isEmpty) return baseKey;
    return '${baseKey}_$trimmed';
  }

  static DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static DateTime? _tryParseStoredDate(String value) {
    if (value.trim().isEmpty) return null;
    final parts = value.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;
    return DateTime(year, month, day);
  }

  //! Theme Mode
  static Future<String> get themeModeKey async =>
      await _storage.read(key: _themeModeKey) ?? 'light';
  static Future<void> setThemeModeKey(String value) =>
      _storage.write(key: _themeModeKey, value: value);

  //! User Id
  static Future<String> get userId async =>
      await _storage.read(key: _userIdKey) ?? '';
  static Future<void> setUserId(String value) =>
      _storage.write(key: _userIdKey, value: value);

  //! User Key
  static Future<String> get userKey async =>
      await _storage.read(key: _userKey) ?? '';
  static Future<void> setUserKey(String value) =>
      _storage.write(key: _userKey, value: value);

  //! User Data
  static Future<String> get userData async =>
      await _storage.read(key: _userData) ?? '';
  static Future<void> setUserData(String value) =>
      _storage.write(key: _userData, value: value);

  //! Daily Streak

  static Future<String> get lastOpenDate async {
    final key = await _keyForUser(_lastOpenDateKey);
    return await _storage.read(key: key) ?? '';
  }

  static Future<void> setLastOpenDate(String value) async {
    final key = await _keyForUser(_lastOpenDateKey);
    await _storage.write(key: key, value: value);
  }

  /// Call once on app launch.

  //! Logout
  static Future<bool> logout() async {
    await _storage.write(key: _userIdKey, value: '');
    await _storage.write(key: _userKey, value: '');
    return true;
  }

  //! Delete All
  static Future<bool> deleteAll() async {
    await _storage.deleteAll();
    return true;
  }
}

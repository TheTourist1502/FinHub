import 'dart:convert';

import 'package:finhub/core/config/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Unified persistence: [SharedPreferences] for ordinary values,
/// [FlutterSecureStorage] for anything credential-shaped.
///
/// Which store a key lands in is decided by the method the caller reaches for,
/// never by the call site branching on the key: `setSecure`/`getSecure` for
/// credentials and PII, `setData`/`getData` for the rest. The key names
/// themselves all live in [StorageKeys].
class StorageService {
  /// Creates a service over the two backing stores.
  const StorageService(this._prefs, this._secure);

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secure;

  /// Keys that survive [clearSession].
  ///
  /// A key belongs here only if it describes the *device* or a UI preference
  /// the next user of this device should still get — never anything naming a
  /// user. Everything else is session data and is wiped on sign-out.
  static const Set<String> _sessionExemptKeys = {StorageKeys.locale, StorageKeys.deviceId};

  /// Reads a plain (non-credential) value.
  Future<String?> getData(String key) async => _prefs.getString(key);

  /// Writes a plain (non-credential) value.
  Future<void> setData(String key, String value) => _prefs.setString(key, value);

  /// Reads a JSON object previously written with [setJson].
  Future<Map<String, dynamic>?> getJson(String key, {bool secure = false}) async {
    final raw = secure ? await _secure.read(key: key) : _prefs.getString(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  /// Writes a JSON object, to the secure store when [secure] is set.
  Future<void> setJson(String key, Map<String, dynamic> value, {bool secure = false}) {
    final raw = jsonEncode(value);
    return secure ? _secure.write(key: key, value: raw) : _prefs.setString(key, raw);
  }

  /// Reads a credential from the platform keystore.
  Future<String?> getSecure(String key) => _secure.read(key: key);

  /// Writes a credential to the platform keystore.
  Future<void> setSecure(String key, String value) => _secure.write(key: key, value: value);

  /// Removes a single key from both stores.
  Future<void> remove(String key) async {
    await _prefs.remove(key);
    await _secure.delete(key: key);
  }

  /// Wipes everything the session owns, keeping only [_sessionExemptKeys].
  ///
  /// The keep-list is the exception rather than a wipe-list, so a key added by
  /// a future feature and forgotten here can only be lost on sign-out — never
  /// leaked to the next user.
  Future<void> clearSession() async {
    final keep = {for (final key in _sessionExemptKeys) key: _prefs.getString(key)};
    await _prefs.clear();
    for (final entry in keep.entries) {
      if (entry.value != null) await _prefs.setString(entry.key, entry.value!);
    }
    // The secure store holds only credentials and PII; nothing in it outlives
    // a session, so it goes wholesale.
    await _secure.deleteAll();
  }
}

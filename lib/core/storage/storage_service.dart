import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Every key the app persists. Declared in one place so
/// [StorageService.clearSession] can wipe the session without an enumerated
/// list at each call site.
abstract final class StorageKeys {
  /// The session token minted by `MockAuthService`. Secure-store only.
  static const String authToken = 'auth_token';

  /// JSON snapshot of the signed-in [User], so a cold start can restore the
  /// session without re-decoding anything but the token's expiry.
  static const String cachedUser = 'cached_user';
}

/// Unified persistence: [SharedPreferences] for ordinary values,
/// [FlutterSecureStorage] for anything credential-shaped.
///
/// Which store a key lands in is decided here, never at the call site —
/// `setSecure`/`getSecure` for credentials, `setString`/`getString` for the
/// rest.
class StorageService {
  /// Creates a service over the two backing stores.
  const StorageService(this._prefs, this._secure);

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secure;

  /// Keys that survive [clearSession].
  ///
  /// Everything else is session data and is wiped on sign-out. A key belongs
  /// here only if it describes the *device* or a UI preference the next user
  /// of this device should still get — never anything naming a user.
  static const Set<String> _sessionExemptKeys = <String>{};

  /// Reads a plain (non-credential) value.
  String? getString(String key) => _prefs.getString(key);

  /// Writes a plain (non-credential) value.
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  /// Reads a JSON object previously written with [setJson].
  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Writes a JSON object.
  Future<void> setJson(String key, Map<String, dynamic> value) => _prefs.setString(key, jsonEncode(value));

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
  /// The keep-list is the exception; forgetting to add a new key here can only
  /// ever lose data, never leak the previous user's.
  Future<void> clearSession() async {
    final keep = {for (final k in _sessionExemptKeys) k: _prefs.getString(k)};
    await _prefs.clear();
    for (final entry in keep.entries) {
      if (entry.value != null) await _prefs.setString(entry.key, entry.value!);
    }
    await _secure.deleteAll();
  }
}

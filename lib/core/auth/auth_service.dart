import 'package:finhub/core/auth/jwt_decoder.dart';
import 'package:finhub/core/config/app_constants.dart';
import 'package:finhub/core/storage/storage_service.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/login/domain/models/invalid_session_exception.dart';
import 'package:finhub/features/login/domain/models/user.dart';

/// Owns the session: the token, its expiry, and the cached profile built from
/// its claims.
///
/// It does not authenticate anyone — `MockAuthService` mints the token, this
/// persists it and answers "who is signed in?" on a cold start.
class AuthService {
  /// Creates the service over [_storage].
  const AuthService(this._storage);

  final StorageService _storage;

  /// Persists a freshly minted [token] and the [User] its claims describe.
  ///
  /// Throws [InvalidSessionException] if the claims do not build a user.
  Future<User> persistSession(String token) async {
    final claims = JwtDecoder.decode(token);
    if (claims == null) throw const InvalidSessionException('Token payload is not readable');
    final user = User.fromJson(claims);
    await _storage.setSecure(StorageKeys.accessToken, token);
    // The profile carries PII beyond the token's own claims, so it goes to
    // the secure store alongside the token.
    await _storage.setJson(StorageKeys.userInfo, user.toJson(), secure: true);
    return user;
  }

  /// Returns the signed-in user, or `null` when there is no live session.
  ///
  /// An expired or unreadable token clears itself on the way out, so the next
  /// cold start does not re-examine it.
  Future<User?> getCurrentUser() async {
    final token = await _storage.getSecure(StorageKeys.accessToken);
    if (token == null) return null;
    if (JwtDecoder.isExpired(token)) {
      AppLogger.i('Stored session token has expired; clearing it');
      await clearAuthData();
      return null;
    }
    final cached = await _storage.getJson(StorageKeys.userInfo, secure: true);
    if (cached == null) return null;
    try {
      return User.fromJson(cached);
    } on InvalidSessionException catch (e, s) {
      AppLogger.e('Cached user could not be restored; clearing the session', e, s);
      await clearAuthData();
      return null;
    }
  }

  /// Erases everything the session owns. Must complete before the Riverpod
  /// container is rebuilt, or the fresh [AuthService] will find the old
  /// session still on disk.
  Future<void> clearAuthData() => _storage.clearSession();
}

import 'dart:convert';

import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/login/domain/models/invalid_session_exception.dart';
import 'package:finhub/features/login/domain/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the static-credential sign-in service.
final mockAuthServiceProvider = Provider<MockAuthService>(
  (ref) => MockAuthService(ref.watch(mockDataSourceProvider)),
);

/// Static-credential sign-in. There is no SSO, no PKCE and no refresh.
///
/// Credentials are checked against `assets/mock-data/auth/users.json` and the
/// session token is minted here, locally, with the same claim names a real
/// token would carry — so [JwtDecoder] and the route guard exercise their real
/// paths.
class MockAuthService {
  /// Creates the service over [_data].
  const MockAuthService(this._data);

  final MockDataSource _data;

  /// The one password every fixture account shares.
  static const String password = 'test@123';

  /// How long a minted token is good for.
  static const Duration sessionDuration = Duration(hours: 12);

  /// Signs in with a username **or** email and [password].
  ///
  /// Returns the minted token. Throws [InvalidSessionException] when the
  /// credentials match no fixture account, or match one whose role this app
  /// does not run.
  Future<String> signIn({required String identifier, required String password}) async {
    final file = await _data.read('auth/users.json');
    final expected = (file['password'] as String?) ?? MockAuthService.password;
    final users = (file['users'] as List<dynamic>).cast<Map<String, dynamic>>();

    final key = identifier.trim().toLowerCase();
    final match = users
        .where((u) => (u['username'] as String).toLowerCase() == key || (u['email'] as String).toLowerCase() == key)
        .firstOrNull;

    // One message for both halves of a wrong credential: which half was wrong
    // is not something a sign-in form should confirm.
    if (match == null || password != expected) {
      throw const InvalidSessionException('Unknown account or wrong password');
    }
    if (UserRole.tryParse(match['role'] as String?) == null) {
      throw InvalidSessionException('Role "${match['role']}" is not admissible');
    }
    return _mintToken(match);
  }

  /// Builds an unsigned JWT carrying [claims] plus `iat` / `exp`.
  ///
  /// The signature segment is a fixed placeholder: nothing verifies it, and a
  /// real-looking one would only suggest it means something.
  String _mintToken(Map<String, dynamic> claims) {
    final now = DateTime.now().toUtc();
    final payload = {
      ...claims,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': now.add(sessionDuration).millisecondsSinceEpoch ~/ 1000,
    };
    String segment(Map<String, dynamic> map) => base64Url.encode(utf8.encode(jsonEncode(map))).replaceAll('=', '');
    return '${segment({'alg': 'none', 'typ': 'JWT'})}.${segment(payload)}.mock';
  }
}

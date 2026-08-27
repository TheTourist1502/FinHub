import 'dart:convert';

/// Decodes the payload of a JSON Web Token.
///
/// Signature verification is the server's job and there is no server here —
/// this reads claims only, and every token it sees was minted locally by
/// `MockAuthService`.
abstract final class JwtDecoder {
  /// Returns the token's payload claims, or `null` if [token] is not a
  /// three-segment JWT with a JSON object payload.
  static Map<String, dynamic>? decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  /// The token's expiry, read from the `exp` claim (seconds since epoch, UTC).
  static DateTime? expiryOf(String token) {
    final exp = decode(token)?['exp'];
    if (exp is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
  }

  /// Whether [token] is malformed or past its `exp`. A token with no `exp`
  /// claim never expires.
  static bool isExpired(String token) {
    final expiry = expiryOf(token);
    if (expiry == null) return decode(token) == null;
    return DateTime.now().toUtc().isAfter(expiry);
  }
}

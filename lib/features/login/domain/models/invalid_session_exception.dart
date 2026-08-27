/// Thrown when a token parses but names no admissible session — an unknown or
/// non-admissible role, or claims the app cannot build a [User] from.
///
/// Distinct from a wrong password: the credentials were fine, the session they
/// would open is not one this app runs.
class InvalidSessionException implements Exception {
  /// Creates the exception with a diagnostic [reason] (never shown to a user).
  const InvalidSessionException(this.reason);

  /// Why the session was refused. Log-only — the UI shows localised copy.
  final String reason;

  @override
  String toString() => 'InvalidSessionException($reason)';
}

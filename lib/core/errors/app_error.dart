/// Sealed hierarchy of typed domain errors propagated throughout the app.
///
/// [title] and [message] are populated from the backend's RFC 7807 problem
/// details (`title` / `detail` fields) when the server provides them, so
/// callers can surface the exact server-authored copy. Both are `null` when
/// no response body was available (e.g. connection errors) — use
/// [ErrorHandler.getMessage] to fall back to a localised default.
///
/// Use a switch expression to exhaustively handle every case:
/// ```dart
/// final message = switch (error) {
///   NetworkError()    => 'Check your connection',
///   UnauthorizedError() => 'Please log in again',
///   ForbiddenError()  => 'Access denied',
///   NotFoundError()   => 'Not found',
///   ServerError(:final statusCode) => 'Server error $statusCode',
///   UnknownError(:final message) => message ?? 'Unknown error',
/// };
/// ```
sealed class AppError implements Exception {
  const AppError();

  /// Server-provided short title (RFC 7807 `title`), if present.
  String? get title;

  /// Server-provided detail message (RFC 7807 `detail`), if present.
  String? get message;
}

/// No internet connection or server is unreachable.
final class NetworkError extends AppError {
  const NetworkError({this.title, this.message});

  @override
  final String? title;

  @override
  final String? message;
}

/// HTTP 401 — token missing, expired, or revoked. Session must be refreshed.
final class UnauthorizedError extends AppError {
  const UnauthorizedError({this.title, this.message});

  @override
  final String? title;

  @override
  final String? message;
}

/// HTTP 403 — authenticated but the user lacks the required permission.
final class ForbiddenError extends AppError {
  const ForbiddenError({this.title, this.message});

  @override
  final String? title;

  @override
  final String? message;
}

/// HTTP 404 — the requested resource does not exist.
final class NotFoundError extends AppError {
  const NotFoundError({this.title, this.message});

  @override
  final String? title;

  @override
  final String? message;
}

/// HTTP 5xx — unexpected server-side failure.
final class ServerError extends AppError {
  const ServerError({this.statusCode, this.title, this.message});

  final int? statusCode;

  @override
  final String? title;

  @override
  final String? message;

  @override
  String toString() => 'ServerError(statusCode: $statusCode)';
}

/// Catch-all for errors that do not map to a known category.
final class UnknownError extends AppError {
  const UnknownError({this.title, this.message});

  @override
  final String? title;

  @override
  final String? message;

  @override
  String toString() => 'UnknownError($message)';
}

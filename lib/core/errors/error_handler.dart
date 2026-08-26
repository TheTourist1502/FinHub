import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/generated/l10n/app_localizations.dart';

/// Maps [AppError] values to localised user-facing display strings.
///
/// Pass the [AppLocalizations] instance obtained from `context.l10n` at the
/// call site. Because errors are always surfaced inside widgets (via
/// `AsyncValue.error` callbacks or error state widgets), a `BuildContext` —
/// and therefore `AppLocalizations` — is always available at the call site.
class ErrorHandler {
  const ErrorHandler._();

  /// Returns a user-facing message for the given [error].
  ///
  /// [l10n] is the [AppLocalizations] instance from the widget's context
  /// (`context.l10n`). A server-provided `detail` (see [AppError.message])
  /// bypasses translation and is returned directly; otherwise falls back to
  /// a localised default for the error's type.
  static String getMessage(AppError error, AppLocalizations l10n) {
    return error.message ??
        switch (error) {
          NetworkError() => l10n.errorNetwork,
          UnauthorizedError() => l10n.errorUnauthorized,
          ForbiddenError() => l10n.errorForbidden,
          NotFoundError() => l10n.errorNotFound,
          ServerError(:final statusCode) => l10n.errorServer(statusCode?.toString() ?? ''),
          UnknownError() => l10n.errorUnknown,
        };
  }
}

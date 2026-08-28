import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Error categories displayed by `AppErrorWidget`, each with its own default
/// icon, semantic color, and localised title/description.
enum AppErrorCode {
  /// No internet connection or the server is unreachable.
  networkError,

  /// The request took too long to respond.
  timeout,

  /// HTTP 401 — the session has expired or the token is invalid.
  unauthorized,

  /// HTTP 403 — authenticated but lacking the required permission.
  forbidden,

  /// HTTP 404 — the requested resource does not exist.
  notFound,

  /// HTTP 422 — the submitted data failed server-side validation.
  validationError,

  /// HTTP 5xx — unexpected server-side failure.
  serverError,

  /// HTTP 503 — the service is temporarily unavailable.
  serviceUnavailable,

  /// The feature is intentionally offline for planned maintenance.
  maintenance,

  /// The request succeeded but returned no data to display.
  emptyResponse,

  /// Catch-all for errors that do not map to a known category.
  unknown;

  /// Maps a domain [AppError] to the closest matching [AppErrorCode].
  ///
  /// [AppError] has no dedicated timeout, validation, maintenance, or empty
  /// variants, so those codes must be selected explicitly by the caller —
  /// this factory only covers cases the typed error hierarchy can express.
  static AppErrorCode fromAppError(AppError error) {
    return switch (error) {
      NetworkError() => AppErrorCode.networkError,
      UnauthorizedError() => AppErrorCode.unauthorized,
      ForbiddenError() => AppErrorCode.forbidden,
      NotFoundError() => AppErrorCode.notFound,
      ServerError(:final statusCode) => statusCode == 503 ? AppErrorCode.serviceUnavailable : AppErrorCode.serverError,
      UnknownError() => AppErrorCode.unknown,
    };
  }

  /// Default localised title shown when no explicit title is supplied.
  String defaultTitle(AppLocalizations l10n) {
    return switch (this) {
      AppErrorCode.networkError => l10n.appErrorWidgetNetworkTitle,
      AppErrorCode.timeout => l10n.appErrorWidgetTimeoutTitle,
      AppErrorCode.unauthorized => l10n.appErrorWidgetUnauthorizedTitle,
      AppErrorCode.forbidden => l10n.appErrorWidgetForbiddenTitle,
      AppErrorCode.notFound => l10n.appErrorWidgetNotFoundTitle,
      AppErrorCode.validationError => l10n.appErrorWidgetValidationTitle,
      AppErrorCode.serverError => l10n.appErrorWidgetServerTitle,
      AppErrorCode.serviceUnavailable => l10n.appErrorWidgetServiceUnavailableTitle,
      AppErrorCode.maintenance => l10n.appErrorWidgetMaintenanceTitle,
      AppErrorCode.emptyResponse => l10n.appErrorWidgetEmptyTitle,
      AppErrorCode.unknown => l10n.appErrorWidgetUnknownTitle,
    };
  }

  /// Default localised description shown when no explicit description is supplied.
  String defaultDescription(AppLocalizations l10n) {
    return switch (this) {
      AppErrorCode.networkError => l10n.appErrorWidgetNetworkDescription,
      AppErrorCode.timeout => l10n.appErrorWidgetTimeoutDescription,
      AppErrorCode.unauthorized => l10n.appErrorWidgetUnauthorizedDescription,
      AppErrorCode.forbidden => l10n.appErrorWidgetForbiddenDescription,
      AppErrorCode.notFound => l10n.appErrorWidgetNotFoundDescription,
      AppErrorCode.validationError => l10n.appErrorWidgetValidationDescription,
      AppErrorCode.serverError => l10n.appErrorWidgetServerDescription,
      AppErrorCode.serviceUnavailable => l10n.appErrorWidgetServiceUnavailableDescription,
      AppErrorCode.maintenance => l10n.appErrorWidgetMaintenanceDescription,
      AppErrorCode.emptyResponse => l10n.appErrorWidgetEmptyDescription,
      AppErrorCode.unknown => l10n.appErrorWidgetUnknownDescription,
    };
  }

  /// Static MDI icon SVG shown when no custom icon or image is supplied.
  String get iconSvg {
    return switch (this) {
      AppErrorCode.networkError => Mdi.wifi_off,
      AppErrorCode.timeout => Mdi.timer_outline,
      AppErrorCode.unauthorized => Mdi.lock_outline,
      AppErrorCode.forbidden => Mdi.block_helper,
      AppErrorCode.notFound => Mdi.magnify_close,
      AppErrorCode.validationError => Mdi.alert_circle_outline,
      AppErrorCode.serverError => Mdi.server_off,
      AppErrorCode.serviceUnavailable => Mdi.cloud_off_outline,
      AppErrorCode.maintenance => Mdi.construction_outline,
      AppErrorCode.emptyResponse => Mdi.inbox_outline,
      AppErrorCode.unknown => Mdi.alert_outline,
    };
  }

  /// Semantic icon/accent color for the current theme, read from [colors].
  Color color(AppColorTokens colors) {
    return switch (this) {
      AppErrorCode.networkError => colors.statusInfoDefault,
      AppErrorCode.timeout => colors.statusWarningDefault,
      AppErrorCode.unauthorized => colors.statusWarningDefault,
      AppErrorCode.forbidden => colors.statusErrorDefault,
      AppErrorCode.notFound => colors.iconSecondary,
      AppErrorCode.validationError => colors.statusWarningDefault,
      AppErrorCode.serverError => colors.statusErrorDefault,
      AppErrorCode.serviceUnavailable => colors.statusErrorDefault,
      AppErrorCode.maintenance => colors.statusWarningDefault,
      AppErrorCode.emptyResponse => colors.iconSecondary,
      AppErrorCode.unknown => colors.statusErrorDefault,
    };
  }
}

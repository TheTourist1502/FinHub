import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

/// Reusable, Material 3 full-widget error state shown whenever an API
/// request fails.
///
/// Renders an icon (or [customIcon] / [customImage] override), a title, a
/// description, and an optional retry button, with per-[AppErrorCode]
/// defaults for all four. The widget is purely presentational — it never
/// touches provider or repository state, and only exposes [onRetry] so the
/// caller decides what "retry" means (re-fetch, invalidate a provider,
/// navigate back, etc.).
///
/// Usage inside an `AsyncValue.error` branch:
/// ```dart
/// error: (err, _) => AppErrorWidget(
///   errorCode: AppErrorCode.fromAppError(err is AppError ? err : const UnknownError()),
///   onRetry: () => ref.invalidate(myProvider),
/// ),
/// ```
class AppErrorWidget extends StatelessWidget {
  /// Creates an [AppErrorWidget].
  const AppErrorWidget({
    required this.errorCode,
    required this.onRetry,
    this.title,
    this.description,
    this.retryButtonText,
    this.showRetryButton = true,
    this.isRetrying = false,
    this.customIcon,
    this.customImage,
    super.key,
  });

  /// The error category driving the default icon, color, title, and description.
  final AppErrorCode errorCode;

  /// Called when the user taps the retry button. Never invoked while [isRetrying] is true.
  final VoidCallback onRetry;

  /// Overrides [errorCode]'s default title. Falls back to it when null.
  final String? title;

  /// Overrides [errorCode]'s default description. Falls back to it when null.
  final String? description;

  /// Overrides the retry button's label. Falls back to the localised default when null.
  final String? retryButtonText;

  /// Whether the retry button is shown at all.
  final bool showRetryButton;

  /// Whether a retry is currently in flight — disables the button and shows a spinner in its place.
  final bool isRetrying;

  /// Fully custom icon widget shown instead of the default [errorCode] icon.
  final Widget? customIcon;

  /// Fully custom illustration widget (SVG/Lottie/image). Takes priority over [customIcon].
  final Widget? customImage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVisual(colors),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(
                title ?? errorCode.defaultTitle(l10n),
                textAlign: TextAlign.center,
                style: AppTypography.emptyStateTitle.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(
                description ?? errorCode.defaultDescription(l10n),
                textAlign: TextAlign.center,
                style: AppTypography.emptyStateDescription.copyWith(color: colors.textSecondary),
              ),
              if (showRetryButton) ...[
                const SizedBox(height: AppDimensions.spaceLg),
                _buildRetryButton(context, l10n),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Resolves the icon/illustration to display: [customImage], then [customIcon],
  /// then the [errorCode] default — never null, so no fallback ever crashes.
  Widget _buildVisual(AppColorTokens colors) {
    return customImage ?? customIcon ?? Iconify(errorCode.iconSvg, size: 64, color: errorCode.color(colors));
  }

  /// The primary retry button. Disabled and showing a spinner while [isRetrying] is true.
  Widget _buildRetryButton(BuildContext context, AppLocalizations l10n) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return ElevatedButton(
      onPressed: isRetrying ? null : onRetry,
      style: ElevatedButton.styleFrom(minimumSize: const Size(160, AppDimensions.buttonHeight)),
      child: isRetrying
          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: onPrimary))
          : Text(retryButtonText ?? l10n.commonButtonRetry),
    );
  }
}

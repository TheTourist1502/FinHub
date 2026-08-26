import 'package:finhub/core/accessibility/text_scale.dart';
import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/errors/error_handler.dart';
import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Root widget of the FinHub application.
///
/// Applies [AppTheme], installs the generated [AppLocalizations] delegates,
/// clamps text scaling through [AppTextScale.builder], and wires
/// [scaffoldMessengerKey] so [SnackbarService] can surface messages from
/// anywhere without a [BuildContext]. Routing and the session layer replace
/// the placeholder home as they arrive.
class App extends StatelessWidget {
  /// Creates the root widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      // Light or dark is chosen at compile time by ThemeConfig.activeTheme —
      // there is no runtime theme state yet, and no persisted user preference.
      theme: AppTheme.active,
      // Derived from the ARB files. Swaps to `appSupportedLocales` once the
      // persisted locale preference arrives with the storage layer.
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Caps the OS font-size setting so large accessibility scales can't
      // break layouts that assume a bounded text height.
      builder: AppTextScale.builder,
      home: const _FoundationPreview(),
    );
  }
}

/// Holding screen for the foundation layers: reads its copy from
/// [AppLocalizations] and its colours from the theme, and offers one button
/// that drives a typed [AppError] through [ErrorHandler] into
/// [SnackbarService] — so the whole day-3 chain is visibly working rather than
/// merely compiled.
class _FoundationPreview extends ConsumerWidget {
  const _FoundationPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Iconify(Mdi.finance, color: scheme.onSurface, size: 44),
                const SizedBox(width: 12),
                Text(context.l10n.appName, style: AppTypography.logoStyle.copyWith(color: scheme.onSurface)),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.errorUnknown,
              textAlign: TextAlign.center,
              style: AppTypography.pageSubtitle.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref
                  .read(snackbarServiceProvider)
                  .showError(ErrorHandler.getMessage(const NotFoundError(), context.l10n)),
              child: const Text('Raise a typed error'),
            ),
          ],
        ),
      ),
    );
  }
}

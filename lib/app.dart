import 'package:finhub/core/accessibility/text_scale.dart';
import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_router.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root widget of the FinHub application.
///
/// Applies [AppTheme], installs the generated [AppLocalizations] delegates,
/// clamps text scaling through [AppTextScale.builder], wires
/// [scaffoldMessengerKey] so [SnackbarService] can surface messages from
/// anywhere without a [BuildContext], and hands navigation to the app's
/// [GoRouter].
class App extends ConsumerWidget {
  /// Creates the root widget.
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: ref.watch(appRouterProvider),
      // Light or dark is chosen at compile time by ThemeConfig.activeTheme —
      // there is no runtime theme state yet, and no persisted user preference.
      theme: AppTheme.active,
      // Derived from the ARB files. Swaps to `appSupportedLocales` once the
      // persisted locale preference arrives.
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Caps the OS font-size setting so large accessibility scales can't
      // break layouts that assume a bounded text height.
      builder: AppTextScale.builder,
    );
  }
}

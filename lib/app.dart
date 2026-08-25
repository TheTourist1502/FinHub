import 'package:finhub/core/accessibility/text_scale.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Root widget of the FinHub application.
///
/// Applies [AppTheme] and clamps text scaling through [AppTextScale.builder],
/// so every screen added from here on inherits the design system rather than
/// styling itself. Localisation, routing and the session layer replace the
/// placeholder home as they arrive.
class App extends StatelessWidget {
  /// Creates the root widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinHub',
      debugShowCheckedModeBanner: false,
      // Light or dark is chosen at compile time by ThemeConfig.activeTheme —
      // there is no runtime theme state yet, and no provider graph to hold it.
      theme: AppTheme.active,
      // Caps the OS font-size setting so large accessibility scales can't
      // break layouts that assume a bounded text height.
      builder: AppTextScale.builder,
      home: const _ThemePreview(),
    );
  }
}

/// Holding screen for the design system: the brand lockup drawn from theme
/// tokens rather than hard-coded colours, so the theme is visibly applied and
/// both variants can be checked by flipping [ThemeConfig.activeTheme].
class _ThemePreview extends StatelessWidget {
  const _ThemePreview();

  @override
  Widget build(BuildContext context) {
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
                Text('FinHub', style: AppTypography.logoStyle.copyWith(color: scheme.onSurface)),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Design system applied',
              style: AppTypography.pageSubtitle.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

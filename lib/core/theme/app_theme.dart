// Shown-clause import: `CupertinoPageTransitionsBuilder` lives in the
// cupertino library and is not re-exported by material.
import 'package:finhub/core/config/theme_config.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// [ThemeData] factory for the FinHub app.
///
/// Apply the active theme via `MaterialApp(theme: AppTheme.active)`.
///
/// To switch themes during development, change [ThemeConfig.activeTheme]
/// in `lib/core/config/theme_config.dart` and hot-restart.
class AppTheme {
  const AppTheme._();

  /// Returns [client] or [dark] based on [ThemeConfig.activeTheme].
  static ThemeData get active => ThemeConfig.activeTheme == AppThemeMode.dark ? dark : client;

  /// Returns a [ButtonStyle] for destructive (red) actions.
  ///
  /// Use as the `style:` argument on any [ElevatedButton] that triggers a
  /// destructive operation. The colours are derived from the active theme's
  /// [ColorScheme.error] so this adapts correctly in both client and dark modes.
  ///
  /// ```dart
  /// ElevatedButton(
  ///   style: AppTheme.dangerStyle(context),
  ///   onPressed: _handleDelete,
  ///   child: const Text('Delete Account'),
  /// )
  /// ```
  static ButtonStyle dangerStyle(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ElevatedButton.styleFrom(
      backgroundColor: cs.error,
      foregroundColor: cs.onError,
      disabledBackgroundColor: cs.error.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius)),
      elevation: 1,
    );
  }

  /// Returns the app-wide [InputDecoration] for a search box.
  ///
  /// Every search box in the app renders through this one decoration —
  /// magnify prefix, 12 px radius, [AppColorTokens.borderStrong] resting
  /// border and [AppColorTokens.interactiveDefault] focus ring — so the
  /// control looks identical on every screen. Prefer the [AppSearchField]
  /// widget, which wraps this together with the clear button; call this
  /// directly only when a screen needs its own [TextField] around it.
  ///
  /// [suffixIcon] is normally the clear ("x") button; pass `null` for a
  /// search box that cannot be cleared.
  static InputDecoration searchDecoration(
    BuildContext context, {
    required String hint,
    Widget? suffixIcon,
  }) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(AppDimensions.inputBorderRadius);
    // Resting and enabled states share a border — build it once.
    final restingBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.borderStrong),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.searchText.copyWith(color: colors.inputHintColor),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 15, right: 9),
        child: Iconify(Mdi.magnify, color: colors.textDisabled, size: 18),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 41, minHeight: 44),
      suffixIcon: suffixIcon,
      // The clear button collapses to nothing while the field is empty, so the
      // suffix slot must be allowed to shrink to zero width instead of holding
      // the default 48 px minimum.
      suffixIconConstraints: const BoxConstraints(minHeight: 44),
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
      border: restingBorder,
      enabledBorder: restingBorder,
      // A disabled search box keeps its shape and only greys its fill, so it
      // reads as "nothing to search yet" rather than as a broken control.
      disabledBorder: restingBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colors.interactiveDefault),
      ),
      filled: true,
      fillColor: _inputFillColor(colors.surfaceDefault, colors.inputDisabledBg),
    );
  }

  /// Resolves an input's fill between its resting [enabledFill] and
  /// [disabledFill].
  ///
  /// `InputDecorator` resolves the fill through `WidgetStateProperty`, so a
  /// disabled field picks up `inputDisabledBg` without any call site branching
  /// on `enabled`.
  static WidgetStateColor _inputFillColor(Color enabledFill, Color disabledFill) {
    return WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? disabledFill : enabledFill,
    );
  }

  /// Client (light) theme — the default FinHub advisor experience.
  ///
  /// Preserves the existing visual appearance exactly.
  static ThemeData get client {
    final cs = ColorScheme.fromSeed(seedColor: AppColors.brandNavyBlue).copyWith(
      surface: AppColors.backgroundPage,
      onSurface: AppColors.headingText,
      // Seed from navy blue (#0D1846) so all M3 generated tones derive from the
      // brand navy. Override primary explicitly so buttons, focus rings, and
      // ripples use the exact design token.
      primary: AppColors.brandNavyBlue,
      onPrimary: AppColors.textOnPrimary,
      // M3 derives surfaceContainerLow from the blue seed, producing a tinted
      // tone. Pin it to white so social-login buttons match the Figma design.
      surfaceContainerLow: AppColors.cardBackground,
      outlineVariant: AppColors.inputBorder,
      // Pin error to the design token so dangerStyle and inputDecorationTheme
      // both render the same red instead of M3's auto-generated tone.
      error: AppColors.errorColor,
      onError: AppColors.textOnPrimary,
    );
    return _buildTheme(
      colorScheme: cs,
      colorTokens: AppColorTokens.light,
      appBarBg: AppColors.cardBackground,
      inputFill: AppColors.cardBackground,
      inputBorderColor: AppColors.inputBorder,
      dividerColor: AppColors.inputBorder,
    );
  }

  /// Dark theme — visually appropriate for low-light use.
  ///
  /// Uses [AppColors] dark palette for explicit surface overrides; all other
  /// dark-mode colours are derived automatically by [ColorScheme.fromSeed]
  /// with [Brightness.dark].
  static ThemeData get dark {
    final cs = ColorScheme.fromSeed(
      seedColor: AppColors.primaryAction,
      brightness: Brightness.dark,
    ).copyWith(surface: AppColors.backgroundPageDark);
    return _buildTheme(
      colorScheme: cs,
      colorTokens: AppColorTokens.dark,
      appBarBg: AppColors.cardBackgroundDark,
      inputFill: AppColors.cardBackgroundDark,
      inputBorderColor: AppColors.inputBorderDark,
      dividerColor: AppColors.inputBorderDark,
    );
  }

  /// Shared [ThemeData] builder used by both [client] and [dark].
  ///
  /// Per-theme overrides are passed explicitly as named parameters; everything
  /// else is derived from [colorScheme] so both themes stay in sync.
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required AppColorTokens colorTokens,
    required Color appBarBg,
    required Color inputFill,
    required Color inputBorderColor,
    required Color dividerColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      extensions: [colorTokens],
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBg,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        // headingLarge has no hardcoded colour; copyWith supplies onSurface so
        // AppBar titles render correctly in both light and dark.
        titleTextStyle: AppTypography.headingLarge.copyWith(color: colorScheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Disabled inputs grey out app-wide from here — no call site branches
        // on `enabled` to pick a fill.
        fillColor: _inputFillColor(inputFill, colorTokens.inputDisabledBg),
        contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        hintStyle: AppTypography.inputHint.copyWith(color: colorTokens.inputHintColor),
        errorStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.errorColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.brandNavyBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          // No minimumSize here — each call site controls its own width and height.
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius)),
          textStyle: AppTypography.buttonLabel,
          elevation: 1,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius)),
          textStyle: AppTypography.buttonLabel,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius)),
          textStyle: AppTypography.buttonLabel,
        ),
      ),
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),
      // Both platforms use the iOS horizontal push, so a screen change feels
      // identical on an advisor's iPhone and their Android tablet and the
      // edge-swipe back gesture works on both. This deliberately overrides
      // Android's default zoom transition.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

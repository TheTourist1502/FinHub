/// Identifies the active application theme.
///
/// Used by [ThemeConfig.activeTheme] to select between the client (light)
/// and dark theme variants at compile time.
enum AppThemeMode {
  /// Default client-facing light theme.
  client,

  /// Dark theme for low-light environments or preference.
  dark,
}

/// Compile-time theme configuration.
///
/// Change [activeTheme] and hot-restart to switch the entire application
/// theme. This is a development/testing switch — it is intentionally a
/// `const` value and does not involve any runtime state or Riverpod providers.
///
/// To switch to dark mode during development:
/// ```dart
/// static const AppThemeMode activeTheme = AppThemeMode.dark;
/// ```
class ThemeConfig {
  const ThemeConfig._();

  /// The currently active theme. Defaults to [AppThemeMode.client].
  static const AppThemeMode activeTheme = AppThemeMode.client;
}

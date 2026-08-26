import 'package:finhub/generated/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:finhub/generated/l10n/app_localizations.dart';

/// Shorthand [BuildContext] extension for accessing [AppLocalizations].
///
/// Usage inside any widget `build` method:
/// ```dart
/// Text(context.l10n.authLoginTitle)
/// ```
///
/// This is safe because `MaterialApp` always provides [AppLocalizations] via
/// `AppLocalizations.localizationsDelegates`, and `nullable-getter: false` is
/// set in l10n.yaml, so `AppLocalizations.of` returns a non-nullable instance.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

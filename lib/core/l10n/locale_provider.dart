import 'package:finhub/core/config/app_constants.dart';
import 'package:finhub/core/storage/storage_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The locales the app officially supports.
///
/// Extend this list when a new language ships. Both `MaterialApp.supportedLocales`
/// and [LocaleNotifier] validate against this constant so there is a single
/// source of truth.
const List<Locale> appSupportedLocales = [
  Locale('en'),
  Locale('es'),
  Locale('pt', 'BR'),
];

/// Provides the active [Locale] and persists the user's choice across sessions.
final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// Manages the user's selected locale.
///
/// On first build, reads the persisted language tag from `StorageService`. If
/// absent or unsupported, falls back to English. [setLocale] writes the new
/// choice to storage before updating state so the locale survives a cold restart.
class LocaleNotifier extends AsyncNotifier<Locale> {
  static const Locale _fallback = Locale('en');

  @override
  Future<Locale> build() async {
    final storage = ref.watch(storageServiceProvider);
    final tag = await storage.getData(StorageKeys.locale);
    if (tag == null) return _fallback;
    final locale = _tagToLocale(tag);
    return appSupportedLocales.contains(locale) ? locale : _fallback;
  }

  /// Switches the active locale and persists the choice.
  ///
  /// Asserts in debug mode when [locale] is not in [appSupportedLocales] to
  /// catch unsupported locale strings early during development.
  Future<void> setLocale(Locale locale) async {
    assert(
      appSupportedLocales.contains(locale),
      'Locale $locale is not in appSupportedLocales. Add it before calling setLocale.',
    );
    final storage = ref.read(storageServiceProvider);
    await storage.setData(StorageKeys.locale, _localeToTag(locale));
    state = AsyncData(locale);
  }

  /// Serialises a [Locale] to a storage-friendly tag (e.g. `'pt_BR'`, `'en'`).
  static String _localeToTag(Locale locale) =>
      locale.countryCode != null ? '${locale.languageCode}_${locale.countryCode}' : locale.languageCode;

  /// Deserialises a stored tag back to a [Locale].
  static Locale _tagToLocale(String tag) {
    final parts = tag.split('_');
    return parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
  }
}

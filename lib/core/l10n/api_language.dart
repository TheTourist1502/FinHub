import 'package:flutter/widgets.dart';

/// Maps [locale] to the `en`/`es`/`hi` language codes accepted by backend
/// endpoints (e.g. `PATCH /v1/profile/preferences`, the market-insights
/// list API). Falls back to `"en"` for any other locale.
String apiLangForLocale(Locale locale) => switch (locale.languageCode) {
  'es' => 'es',
  'hi' => 'hi',
  _ => 'en',
};

/// Maps a backend `en`/`es`/`hi` language code back to a [Locale], for use
/// with `showLanguageSelectionSheet`'s `kLanguageOptions`.
Locale localeForApiLang(String lang) => switch (lang) {
  'es' => const Locale('es'),
  'hi' => const Locale('hi'),
  _ => const Locale('en'),
};

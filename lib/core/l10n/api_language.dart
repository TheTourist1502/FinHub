import 'package:flutter/widgets.dart';

/// Maps [locale] to the `en`/`es`/`prt` language codes accepted by backend
/// endpoints (e.g. `PATCH /v1/profile/preferences`, the market-insights
/// list API) — Portuguese is `"prt"`, not Flutter's `"pt"` `languageCode`.
/// Falls back to `"en"` for any other supported app locale (e.g. a future
/// non-Portuguese/Spanish addition).
String apiLangForLocale(Locale locale) => switch (locale.languageCode) {
  'es' => 'es',
  'pt' => 'prt',
  _ => 'en',
};

/// Maps a backend `en`/`es`/`prt` language code back to a [Locale], for use
/// with `showLanguageSelectionSheet`'s `kLanguageOptions` (Portuguese is
/// keyed there as `pt_BR`, and as `"prt"` — not `"pt"` — by the backend).
Locale localeForApiLang(String lang) => switch (lang) {
  'es' => const Locale('es'),
  'prt' => const Locale('pt', 'BR'),
  _ => const Locale('en'),
};

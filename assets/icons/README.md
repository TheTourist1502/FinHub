# App Icon Source Images

Drop the final artwork here, then regenerate with `dart run flutter_launcher_icons`:

- `app_icon.png` — 1024x1024, full-bleed square, logo baked onto its final gradient
  background. Used for iOS and the Android legacy icon.
- `app_icon_foreground.png` — 1024x1024, transparent background, logo mark only, inset
  to the [Android adaptive icon safe zone](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive).
- `app_icon_background.png` — 1024x1024, full-bleed square, the gradient only (no logo).
  Used as the background layer of the Android adaptive icon.

Config lives in `pubspec.yaml` under `flutter_launcher_icons:`.

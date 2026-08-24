# FinHub

Flutter application (iOS + Android) for financial advisors. Advisors use it to observe the
portfolios of their households and clients, raise service requests, track tasks and
commissions, and read market-insight articles.

The app ships two role experiences from one binary: `advisor` sees their own book of
business, `leadership` sees another advisor's after picking one from the FA selector.

> **Status — foundations.** This is the project scaffold: the app runs and shows a
> placeholder. The design system, localisation, data layer, authentication, routing and
> the feature set land over the days that follow.

## Requirements

- Flutter SDK with Dart `^3.11.5` (see `pubspec.yaml`)
- Xcode (iOS builds) / Android SDK (Android builds)

There is nothing to configure before the first run: no env files, no `--dart-define`, no
flavors, no Firebase config. One build, one application ID (`com.finhub.mobile`).

## Setup

```bash
make setup        # flutter pub get + point git at .githooks/
```

## Running

```bash
make run          # or: flutter run
```

## Building

```bash
make apk          # Android APK
make aab          # Play Store bundle
make ipa          # iOS
```

## Code quality

```bash
make lint         # flutter analyze --fatal-infos --fatal-warnings
make format       # dart format --line-length 120 lib/
make fix          # dart fix --apply, then format
make check        # format check + analyze (what pre-commit runs)
```

Lints come from `very_good_analysis`, with `avoid_dynamic_calls` added and the
80-character line rule dropped — the formatter is set to 120.

Git hooks live in `.githooks/` (plain shell, no third-party tool):

| Hook | Runs on | Does |
|---|---|---|
| `pre-commit` | every commit | formats staged Dart files, re-stages them, then analyzes the project |
| `pre-push` | pushes to `dev` only | analyzes the project |

## Branding

The app's mark is the `mdi:finance` glyph from `iconify_flutter`, drawn in Dart — there is
no logo image asset. The launcher icon in `assets/icons/` is rendered from that same glyph
and is a build-time input only, never bundled into the app.

```bash
dart run flutter_launcher_icons        # regenerate native launcher icons
dart run flutter_native_splash:create  # regenerate the solid-colour splash
```

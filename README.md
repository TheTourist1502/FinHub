# FinancialApp FA Mobile

Flutter application (iOS + Android) for financial advisors. Advisors use it to observe the
portfolios of their households and clients, raise service requests, track tasks and
commissions, and read market-insight articles.

The app ships two role experiences from one binary:

| Role | What they see |
|---|---|
| `advisor` | Their own book of business — every tab and surface. |
| `leadership` | Another advisor's book, after picking one from the FA selector. Reads a mirrored `/leadership` endpoint namespace. |

A `client` role deliberately does **not** exist as an admissible session — a token
carrying it is refused at login.

---

## Offline build — no backend

This app talks to nothing, and has no code that could. There is no HTTP client, no
interceptor chain and no endpoint list — `dio` is not even a dependency. Each feature's
repository (`lib/features/*/data/*_mock_repository.dart`) reads the JSON files in
`assets/mock-data/` through `MockDataSource` (`lib/core/mock/`) and parses them with the
same domain models the networked app used, so every screen still exercises its real
loading, error, empty, search, sort and pagination paths.

Which advisor's data a repository reads is decided by `DataScope`: an advisor reads their
own book, a leadership user reads the advisor they picked in the FA selector.

Doc comments throughout still cite `/v1/...` paths. Those describe the JSON contract the
fixtures reproduce, not a call the app makes.

### Signing in

There is no SSO. Credentials are checked against `assets/mock-data/auth/users.json`.
**Every account uses the password `test@123`.** Sign in with a username or an email.

| Username | Role | Advisor id |
|---|---|---|
| `test` | advisor | `FAP0001` — the book built from the supplied ACCOUNT dummy-data CSV |
| `daniel.alvarez` … `ethan.caldwell` | advisor | `FAP0002` … `FAP0010` |
| `victoria.reyes`, `samuel.okonkwo`, `helena.vargas` | leadership | none — they pick an advisor from the FA selector |

Signing out clears local state and returns to the login screen.

### The data

`assets/mock-data/` is organised feature by feature. Each file is a JSON object keyed by
whatever scopes it — a financial advisor id, an account id, a household id, or `default` for
data that is the same for everyone. `MockDataSource` picks the record matching the signed-in
advisor (or, for a leadership user, the advisor they selected), falling back to `default`.
Real-time positions and activity are served the same way, from `real_time/holdings.json` and
`real_time/activities.json`.

Changes a user makes — preferences, personalization, notification read state, service-request
submissions — are held in memory for the life of the session, which is all a backend-free
build can honestly offer.

Regenerate everything with:

```bash
python3 scripts/gen_mock_data.py
```

Advisor `FAP0001`'s ten accounts are the supplied CSV rows verbatim; the other nine advisors
get generated books of the same shape. Dates are written relative to the generation date, so
re-run the generator when task due-dates drift too far into the past.

`test/core/mock/mock_data_test.dart` drives every repository against the shipped fixtures and
parses the results with the app's own models — run it after touching a repository or a
fixture.

---

## Requirements

- Flutter SDK with Dart `^3.11.5` (see `pubspec.yaml`)
- Xcode (iOS builds) / Android SDK (Android builds)
- Firebase projects for the environment you are building (no backend access is needed — see **Offline build** above)

## Setup

```bash
make setup        # flutter pub get + point git at .githooks/ + report missing config
make check-setup  # verify every gitignored config file is present
```

`make setup` finishes by running `scripts/check_env.sh`, which lists the files it could
not find. These are gitignored and must be supplied manually before the app will build:

| File | Purpose |
|---|---|
| `environment/env.{dev,uat,prod}.json` | `BASE_URL`, `APP_ENV`, `ENABLE_PASSWORD_LOGIN` |
| `android/app/src/{dev,uat,prod}/google-services.json` | Firebase (Android) |
| `ios/Runner/{dev,uat,prod}/GoogleService-Info.plist` | Firebase (iOS) |

## Flavors

Three flavors, each with its own application ID and config file. **Always pass
`--flavor` and the matching `--dart-define-from-file` together** — the JSON supplies the
base URL and environment name at compile time via `AppConfig.fromEnvironment()`.

| Flavor | Purpose | Application ID |
|---|---|---|
| `dev` | Local development | `com.financialapp.mobile.dev` |
| `uat` | QA / staging | `com.financialapp.mobile.uat` |
| `prod` | Production | `com.financialapp.mobile` |

## Running

```bash
make run        # dev flavor, debug
make run-uat    # uat flavor
make run-prod   # prod flavor, release
```

Or directly:

```bash
flutter run --flavor dev --dart-define-from-file=environment/env.dev.json
```

## Building

```bash
make apk-dev      make apk-uat      make apk-prod      # Android APK
make aab-prod                                          # Play Store bundle
make ipa-dev      make ipa-uat      make ipa-prod      # iOS (renamed per flavor)
```

`flutter build ipa` always emits `financial_app.ipa`, so each target renames its output
to keep the flavors from overwriting each other.

## Testing & code quality

```bash
flutter test      # 56 test files: unit, provider, and widget tests
make lint         # flutter analyze --fatal-infos --fatal-warnings
make format       # dart format --line-length 120 lib/ test/
make fix          # dart fix --apply, then format
make check        # format check + analyze (what pre-commit runs)
```

Git hooks live in `.githooks/` (plain shell, no third-party tool):

| Hook | Runs on | Does |
|---|---|---|
| `pre-commit` | every commit | formats staged Dart files, re-stages them, then analyzes the project |
| `pre-push` | pushes to `dev` only | analyze + `flutter test` |

## Localisation

Three locales: English (`app_en.arb`), Spanish (`app_es.arb`), Brazilian Portuguese
(`app_pt_BR.arb`, with `app_pt.arb` as the base fallback). Every user-facing string is an
ARB key read through `context.l10n.<key>` — no literals in widgets.

```bash
flutter gen-l10n   # after editing any ARB file
```

---

## Architecture at a glance

```
lib/
├── core/         cross-cutting infrastructure — auth, network, routing, storage,
│                 theme, l10n, notifications, observability, motion
├── features/     28 features, each split data/ · domain/ · presentation/
├── shared/       reusable widgets, animation primitives, shared models
├── l10n/         ARB source files
└── generated/    flutter gen-l10n output
```

**Layering rules** (enforced in review, documented in `.claude/rules/architecture.md`):

- `data/` never imports `presentation/`
- `domain/` never imports `data/` or `presentation/` — it declares the interfaces `data/` implements
- `presentation/` depends only on `domain/`
- anything shared across features belongs in `core/` or `shared/`, never inside a feature folder

**State management is Riverpod only.** No `setState`, no `ChangeNotifier`, no BLoC. The
single carve-out is `SessionRoot`, which sits *above* `ProviderScope` because its job is
destroying the Riverpod container on sign-out.

**Routing** is GoRouter with a single `StatefulShellRoute.indexedStack`. All access
decisions live in one function, `routeGuard` (`lib/core/routing/route_guard.dart`); route
policies are declared in `AppRoutes.policies`. Screens contain no auth or role checks.

**Networking** is a single Dio client with a six-stage interceptor chain — auth-token
attachment, logging (non-release only), `DioException` → typed `AppError` mapping,
refresh-and-retry on 401, Crashlytics reporting, and a user-facing snackbar for anything
still unrecovered.

Fuller detail on the layered architecture, the security model, and the performance budget
lives in `.claude/docs/` and `.claude/rules/`.

## Project conventions

- Every class, method, and non-trivial block carries a `///` doc comment.
- Diagnostic output goes through `AppLogger` only — never `print`, `debugPrint`, or
  `developer.log`. `AppLogger` compiles out of release builds entirely.
- Colors come from `Theme.of(context).colorScheme` or `context.appColors`; `AppColors`
  is importable only from the theme files.
- Icons use `iconify_flutter` with inline `mdi` SVG strings — never a set that fetches at
  runtime.
- Snackbars go through `snackbarServiceProvider`, never `ScaffoldMessenger` directly.
- `firebase_crashlytics` may be imported in exactly one file:
  `lib/core/observability/crashlytics_reporter.dart`.
- No empty `catch` blocks — every catch rethrows, logs, or reports.
- Motion reads its durations and curves from `AppMotion` and honours the platform's
  reduce-motion setting.

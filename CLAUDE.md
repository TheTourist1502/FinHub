## Project
Flutter app for financial advisors (iOS + Android). See [.claude/docs/project-overview.md](.claude/docs/project-overview.md).

**This build has no backend and no HTTP layer.** There is no `Dio`, no interceptor chain and
no `ApiEndpoints`; the `dio` package is not a dependency. Every repository is a
`*MockRepository` under `lib/features/*/data/` that reads `assets/mock-data/` through
`MockDataSource` (`lib/core/mock/`) and parses it with the same domain models. Adding a data
source means adding a fixture under `assets/mock-data/` and a repository method that reads it
(regenerate fixtures with `python3 scripts/gen_mock_data.py`).

`DataScope` (`lib/core/mock/data_scope.dart`) names the advisor a read is scoped to — their own
for an advisor, the selected one for a leadership user. Any repository serving advisor-scoped
data takes it, and providers must **watch** it so a leadership advisor switch rebuilds them.

Doc comments throughout still cite `/v1/...` paths. Those describe the JSON contract the
fixtures reproduce, not a call the app makes.

**Sign-in is static.** There is no SSO — no PKCE, no deep-link callback, no token refresh.
`MockAuthService` (`lib/core/mock/mock_auth.dart`) checks credentials against
`assets/mock-data/auth/users.json` — 10 advisors and 3 leadership users, every account sharing
the password `test@123` (`MockAuthService.password`) — and mints the session token locally.
`test` / `test@123` signs in as advisor `FAP0001`. Sign-out is local teardown only and returns
to `/login`.

Both role experiences are live: the signed-in user's role, taken from the locally minted token's
claims, decides whether the advisor or the leadership flow loads.

## Commands

```bash
# Prerequisites — must pass before flutter run/build
bash scripts/check_env.sh

flutter run --flavor dev --dart-define-from-file=environment/env.dev.json   # run on connected device (see Flavors below for uat/prod)
flutter test                        # run all tests
flutter analyze --no-pub            # static analysis (also runs automatically via hook)
flutter gen-l10n                    # regenerate l10n after editing ARB files
flutter build apk / ipa --flavor <dev|uat|prod> --dart-define-from-file=environment/env.<flavor>.json   # release builds
```

## Environment Setup

These files are gitignored and must be added manually before the app will run
(`BASE_URL` is inert — no request leaves the device):
- `environment/env.dev.json`, `environment/env.uat.json`, and `environment/env.prod.json`
- `android/app/src/dev/google-services.json`, `android/app/src/uat/google-services.json`, and `android/app/src/prod/google-services.json`
- `ios/Runner/dev/GoogleService-Info.plist`, `ios/Runner/uat/GoogleService-Info.plist`, and `ios/Runner/prod/GoogleService-Info.plist`

## Flavors

The app ships three flavors (Android product flavors / iOS schemes), each with its own application ID and config file:

| Flavor | Purpose | Application ID | Config file |
|---|---|---|---|
| `dev`  | Local/dev testing | `com.financialapp.mobile.dev` | `environment/env.dev.json` |
| `uat`  | QA/staging validation | `com.financialapp.mobile.uat` | `environment/env.uat.json` |
| `prod` | Production release | `com.financialapp.mobile` | `environment/env.prod.json` |

Always pass both `--flavor <name>` and the matching `--dart-define-from-file=environment/env.<name>.json` together — the config file supplies `BASE_URL` and `APP_ENV` at build time (`lib/core/config/app_config.dart`). Example:

```bash
flutter run --flavor dev --dart-define-from-file=environment/env.dev.json
flutter build apk --flavor prod --dart-define-from-file=environment/env.prod.json --release
```

## Guidelines
- Every class, method, and non-trivial logic block must have `///` doc comments.
- Widgets must be responsive and adaptive to different screen sizes and orientations.
- Never use `print()`, `debugPrint()`, or `developer.log()` anywhere in the codebase. All diagnostic output must go through `AppLogger` (`lib/core/utils/app_logger.dart`).
- Never boot a simulator/emulator to visually verify UI changes. Rely on `flutter analyze`, code review, and the user's own manual testing instead.
- Backend timestamps are always sent in UTC. When formatting one for display, use the `DateFormat.formatLocal()` extension from `lib/core/utils/date_display_formatter.dart` instead of a bare `.format()`/`.toLocal()` call. This applies only to values with meaningful time-of-day (e.g. `createdAt`, login time, an "as of" snapshot) — pure calendar dates with no time component (e.g. date of birth, a trade date) must NOT be converted, since shifting time zone can change the calendar day.


## Architecture
Follow [.claude/docs/architecture.md](.claude/docs/architecture.md) for reference. Enforcement rules are in [.claude/rules/architecture.md](.claude/rules/architecture.md).

## Folder Structure

The canonical folder structure for `lib/` and `test/` is documented in [.claude/docs/folder-structure.md](.claude/docs/folder-structure.md).

**Rule:** Whenever a new file, folder, component, service, screen, or widget is added or removed, `.claude/docs/folder-structure.md` must be updated in the same change.

**Keep entries minimal.** Each file's inline comment should be a short phrase (under ~10 words) naming what it is, not an exhaustive list of its fields, methods, or parameters — that detail belongs in the file's own doc comments, not in this index. When updating an existing entry, trim it down rather than appending more detail.

## Styling and Theming
Follow [.claude/docs/styling-and-theming.md](.claude/docs/styling-and-theming.md) for color tokens, typography, and dimensions reference. Enforcement rules are in [.claude/rules/styling.md](.claude/rules/styling.md).

## Commit Behavior
Follow [.claude/rules/commit.md](.claude/rules/commit.md).


# Observability Rules

## SDK Containment

- `firebase_crashlytics` may **only** be imported inside
  `lib/core/observability/crashlytics_reporter.dart`.
- All other code reports via `errorReporterProvider` → `ErrorReporter` methods.
- Verify with:
  ```bash
  grep -r "import.*firebase_crashlytics" lib/ --include="*.dart" | grep -v "core/observability/crashlytics_reporter"
  ```
  This must return zero results.

## No Silent Catch Blocks

- Every `catch` block must do at least one of: rethrow, call `AppLogger.e()`,
  or call `reporter.report()`.
- Empty `catch (_) {}` blocks are forbidden. The minimum valid form is:
  ```dart
  on SomeError catch (e, s) {
    AppLogger.e('Unexpected error in Foo', e, s);
    reporter.report(e, stackTrace: s, context: 'Foo.bar');
    rethrow;
  }
  ```

## What to Report vs What to Ignore

Report unexpected application failures:
- `UnknownError` — any error not mapped to a typed `AppError`
- Raw `Exception` or `Error` not derived from `AppError`

Do **not** report expected user-facing flows:
- `NotFoundError` — a fixture with no record for the requested key, shown in the UI
- Form validation errors and business-rule violations

This build has no network, so `NetworkError`, `ServerError`, `UnauthorizedError`
and `ForbiddenError` never occur. The interceptor chain that used to classify
and report them is gone along with the HTTP layer — report from the call site
that knows the failure is unexpected, and only there.

## Fatal vs Non-Fatal

- `reporter.report()` → **non-fatal** → Crashlytics.
- `reporter.reportFatal()` → **fatal** → Crashlytics.
  Call `reportFatal` **only** from the two global handlers in `main.dart`:
  `FlutterError.onError` and `PlatformDispatcher.instance.onError`.

## Tests

- Inject `NullErrorReporter` in all test `ProviderScope` overrides:
  ```dart
  errorReporterProvider.overrideWithValue(NullErrorReporter())
  ```
- Never assert on Crashlytics SDK calls in tests — test the
  business logic outcome, not the reporting side-effect.

## User Identity

- Call `reporter.setUser()` immediately after a successful login.
- Call `reporter.clearUser()` immediately before or after sign-out.
- Both calls are already wired in `AuthNotifier` (`login_provider.dart`).
  Do not add duplicate calls in other layers.

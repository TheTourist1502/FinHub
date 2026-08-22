# Architecture Rules

## Layer Import Restrictions

- `data/` must never import from `presentation/`.
- `domain/` must never import from `data/` or `presentation/` — it defines interfaces that `data/` implements.
- `presentation/` must only import from `domain/`; never import from `data/` directly.
- Shared infrastructure (network, storage, auth) must live in `lib/core/`, never inside a feature folder.

## Session Teardown

- Sign-out must discard the **entire** Riverpod container via `restartSession()`
  (`lib/core/auth/session_root.dart`), not invalidate providers one by one.
  An enumerated list of providers to clear rots silently as features are added,
  and the failure mode is the previous user's data showing to the next one.
- Never call `restartSession()` before `AuthService.clearAuthData()` has
  completed — the rebuilt `AuthNotifier` re-runs its cold-start session check
  and would resolve to `AuthLocked` if credentials were still on disk.
- New feature providers need **no** sign-out bookkeeping. Do not add
  `ref.invalidate` calls to the sign-out path.
- Storage keys are cleared on sign-out by default. A key that must survive
  (device identity, UI preference) goes in `StorageService._sessionExemptKeys`
  with a comment explaining why.
- Anything the **platform** owns rather than the app survives both of the
  above and must be torn down in `SessionCleanupService`
  (`lib/core/auth/session_cleanup_service.dart`): images cached to disk and in
  Flutter's `imageCache`, files staged in the temp directory by the
  picker/cropper plugins, notifications already delivered to the OS tray, and
  the FCM token the backend bound to the outgoing user. Add a step there when
  a new dependency starts caching user data outside `StorageService`.
- Every cleanup step is best-effort and must never fail or block sign-out —
  the session ends whether or not a cache file could be unlinked.

## Riverpod

- Use Riverpod only — never `setState`, `ChangeNotifier`, or BLoC.
  **One carve-out:** `SessionRoot` (`lib/core/auth/session_root.dart`) uses
  `setState`, because it sits above `ProviderScope` — it is the widget whose
  job is destroying the Riverpod container, so Riverpod cannot own its state.
  Do not extend this carve-out to any other widget.
- Use `ref.watch` in `build` methods for reactive data.
- Use `ref.read` in callbacks and notifier methods only.
- `FutureProvider` / `AsyncNotifierProvider` — async data (API calls, storage reads).
- `NotifierProvider` / `StateNotifierProvider` — mutable local or server-backed state.
- `Provider` — derived / computed values only.

## Presentation Layer Hierarchy

- **Screen widget** — top-level route target; owns the `Scaffold`; no business logic.
- **Section widgets** — major layout regions (`ConsumerWidget` or `StatelessWidget`).
- **Feature widgets** — self-contained interactive components with provider connections.
- **Atomic widgets** — pure presentation, prop-driven, no Riverpod dependency.

## Dependency Injection

- Define services and repositories as abstract classes.
- Inject concrete implementations at runtime; inject fakes in tests.

## Testing

- Never mock the database or HTTP layer with fakes that don't reflect real contracts.
- Use in-memory implementations of abstract interfaces instead.

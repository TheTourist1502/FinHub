---
name: project-codebase-state
description: Key codebase facts: what exists, what is empty, core patterns — verified from source as of 2026-05-30
metadata:
  type: project
---

Verified state of the FinancialApp mobile codebase (2026-05-30):

**Fully implemented core infrastructure:**
- `StorageService` (SharedPreferences + FlutterSecureStorage) with `storageServiceProvider`
- `AuthService` — session management (token persistence, getCurrentUser, clearAuthData)
- `SnackbarNotifier` + `snackbarProvider` — context-free toast triggering; consumed by `AppShell`
- `ErrorHandler` + `AppError` sealed class hierarchy
- `DioClient` with `AuthInterceptor` + `ErrorInterceptor` + `PrettyDioLogger`
- `User` model with `UserRole` enum, `isAdvisorOrAbove`, `isSuperuser` helpers
- `AppConstants` + `StorageKeys`
- `AppLocalizations` via flutter_gen; `context.l10n` extension in `l10n.dart`
- `app_en.arb` has full auth key set: authLoginTitle, authLoginSubtitle, authEmailLabel, authEmailHint, authPasswordLabel, authPasswordHint, authLoginButton, validationEmailRequired, validationEmailInvalid, validationPasswordRequired, validationPasswordMinLength

**Skeleton files (empty — only 2 blank lines):**
- `lib/features/auth/data/auth_api.dart`
- `lib/features/auth/data/auth_local_source.dart`
- `lib/features/auth/domain/auth_repository.dart`
- `lib/features/auth/domain/models/auth_token.dart`
- `lib/features/auth/presentation/providers/auth_provider.dart`
- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/widgets/login_form.dart`
- `lib/core/theme/app_colors.dart` (empty)
- `lib/core/theme/app_typography.dart` (empty)
- `lib/core/theme/app_dimensions.dart` (empty)
- `lib/core/routing/app_router.dart` (empty)
- `lib/core/routing/app_routes.dart` (empty)
- `lib/shared/widgets/inputs/app_text_field.dart` (empty)
- `lib/shared/widgets/buttons/primary_button.dart` (empty)
- `lib/shared/widgets/buttons/ghost_button.dart` (empty)
- `lib/shared/widgets/feedback/loading_overlay.dart` (empty)

**Shared widgets fully implemented:**
- `ErrorView` — uses `Iconify(Mdi.alert_circle_outline, ...)` pattern; confirm iconify import: `import 'package:iconify_flutter/icons/mdi.dart'`

**Dependencies available (pubspec confirmed):**
- `flutter_riverpod: ^2.6.1`
- `iconify_flutter: ^0.0.7` (import: `iconify_flutter/icons/mdi.dart`)
- `reactive_forms: ^18.2.2` (unused yet — can use for form validation)
- `go_router: ^17.2.3` (unused yet — routing not wired)
- `shimmer: ^3.0.0`
- `flutter_svg: ^2.0.10`
- `dio: ^5.9.2`

**App shell:**
- `App` (ConsumerWidget) in `app.dart` watches `localeProvider`, renders `AppShell`
- `AppShell` listens to `snackbarProvider` and calls `ScaffoldMessenger` — this is the ONLY legitimate ScaffoldMessenger call
- Router is NOT wired yet — home is a placeholder `Scaffold`

**Why:** Helps future blueprints know what to build vs. what exists.
**How to apply:** When designing new screens, reference existing empty skeleton files as the target files to fill. Do not propose creating new files where skeletons already exist. Flag which empty core files (theme, routing) also need population as dependencies.

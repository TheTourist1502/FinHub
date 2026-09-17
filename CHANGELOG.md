# Changelog

Versions follow semver. `feat` commits bump minor (major post-1.0), `fix` commits bump patch. Starts at 0.0.0.

## [0.18.0] - Unreleased (staged)
feat: add welcome onboarding carousel, gated on the profile fixture's first-time-login flag

- New `lib/features/welcome/` (5 files): `welcome_provider.dart` (active carousel page index, `autoDispose`), `welcome_preferences_provider.dart` (staged country/region draft + `WelcomeSubmitNotifier`), `welcome_screen.dart` (`PageView` host + shared CTA/dots footer), `welcome_hero_page.dart` (page 1), `welcome_personalize_page.dart` (page 2). Reuses `ProfilePreferenceCard` from the Profile feature instead of porting a near-duplicate `WelcomePreferenceCard` — that widget gained an `isValueLoading` shimmer param (the one thing Welcome needed that Profile didn't) rather than forking a second copy.
- Adapted from the reference branch's HTTP version: `WelcomeSubmitNotifier.submit` calls `ProfileRepository.updatePreferences` (the same mock method Profile's preference rows already use) instead of a `PATCH`, and publishes the result via `currentProfileProvider.notifier.applyUpdate` instead of an `AuthNotifier.updateCachedProfile` that doesn't exist on this branch. Dropped the `language` field from the staged draft entirely — Spanish/Hindi are paused, so, exactly like `LanguagePreferenceRow`, the language card always shows "English" and stages nothing; the submitted payload still sends `'language': 'en'` so the fixture write shape matches Profile's. The Top Client Country card stays hidden, matching the reference branch's own current design, not just a porting shortcut.
- Added `ProfileData.isFirstTimeLogin` (reads `preferences.firstTimeLogin`, defaulting `false`) and `assets/images/welcome_page.svg` (ported as-is; `assets/images/` is already a pubspec wildcard, so no pubspec change was needed).
- New `lib/shared/widgets/brand/app_logos.dart`: `AppWordmarkLogo`, extracted from `LoginScreen`'s inline `Iconify(Mdi.finance) + Text` brand block (the styling rules already named this widget as the one to use, but nothing had built it yet). `LoginScreen` now calls it too, so there is exactly one place that draws the brand mark. Not added: `AppLogo` (icon-only) — nothing calls it yet.
- **Routing**: added `AppRoutes.welcome` (`/welcome`, advisor-only policy) and its `GoRoute`. `route_guard.dart` gained `firstTimeLoginResolving` (holds the current route while an advisor's profile fetch, which carries the flag, is still in flight — mirrors the existing `advisorContextRestoring` hold) and `isFirstTimeLogin` (redirects to `/welcome` from any other protected route, checked after the role and advisor-selection gates so those still win). `app_router.dart`'s `redirect` callback now also reads `currentProfileProvider` — only for an advisor session, so a leadership session never triggers its fetch — and `_RouterChangeNotifier` listens to it so the profile landing re-evaluates the redirect the moment the fixture read completes.
- Every fixture in `assets/mock-data/profile/profile.json` already carried `firstTimeLogin: false` (added when the profile feature landed in `0.16.0`, ahead of this stage), so no fixture change was needed to wire the gate up — flip one user's flag to `true` to exercise the carousel.
- Added 15 new ARB keys to `lib/l10n/app_en.arb` **only** (hero title/subtitle/CTA, personalize title/subtitle, advisor-country/region/language card copy, mandatory-fields note, missing-fields error). Regenerated l10n.
- Updated `.claude/docs/folder-structure.md`: dropped the scaffolded `welcome_preference_card.dart` entry (superseded by the `ProfilePreferenceCard` reuse above) and noted the reuse on both features' entries.
- Currency: not applicable — this stage carries no monetary fields.

## [0.17.0] - Unreleased (staged)
feat: add leadership advisor selection, unblocking every leadership-scoped feature

- **This is the stage `data_scope.dart`'s own doc comment was waiting on.** Every leadership-facing feature already ported on this branch — `leadership_commissions`, households/real-time/accounts/dashboard/etc. for a leadership user — has been reading nothing since `DataScope.forUser` hardcoded a leadership user's advisor to `null`. That is fixed here: `DataScope`'s **public API is unchanged** (`DataScope(String? advisorId)` constructor, `.advisorId`, `.isResolved` — all 13 existing call sites, verified by grep, still call `ref.watch(dataScopeProvider)` and compile with zero changes), only `DataScope.forUser` gained a second parameter and `dataScopeProvider` now also watches the new advisor-context provider, so a leadership advisor switch rebuilds every scoped repository exactly as the doc comment already required.
- New `lib/core/advisor_context/advisor_context_provider.dart`: `AdvisorContext` (`resolved`/`restoring`) and `AdvisorContextNotifier`, holding the `financialAdvisorId` a leadership user has picked. Persists via `StorageService.getSecure`/`setSecure` under the already-reserved `StorageKeys.selectedAdvisorId` key. **Not** added to `StorageService._sessionExemptKeys`: a leadership user's advisor selection is session data, not a device/UI preference, and `AuthService.clearAuthData()` already wipes it via `StorageService.clearSession()` on sign-out — a fresh sign-in must not silently inherit the previous session's advisor, so nothing extra was needed to make that happen, and nothing was added to make it survive.
- New `lib/features/leadership_advisor_selection/` (10 files): `domain/models/advisor_option.dart`, `domain/advisor_selection_repository.dart`, `data/leadership_advisor_selection_mock_repository.dart` (rewritten against `MockDataSource.listScoped('profile/advisors.json', 'default')`), 3 presentation providers (`leadership_advisor_selection_provider.dart` — roster/search/filtered list, `selected_advisor_provider.dart` — resolves the full `AdvisorOption` cache-first, `advisor_draft_provider.dart` — pending pick before Continue), `leadership_advisor_selection_screen.dart`, and 3 widgets (app bar, field, sheet). Simplified from the reference branch's version: no cross-feature validation of a restored/selected id against the in-memory advisor list (a ponytail-flagged simplification — a corrupt persisted id just falls through to "no advisor selected" instead of being explicitly rejected; add the list-membership check back if that gap matters later) and no `AdvisorSwitchButton` import (unused in the source it was ported from, and no such widget exists on this branch).
- Added `assets/mock-data/profile/advisors.json` — a fresh fixture (none existed; `0.16.0` explicitly noted "no advisors.json — nothing in the ported profile feature reads it"), keyed `default` over the 10 advisor rows already in `auth/users.json`.
- **Routing**: added `AppRoutes.selectAdvisor` (`/select-advisor`, leadership-only policy) and its `GoRoute`. `route_guard.dart` gained two new optional parameters on `routeGuard` — `advisorContextRestoring` (holds the current route while the persisted selection is still being read off disk, mirroring the existing `AuthUnknown` hold) and `requiresAdvisorSelection` (Rule 6: a leadership user settled on no advisor picked is redirected to `/select-advisor` from any protected route, checked after the role check so a genuine `/access-denied` is never masked by the picker). `app_router.dart`'s `redirect` callback now also reads `advisorContextProvider` to compute both flags, and `_RouterChangeNotifier` listens to it alongside `authNotifierProvider` so picking or switching an advisor re-evaluates the redirect immediately.
- Added 10 new ARB keys to `lib/l10n/app_en.arb` **only** (advisor-picker title/heading/subtitle/field/continue/search/empty/error states). Regenerated l10n.
- Updated `.claude/docs/folder-structure.md`'s mock-data asset list for the new `advisors.json`; the `core/advisor_context/` and `features/leadership_advisor_selection/` entries were already scaffolded ahead and matched the files actually written, so no change was needed there.
- Currency: not applicable — this stage carries no monetary fields.

## [0.16.0] - Unreleased (staged)
feat: add profile screen with avatar upload, preferences and sign-out

- **New native dependencies**: added `image_picker: ^1.2.3` and `image_cropper: ^11.0.0` (avatar photo source + square crop) to `pubspec.yaml`. `local_auth` was deliberately **not** added — the reference branch's own Profile → Security section has no biometric toggle (that lives in an unbuilt app-lock flow), so there is no caller for it yet; add it when that flow actually lands instead of shipping the dependency and a `core/biometric/` service ahead of a consumer.
- **Platform permissions**: `ios/Runner/Info.plist` already carried `NSCameraUsageDescription` / `NSPhotoLibraryUsageDescription` strings referencing an unbuilt service-request address-document OCR flow — reworded both to describe only the profile-photo use case now actually implemented (`"Allows you to take a new profile photo."` / `"Allows you to choose an existing photo for your profile."`). `NSFaceIDUsageDescription` predates this stage (unrelated to `local_auth`, left untouched). `android/app/src/main/AndroidManifest.xml` needed no new entries — camera/media permissions merge automatically from the plugins' own manifests, matching the reference branch's own manifest.
- Added `assets/mock-data/profile/{profile,countries,regions}.json` (`personalization.json` already existed from an earlier stage). `profile.json` is freshly authored — keyed by this branch's actual 13 `auth/users.json` ids (`USR0001`-`USR0013`) rather than the reference branch's fixture users, since this branch's advisor/leadership roster differs. `countries.json`/`regions.json` are reference data, ported as-is. No `advisors.json` — nothing in the ported profile feature reads it.
- New `lib/features/profile/` feature: `domain/models/profile_data.dart` (`ProfileData`/`Country`/`Region`/`RecentLogin`), `domain/profile_repository.dart`, `data/profile_mock_repository.dart` (rewritten against `MockDataSource.readScoped`/`listScoped` keyed by the signed-in user's id, with an in-session edit map standing in for a `PATCH` — no `AuthNotifier` profile cache exists on this branch, so `presentation/providers/profile_provider.dart`'s `currentProfileProvider` owns and fetches the profile itself instead), `presentation/screens/{profile_screen,leadership_profile_screen}.dart`, and 19 presentation widgets (header, avatar + picker sheet, security/login-history section + its bottom sheet, preferences section, country/region/language rows and their selection sheets, shared option/shimmer widgets, tax-jurisdiction card, mandatory-fields note, logout section). Added `preference_card.dart` — a small replacement for the reference branch's `WelcomePreferenceCard`, which lives in a `welcome` feature not yet ported here.
- **Language preference, adapted for paused l10n**: Spanish/Hindi are paused this stage (only `app_en.arb` is active — see `0.14.1`), so `language_preference_row.dart` always shows "English" and its `language_selection_sheet.dart` lists English alone, already selected — tapping it just closes the sheet. No `languagePreferenceProvider`/persistence call exists; there is nothing to persist with one supported locale.
- **Sign-out**: `logout_section.dart` calls `ref.read(authNotifierProvider.notifier).signOut(context)` — the same call every other sign-out entry point uses, which clears the locally-minted session and then discards the whole Riverpod container via `SessionRoot.restartSession`. No new sign-out bookkeeping was added. Styled with `AppTheme.dangerStyle` per the styling rules for a destructive action button (the reference branch's own button predates that rule and used the plain primary style).
- **Routing/entry point**: added `AppRoutes.profile` (`/profile`, default policy — any authenticated role) and a `GoRoute` picking `LeadershipProfileScreen` or `ProfileScreen` by the signed-in user's role. `HomeShellScreen`'s header bar (`lib/features/home/presentation/screens/home_shell_screen.dart`) now renders for **both** roles (previously advisor-only, gated solely by the bell) and gained a tappable avatar pushing `/profile`; the notification bell inside it stays advisor-only, unchanged.
- Added 39 new ARB keys to `lib/l10n/app_en.arb` **only** (profile title/sections/rows/sheets/avatar-picker/snackbars, plus a shared `commonButtonSave`). Regenerated l10n.
- Updated `.claude/docs/folder-structure.md`: the `features/profile/` and `core/biometric/` entries were already scaffolded ahead and matched the files actually written, aside from `preference_card.dart` (new) and two wording fixes; also updated `home_shell_screen.dart`'s description for the header change.
- Currency: not applicable — the profile feature carries no monetary fields.

## [0.15.0] - Unreleased (staged)
feat: add notifications screen and header bell entry point

- Added `assets/mock-data/notifications/{list,count}.json` fixtures (ported as-is; `count.json` mirrors the `GET /v1/notifications/count` contract but is unused by the repository — counts are always derived live from the list, matching the reference branch). Registered `assets/mock-data/notifications/` in `pubspec.yaml`.
- New `lib/features/notifications/` feature: `domain/models` (`notification_count.dart`, `notification_item.dart` — `NotificationCategory` stays in `core/notifications/models/`, already ported in an earlier stage), `domain/notifications_repository.dart`, `data/notifications_mock_repository.dart` (rewritten against `MockDataSource.readEditable`/`saveEditable` rather than the reference branch's bespoke `_source.notifications()`/`markNotificationRead()`/etc. — the fixture is not advisor-scoped (a single `default` list), so no `DataScope` is threaded through, unlike most other mock repositories), `presentation/providers/notifications_provider.dart` (list + unread-count providers, filter/search notifiers), `presentation/screens/notifications_screen.dart`, and 3 presentation widgets (filter chips row, item card, list shimmer).
- Added `lib/shared/widgets/layout/notification_bell_icon.dart` — the header bell with its unread red dot, watching `notificationCountProvider`.
- Wired the entry point: `HomeShellScreen` (`lib/features/home/presentation/screens/home_shell_screen.dart`) now renders a minimal advisor-only header bar hosting the bell, pushing `AppRoutes.notifications` on tap. This stands in for the reference branch's fuller shared header (logo, avatar, overflow menu) — that requires the profile feature, which hasn't landed on this branch yet — and is gated to the advisor role since the unread count has no leadership-scoped equivalent. Added `AppRoutes.notifications` (`/notifications`) with an advisor-only `RoutePolicy` and a pushed `GoRoute` rendering `NotificationsScreen` outside the shell.
- Deferred from this stage, matching the reference branch's own `core/notifications/notification_router.dart` scope split: tapping a row marks it read but does not yet navigate to a target screen (no `NotificationRouter`/`NotificationRouterProvider`/`PushNotificationPayload` exist on this branch), and the notification language is fixed to `'en'` (`notificationsLang` constant) rather than read from an `insights`-feature locale provider that doesn't exist here either.
- Added 11 new ARB keys (title, search hint, filter chips, empty state, overflow menu actions, clear-all confirmation, and 3 error snackbars) to `lib/l10n/app_en.arb` **only** — Spanish and Hindi translation is paused this stage (see `0.14.1`); the `.arb.paused` files were not touched. Regenerated l10n; only `app_localizations.dart` and `app_localizations_en.dart` changed.
- Updated `.claude/docs/folder-structure.md`: the `features/notifications/` entry was already scaffolded and accurate against the files actually written; updated `home_shell_screen.dart`'s description to mention the new header, and corrected the pre-existing `notification_bell_icon.dart` description (no pulse animation, just the unread dot) now that the file exists.
- Currency: not applicable — `NotificationItem` carries no monetary fields.

## [0.14.1] - Unreleased (staged)
chore: pause Spanish and Hindi translation

- Renamed `lib/l10n/app_es.arb` → `app_es.arb.paused` and `app_hi.arb` → `app_hi.arb.paused` so `flutter gen-l10n` no longer picks them up. Content kept as-is (stale against `app_en.arb`) for when translation resumes — just rename back and catch up the keys.
- Deleted the now-orphaned `lib/generated/l10n/app_localizations_es.dart` / `_hi.dart`.
- Trimmed `appSupportedLocales` (`lib/core/l10n/locale_provider.dart`) to `[Locale('en')]` — `MaterialApp.supportedLocales` already derives from `AppLocalizations.supportedLocales`, which now only lists `en`.
- Future stages only need `app_en.arb` updated for new strings until translation resumes.

## [0.14.0] - Unreleased (staged)
feat: add task dashboard

- Added `assets/mock-data/tasks/` fixtures: `summary.json` (overdue/today/upcoming/open rows plus the closed-task count, keyed by advisor id) and `closed.json` (the paged closed-task list, keyed by advisor id). Registered `assets/mock-data/tasks/` in `pubspec.yaml`.
- New `lib/features/task_dashboard/` feature: `domain/models` (`task_item.dart`, `task_dashboard_summary.dart`, `task_dashboard_state.dart`), `domain/task_dashboard_repository.dart`, `data/task_dashboard_mock_repository.dart` (rewritten against `MockDataSource.readScoped` and `DataScope.advisorId`), `presentation/providers/task_dashboard_provider.dart` (summary + closed-task pagination, filter chips, live search, date sort, a live "last updated" ticker), `presentation/screens/task_dashboard_screen.dart`, and 22 presentation widgets covering the grouped/standalone task cards, the pagination footer, and the detail bottom sheet with its header/summary/additional-details sub-widgets.
- Fixed an l10n bug carried over from the reference branch: `TaskItem.dueLabel` used to be a plain-English string ("Due today", "Due 2 days ago") baked into the repository — a `data/` layer concern building UI copy outside `AppLocalizations`. Dropped the field; the relative due label is now computed at display time by `taskDueLabel()` (`task_item_due_row.dart`) from `AppLocalizations`, called from both the list row and the detail header.
- Updated `core/routing/app_routes.dart`: `taskDashboard` now carries an advisor-only `RoutePolicy`, matching the reference branch. Updated `app_router.dart`: `AppRoutes.taskDashboard` now renders `TaskDashboardScreen(initialTaskId: ...)` reading the `taskId` query parameter, in place of `ComingSoonScreen`. The detail view is a `showModalBottomSheet` (`TaskDetailBottomSheet`), not a route — confirmed against the reference branch's own router, which never nests a child route under `/task-dashboard`.
- Added ~40 new ARB keys (title, search hint, filter chips, heading/section labels, empty states, pagination error, "View"/"Close", detail-sheet headings and field labels, "last updated" ticker text, and the relocalised due-date labels) to all 3 ARB files — real Spanish and freshly-translated Hindi, not placeholders — and regenerated l10n.
- Updated `.claude/docs/folder-structure.md` — the `task_dashboard/` entry was already scaffolded and accurate against the files actually written; tightened the `task_search_row.dart` description to drop a mention of a sort toggle that the reference branch already ships as dead, commented-out code.
- Currency parsing: not applicable — `TaskItem` carries no monetary fields.

## [0.13.1] - Unreleased (staged)
chore: remove the Insights tab

- Dropped the never-built Insights bottom-nav tab: `AppRoutes.insights` constant, its `shellBranches` entry, its `ComingSoonScreen` branch in `app_router.dart`, and its `RoleExperience.tabsFor` entry.
- Removed the now-orphaned `navInsights` key from all 3 ARB files and regenerated l10n.
- Removed the aspirational (never-implemented) `insights/` feature and mock-data sections from `.claude/docs/folder-structure.md`.

## [0.13.0] - Unreleased (staged)
feat: add my commissions, commissions detailed view and leadership commissions features

- Added `assets/mock-data/commissions/details.json` (per-account commission transactions, keyed by account id) and `top_accounts.json` (per-advisor top-5 accounts + contributing counts, keyed by advisor id). `history.json` and `summary.json` already existed from the dashboard stage and needed no changes.
- New `lib/features/my_commissions/` feature: `domain/models` (`commission_data.dart`, `commission_summary.dart`), `domain/my_commissions_repository.dart`, `data/my_commissions_mock_repository.dart` (rewritten against `MockDataSource.readScoped`/`listScoped` and `DataScope.advisorId`, with an `isResolved` guard before the top-accounts read since it hard-parses its response), `presentation/providers/my_commissions_provider.dart` (summary provider that reuses the dashboard's already-fetched `commissionHistoryProvider` instead of a second history call, plus a cursor-paginated details notifier), `presentation/screens/my_commissions_screen.dart`, and 7 presentation widgets (trend card, overview tab, KPI tile, top-account row, details tab, summary card, shimmer). `PageAppBar` from the reference branch does not exist on this branch — the screen uses the established `DetailPageBar` instead, matching every other pushed detail screen.
- New `lib/features/commissions_detailed_view/` feature: `domain/models/commission_detail_transaction_card.dart`, `domain/commissions_detailed_view_repository.dart`, `data/commissions_detailed_view_mock_repository.dart` (same `isResolved` guard pattern as `account_detail_view`/`households_detailed_view`), `presentation/providers/commissions_detailed_view_provider.dart` and `commissions_detailed_view_filter_provider.dart` (search/sort state), `presentation/screens/commissions_detailed_view_screen.dart`, and 7 presentation widgets (header card, search field, sort header, transaction list + card, shimmer).
- New `lib/features/leadership_commissions/` screen: `LeadershipCommissionsScreen`, a thin wrapper rendering `MyCommissionsScreen(showAppBar: false)` inside the leadership Commissions shell tab — no own data/domain layer, ported as-is.
- Updated `core/routing/app_routes.dart`: new `commissionDetailedView` route (`/my-commissions/detailed-view/:accountId`), `myCommissions` restricted to the advisor role, and an explicit no-op policy on `/my-commissions/detailed-view` so the ancestor's advisor-only policy doesn't lock leadership out of a route both roles reach. Updated `app_router.dart`: `AppRoutes.myCommissions` now renders `MyCommissionsScreen` and the `commissions` shell branch now renders `LeadershipCommissionsScreen`, both in place of `ComingSoonScreen`; added the pushed `commissionDetailedView` route carrying the tapped `CommissionSummary` as route `extra`.
- Updated `pubspec.yaml`: none needed — `assets/mock-data/commissions/` was already registered as a directory from the dashboard stage.
- Updated generated l10n classes and all 3 ARB files with My Commissions / Commission Detailed View strings, plus a new shared `commonTrnxAmount` key (Spanish and Hindi included).
- Updated `.claude/docs/folder-structure.md` — the entries for these three features were already present and accurate against the files actually written.
- Currency parsing: no `/100` bug found — every model in the reference branch (`CommissionData`, `CommissionSummary`, `CommissionDetailTransactionCard`) already parses `*Cents` fields as-is via `parseNum`, with doc comments noting the fields carry dollar amounts despite the name. No changes were needed.

## [0.12.0] - Unreleased (staged)
feat: add service requests list, detail sheet and success screen

- Added `assets/mock-data/service_requests/` fixtures: `active.json`, `closed.json`, both keyed by advisor id. `accounts.json`, `dropdowns.json` and `form_data.json` were left unported — every reader of them lives in the deferred `new_service_request` / `account_maintainance_sr` sub-flows, not in this feature.
- New `lib/features/service_request/` feature: `domain/models` (`service_request_item.dart`, `service_request_task.dart`, `service_request_type.dart`), `domain/service_request_repository.dart`, `data/service_request_mock_repository.dart` (rewritten against `MockDataSource.listScoped`/`DataScope.advisorId`), `presentation/providers/service_request_provider.dart` (active/closed feeds, filter chips with graceful degradation on a single endpoint failure, live search), `presentation/screens/service_request_list_screen.dart` and `service_request_success_screen.dart`, and 18 presentation widgets covering the standalone request card, the detail bottom sheet with its workflow stepper, and the submission success screen. `service_request_account.dart`, `service_request_form_data.dart` and `service_request_type_display.dart` were left unported — nothing in this feature's scope references them, only the deferred sub-flows do.
- Updated `core/routing/app_routes.dart` (new `serviceRequestSuccess` route) and `app_router.dart`: the Service Requests shell branch now renders `ServiceRequestListScreen` in place of `ComingSoonScreen`, plus a pushed route for the success screen guarded by an `_ExtraArgsGuard` against a lost `extra` payload. `AppRoutes.newServiceRequest` still renders `ComingSoonScreen`, unchanged.
- Updated `pubspec.yaml` to register `assets/mock-data/service_requests/`.
- Updated generated l10n classes and all 3 ARB files with service-request list/detail/success strings (Spanish and Hindi included).
- Updated `.claude/docs/folder-structure.md` for the new files.

## [0.11.0] - Unreleased (staged)
feat: add real-time account picker and real-time detailed view features

- Added `assets/mock-data/real_time/` fixtures: `holdings.json`, `activities.json`, both keyed by account id.
- New `lib/features/real_time/` feature: `domain` models (`real_time_account.dart`, `real_time_account_page.dart`, `real_time_account_list_state.dart`), `domain/real_time_repository.dart`, `data/real_time_mock_repository.dart` (reads the existing `accounts/list.json` fixture rather than a separate dropdown file), `presentation/providers/real_time_provider.dart`, `presentation/screens/real_time_screen.dart`, `presentation/widgets/real_time_shimmer.dart`.
- New `lib/features/real_time_detailed_view/` feature: `domain/models/real_time_detailed_data.dart`, `domain/models/real_time_position.dart`, `domain/models/real_time_transaction.dart`, `domain/real_time_detailed_view_repository.dart`, `data/real_time_detailed_view_mock_repository.dart`, `presentation/providers/real_time_detailed_view_provider.dart`, `presentation/screens/real_time_detailed_view_screen.dart`, and 18 presentation widgets covering the account header card, pill-tab positions/transactions layout, search + sort, empty states, and loading shimmers.
- Updated `core/routing/app_routes.dart` (new `realTimeDetailedView` route, `realTime` restricted to the advisor role) and `app_router.dart`: the Real-Time shell branch now renders `RealTimeScreen` in place of `ComingSoonScreen`, plus a pushed route for the detailed view.
- Updated `pubspec.yaml` to register `assets/mock-data/real_time/`.
- Updated generated l10n classes and all 3 ARB files with real-time picker/detail strings (Spanish and Hindi included).
- Updated `.claude/docs/folder-structure.md` for the new files.

## [0.10.0] - Unreleased (staged)
feat: add households list and household detail view features

- Added `assets/mock-data/households/` fixtures: `list.json`, `detail.json`, `allocation.json`, `accounts.json`, `transactions.json`.
- New `lib/features/households/` feature: `domain` models (`household_detail.dart`, `household_list_state.dart`, `household_page.dart`, `household_sort_field.dart`), `domain/households_repository.dart`, `data/households_mock_repository.dart`, `presentation/providers/households_provider.dart`, screens (`households_list_screen.dart`, `households_shell_screen.dart`), widgets (`household_card.dart`, `households_shimmer.dart`).
- New `lib/features/households_detailed_view/` feature: `domain/models/household_detail_view.dart`, `domain/household_detail_view_repository.dart`, `data/household_detail_view_mock_repository.dart`, `presentation/providers/household_detail_view_provider.dart`, `presentation/screens/household_detail_screen.dart`, widgets (`household_detail_shimmer.dart`, `households_accounts_tab.dart`, `households_asset_allocation.dart`, `households_detail_top_card.dart`, `households_latest_activity_card.dart`, `households_latest_activity_section.dart`, `households_overview_tab.dart`, `households_top_account_row.dart`, `households_top_accounts_card.dart`, `households_transactions_tab.dart`).
- Updated `core/routing/app_routes.dart` (new `householdsDetailedView` route) and `app_router.dart`: the Households branch is now a pathless `ShellRoute` hosting `HouseholdsShellScreen` around both the Households and Accounts pill tabs (replacing the standalone `AccountsScreen` route and the Households `ComingSoonScreen` placeholder), plus a pushed route for the household detail screen.
- Updated `pubspec.yaml` to register `assets/mock-data/households/`.
- Updated generated l10n classes and all 3 ARB files with households/household-detail strings (Spanish and Hindi included).
- Updated `.claude/docs/folder-structure.md` for the new files and corrected stale entries left over from an earlier placeholder pass.

## [0.9.0] - Unreleased (staged)
feat: add view transactions list feature

- Added `assets/mock-data/transactions/all.json` fixture.
- New `lib/features/view_transactions/` feature: `domain` models (`view_transactions_page.dart`, `view_transactions_response.dart`), `domain/view_transactions_repository.dart`, `data/view_transactions_mock_repository.dart`, `presentation/providers/view_transaction_provider.dart`.
- New presentation widgets: `view_transaction_screen.dart`, `view_transaction_empty_sliver.dart`, `view_transaction_filter_chips.dart`, `view_transaction_history_list.dart`, `view_transaction_list_item.dart`, `view_transaction_pagination_sliver.dart`, `view_transaction_scroll_view.dart`, `view_transaction_search_field.dart`, `view_transaction_shimmer.dart`, `view_transaction_sort_header.dart`.
- Updated `app_router.dart` to wire the view-transactions route, and `pubspec.yaml`.
- Fixed `pubspec.yaml`: registered `assets/mock-data/accounts/` and `assets/mock-data/transactions/`. The accounts directory was never declared, so the Day 10/11 fixtures were not bundled at runtime.
- Localisation now ships English, Spanish and Hindi. Added `app_hi.arb` (236 keys) and its generated class; removed `app_pt.arb`, `app_pt_BR.arb` and `app_localizations_pt.dart`.
- Updated `locale_provider.dart` (`appSupportedLocales`) and `api_language.dart` (`en`/`es`/`hi`, dropping the `prt` mapping).
- Updated `.claude/rules/l10n.md` and `.claude/docs/folder-structure.md` for the new locale set.

## [0.8.0] - 79558a6
feat: add transaction detail components and localization updates

- Added `assets/mock-data/accounts/allocation.json`, `aum_history.json`, `detail.json`, `positions.json`, `transactions.json` fixtures.
- New `lib/features/account_detail_view/` feature: domain models (`account_aum_trend.dart`, `account_position.dart`, `account_transaction.dart`, `detailed_account.dart`), `data/account_detail_mock_repository.dart`, `domain/account_detail_repository.dart`, `presentation/providers/account_detail_provider.dart`, screen and widgets (`account_detail_screen.dart`, `account_detail_allocation_section.dart`, `account_detail_overview_tab.dart`, `account_detail_positions_tab.dart`, `account_detail_shimmer.dart`, `account_detail_top_card.dart`, `account_detail_transactions_tab.dart`).
- New `lib/features/view_transactions/domain/models/view_transaction.dart`.
- New shared widgets: `layout/detail_page_bar.dart`, and a `transaction/` family — `transaction_card.dart`, `transaction_date_label.dart`, `transaction_detail_bottom_sheet.dart`, `transaction_detail_cell.dart`, `transaction_detail_financials.dart`, `transaction_detail_header.dart`, `transaction_detail_row.dart`, `transaction_detail_section_label.dart`, `transaction_detail_trade_info.dart`, `transaction_filter.dart`, `transaction_filter_chip.dart`, `transaction_search.dart`, `transaction_sheet_close_button.dart`.
- Updated `core/errors/app_error.dart` (now implements `Exception`), `core/routing/app_router.dart` (account-detail route).
- Updated generated l10n classes and all 4 ARB files with account-detail/transaction strings.

## [0.7.0] - 079b4c5
feat: add account management features including account cards, filter chips, and pagination

- Added `assets/mock-data/accounts/list.json` fixture.
- New `lib/features/accounts/` feature: `domain` models (`account.dart`, `account_list_state.dart`, `account_page.dart`, `account_sort_field.dart`, `accounts_filter_option.dart`), `data/accounts_mock_repository.dart`, `presentation/providers/accounts_provider.dart`.
- New presentation widgets: `accounts_screen.dart`, `account_card.dart`, `accounts_filter_chip_row.dart`, `accounts_list_section.dart`, `accounts_pagination_footer.dart`, `accounts_shimmer.dart`, `accounts_sort_header.dart`.
- Updated `mock_data_source.dart`, `app_router.dart`, `app_routes.dart` to wire the accounts route and data access.
- Updated generated l10n classes and all 4 ARB files (`app_en/es/pt/pt_BR.arb`) with accounts strings.
- Added `test/core/mock/mock_data_source_test.dart`.

## [0.6.0] - 8e24abd
feat: add Spanish and Portuguese localization for dashboard components

- Added mock fixtures: `commissions/history.json`, `commissions/summary.json`, `dashboard/asset_allocation.json`, `dashboard/aum_history.json`, `dashboard/household_insights.json`, `dashboard/recent_transactions.json`, `dashboard/summary.json`, `profile/personalization.json`.
- New `lib/features/dashboard/` data/domain/presentation layers (`dashboard_mock_repository.dart`, `dashboard_repository.dart`, `dashboard_data.dart`, `dashboard_provider.dart`) plus widgets for asset allocation, household insights (list/metric/shimmer/empty states), recent transactions (list/shimmer/view-all), quick actions bar, and AUM/commission trend sections.
- New `lib/features/personalize/` data/domain/provider layer.
- New shared chart widgets: `history_chart_filter_chips.dart`, `history_chart_widget.dart`, `touch_reactive_aum_hero.dart`; new transaction widgets: `transaction_type_avatar.dart`, `transaction_type_config.dart`.
- New `core/notifications/models/notification_category.dart`, `core/utils/chart_filter_utils.dart`, `quick_action_icons.dart`, `quick_action_labels.dart`.
- Updated `data_scope.dart`, `mock_data_source.dart`, `app_router.dart`, `app_routes.dart`, `dashboard_screen.dart`.
- Updated generated l10n classes and all 4 ARB files with dashboard/personalize strings (Spanish and Portuguese included).

## [0.5.0] - dffd88b
feat: add history chart metrics, tooltip, and touch layer

- New `core/utils/asset_class_labels.dart`.
- New shared providers: `connectivity_provider.dart`, `theme_provider.dart`.
- New chart widgets: `allocation_chart_footnote.dart`, `allocation_donut_chart.dart`, `asset_allocation_section.dart`, `history_chart_axis_labels.dart`, `history_chart_canvas.dart`, `history_chart_change_row.dart`, `history_chart_empty_state.dart`, `history_chart_footnote.dart`, `history_chart_geometry.dart`, `history_chart_header.dart`, `history_chart_hero_value.dart`, `history_chart_info.dart`, `history_chart_line_data.dart`, `history_chart_metrics.dart`, `history_chart_tooltip.dart`, `history_chart_touch_layer.dart`.
- New layout/misc widgets: `risk_badge.dart`, `currency_hero_value.dart`, `client_selection_card.dart`, `user_avatar_badge.dart`, `sort_header_row.dart`, `sort_menu_button.dart`, `sort_order.dart` model.
- Updated generated l10n classes and all 4 ARB files.

## [0.4.0] - c983fcc
feat: add multi-select and single-select input components

- Added `assets/images/no_record_found.svg`.
- New `lib/shared/animations/` module: `animations.dart` (master switch), `figure_reveal.dart`, `on_scrolled_into_view.dart`, `pressable.dart`, `settle_in.dart`, `slide_in.dart`, `wipe.dart`, plus `animation.txt` reference.
- New `shared/models/uploaded_document.dart`.
- New feedback/status widgets: `app_error_code.dart`, `app_error_widget.dart`, `error_view.dart`, `no_record_widget.dart`, `pagination_footer.dart`, `status_chip.dart`, `confirm_dialog.dart`, `route_banner.dart`.
- New input widgets: `app_multi_select.dart`, `app_single_select.dart`, `app_pill_tab_bar.dart`, `app_search_field.dart` (+shimmer), `app_select_input_decoration.dart`, `app_select_sheet_shell.dart`, `app_text_field.dart`, `document_picker.dart`, `document_upload_card.dart`, `field_error_text.dart`, `lazy_select_state.dart`, `multi_select_*` and `single_select_*` families, `select_field_label.dart`, `select_option.dart`, `select_sheet_toggle.dart`.
- Updated generated l10n classes and all 4 ARB files.

## [0.3.0] - 929875e
feat: Implement coming soon screens and navigation shell

- New `core/roles/role_experience.dart`, `user_role_label.dart`.
- New `features/home/presentation/screens/`: `coming_soon_screen.dart`, `home_shell_screen.dart`.
- New `shared/widgets/layout/app_bottom_nav.dart`.
- Updated `auth_service.dart`, `session_root.dart`, `data_scope.dart`, `app_router.dart`, `app_routes.dart`, `route_guard.dart`, `storage_service.dart`, `login/domain/models/user.dart`.
- Updated generated l10n classes and all 4 ARB files.

## [0.2.0] - 5203b95
feat: Implement user authentication and dashboard features

- Added `assets/mock-data/auth/users.json`.
- New `core/auth/` module: `auth_service.dart`, `auth_service_provider.dart`, `jwt_decoder.dart`, `session_root.dart`.
- New `core/mock/` module: `data_scope.dart`, `mock_auth.dart`, `mock_data_source.dart`.
- New `core/routing/` module: `app_router.dart`, `app_routes.dart`, `route_guard.dart`.
- New `core/storage/` module: `storage_provider.dart`, `storage_service.dart`.
- New `core/config/app_constants.dart`, `core/l10n/locale_provider.dart`, `core/utils/input_validation.dart`.
- New `features/access_denied/`, `features/dashboard/presentation/screens/dashboard_screen.dart`, `features/login/` (domain models, provider, screen).
- Updated generated l10n classes and all 4 ARB files with auth/dashboard strings.

## [0.1.0] - 0a4d3c5
feat: add localization support and utility functions

- Added `l10n.yaml`.
- New `core/errors/app_error.dart`, `error_handler.dart`.
- New `core/feedback/snackbar_service.dart`.
- New `core/l10n/api_language.dart`, `l10n.dart`.
- New `core/observability/` module: `error_reporter.dart`, `logging_error_reporter.dart`, `null_error_reporter.dart`, `observability_provider.dart`, `provider_error_observer.dart`.
- New `core/utils/`: `account_number_utils.dart`, `app_logger.dart`, `currency_utils.dart`, `date_display_formatter.dart`, `date_sort_utils.dart`, `file_size_formatter.dart`, `json_parsing.dart`, `keyboard_dismiss.dart`, `relative_time_formatter.dart`, plus `formatters/` (`advisor_id_formatter.dart`, `currency_formatter.dart`, `number_formatter.dart`, `percentage_formatter.dart`).
- New `lib/generated/l10n/` (generated `AppLocalizations` classes) and `lib/l10n/` ARB files for en/es/pt/pt_BR.
- Updated `app.dart`, `main.dart`, `pubspec.yaml`/`pubspec.lock`.

## [0.0.3] - b5013e3
Add theme constants for dimensions, typography, and styles

- Added `.claude/docs/styling-and-theming.md`, `.claude/rules/styling.md`.
- New `core/accessibility/`: `responsive_spacing.dart`, `text_scale.dart`.
- New `core/config/theme_config.dart`, `core/motion/app_motion.dart`.
- New `core/theme/`: `app_color_tokens.dart`, `app_colors.dart`, `app_dimensions.dart`, `app_theme.dart`, `app_typography.dart`, `text_style_extensions.dart`.
- Updated `lib/app.dart`.

## [0.0.2] - ee83271
chore: scaffold Flutter app, native shells and tooling

- Standard `flutter create` scaffold: Android (`android/`) and iOS (`ios/`) native projects, launcher icons and splash assets, `Makefile`, `README.md`, `analysis_options.yaml`, `.gitignore`/`.gitattributes`, git hooks (`.githooks/pre-commit`, `pre-push`).
- Added `assets/fonts/` (Inter family), `assets/icons/`.
- Added entry points `lib/app.dart`, `lib/main.dart`, `pubspec.yaml`/`pubspec.lock`.

## [0.0.1] - cbb610d
Initial commit

- Added `LICENSE`.

## [0.0.0]
Start.

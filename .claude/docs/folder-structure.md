# Folder Structure

This document describes the canonical folder structure for the `lib/`, `test/`, and `scripts/` directories.

**IMPORTANT:** Whenever a new file, folder, component, service, screen, or widget is added or removed, this document must be updated in the same change.

**Keep entries minimal.** Each file's inline comment should be a short phrase (under ~10 words) naming what it is, not an exhaustive list of its fields, methods, or parameters — that detail belongs in the file's own doc comments, not in this index. When updating an existing entry, trim it down rather than appending more detail.

---

## lib/

```
lib/
├── main.dart                        # App entry point; SessionRoot > ProviderScope
├── app.dart                         # Root widget, providers, MaterialApp setup
├── firebase_options_dev.dart        # Firebase options — dev
├── firebase_options_uat.dart        # Firebase options — uat
├── firebase_options_prod.dart       # Firebase options — prod
│
├── core/                            # App-wide infrastructure (not feature-specific)
│   ├── advisor_context/
│   │   └── advisor_context_provider.dart # AdvisorContext: selected advisor + restore state
│   ├── biometric/
│   │   ├── biometric_service.dart   # Biometric authentication service
│   │   └── biometric_service_provider.dart # Provider<BiometricService>
│   ├── constants/
│   │   └── api_endpoints.dart       # Central registry of REST API endpoint paths
│   ├── config/
│   │   ├── app_config.dart          # Environment-specific configuration
│   │   ├── app_constants.dart       # App-wide constant values
│   │   └── theme_config.dart        # Compile-time theme mode selector
│   ├── errors/
│   │   ├── app_error.dart           # Typed error classes
│   │   └── error_handler.dart       # Global error handling logic
│   ├── feedback/
│   │   └── snackbar_service.dart    # SnackbarService + snackbarServiceProvider
│   ├── l10n/
│   │   ├── l10n.dart                # Barrel export for AppLocalizations
│   │   ├── locale_provider.dart     # LocaleNotifier — locale state & persistence
│   │   └── api_language.dart        # Locale <-> backend en/es/prt language code mapping
│   ├── motion/
│   │   └── app_motion.dart          # Durations, curves, reduce-motion gate
│   ├── mock/
│   │   ├── mock_data_source.dart    # Reads assets/mock-data; holds session-only edits
│   │   ├── data_scope.dart          # Names the advisor a read is scoped to
│   │   └── mock_auth.dart           # Static-credential sign-in, mints the local JWT
│   ├── observability/
│   │   ├── error_reporter.dart           # ErrorReporter abstract interface
│   │   ├── crashlytics_reporter.dart     # Firebase Crashlytics impl
│   │   ├── null_error_reporter.dart      # No-op impl for tests
│   │   ├── observability_provider.dart   # Provider<ErrorReporter>
│   │   └── provider_error_observer.dart  # ProviderObserver forwarding to ErrorReporter
│   ├── notifications/                    # FCM/push infrastructure (not the in-app notification list)
│   │   ├── fcm_background_handler.dart  # Top-level @pragma('vm:entry-point') background message handler
│   │   ├── fcm_provider.dart            # notificationsRepositoryProvider
│   │   ├── fcm_service.dart             # FCM permission request + token retrieval; logs denied permission to ErrorLogsRepository
│   │   ├── fcm_service_provider.dart    # Provider<FcmService>, notificationPermissionGrantedProvider, LocalNotificationsService, NotificationRouter, PushNotificationController
│   │   ├── local_notifications_service.dart # Renders foreground pushes via flutter_local_notifications
│   │   ├── notification_router.dart     # Routes tapped push notifications to screens by category/deeplink
│   │   ├── local_notifications_repository.dart  # Device-token registration no-op
│   │   ├── notifications_repository.dart # Abstract interface for device-token registration
│   │   ├── push_notification_controller.dart # Wires up onMessage/onMessageOpenedApp/getInitialMessage; called from App
│   │   └── models/
│   │       ├── push_notification_payload.dart # Typed view over an FCM RemoteMessage's data block
│   │       └── notification_category.dart # Shared NotificationCategory enum (push routing + in-app list + personalization)
│   ├── error_logs/                       # Common frontend error reporting, callable from any module
│   │   ├── error_logs_local_repository.dart     # Writes error reports to the device log
│   │   ├── error_logs_repository.dart   # Abstract repository interface
│   │   ├── error_logs_provider.dart     # errorLogsRepositoryProvider
│   │   └── models/
│   │       └── error_log_action.dart    # ErrorLogAction enum
│   ├── routing/
│   │   ├── app_router.dart          # GoRouter configuration
│   │   ├── app_routes.dart          # Named route constants + access policies
│   │   ├── pending_deep_link_provider.dart # Deep link queued while locked; consumed by routeGuard after unlock/login
│   │   ├── route_guard.dart         # Auth/role/advisor-gate redirect logic
│   │   └── route_policy.dart        # RoutePolicy value object
│   ├── auth/
│   │   ├── auth_service.dart            # Session manager — token, expiry, cached profile
│   │   ├── auth_service_provider.dart   # Provider<AuthService>
│   │   ├── jwt_decoder.dart             # Decodes JWT payload claims
│   │   ├── session_cleanup_service.dart # Wipes platform caches on sign-out — images, temp files, tray, FCM token
│   │   ├── session_cleanup_provider.dart # Provider<SessionCleanupService>
│   │   ├── session_root.dart            # Restartable ProviderScope host; container teardown on sign-out
│   ├── roles/
│   │   ├── role_experience.dart         # Per-role tabs, overflow, profile sections, landing route
│   │   └── user_role_label.dart         # Localised display name for a UserRole
│   ├── storage/
│   │   ├── storage_service.dart         # Unified SharedPreferences + secure storage
│   │   └── storage_provider.dart        # Provider<StorageService>
│   ├── theme/
│   │   ├── app_colors.dart          # Primitive color palette
│   │   ├── app_color_tokens.dart    # Adaptive semantic color tokens
│   │   ├── app_dimensions.dart      # Spacing, radius, size tokens
│   │   ├── app_theme.dart           # ThemeData configuration
│   │   └── app_typography.dart      # TextStyle definitions
│   └── utils/
│       ├── account_number_utils.dart # Account number masking helper
│       ├── app_logger.dart          # Centralized logger
│       ├── asset_class_labels.dart  # Asset class display name helpers
│       ├── chart_filter_utils.dart  # Chart filter helpers
│       ├── currency_utils.dart      # Currency formatting helpers (incl. compactDollar)
│       ├── date_display_formatter.dart # DateFormat.formatLocal — UTC-to-local timestamp display
│       ├── file_size_formatter.dart # Byte count to "245 KB" / "1 MB"
│       ├── formatters/             # Display-only value formatters (return String)
│       │   ├── advisor_id_formatter.dart # formatMaskedAdvisorId — masks all but last 4
│       │   ├── currency_formatter.dart   # formatCurrency — currency code + fraction digits
│       │   ├── number_formatter.dart     # formatNumber — grouped decimal
│       │   └── percentage_formatter.dart # formatPercentage — 0–100 value plus "%"
│       ├── input_validation.dart    # Email + max-length field validators
│       ├── json_parsing.dart        # Null-tolerant coercion helpers for API fields
│       ├── keyboard_dismiss.dart    # Drops primary focus and closes the keyboard
│       ├── quick_action_icons.dart  # Quick-action icon lookup
│       ├── quick_action_labels.dart # Quick-action label lookup
│       └── relative_time_formatter.dart # Live "X ago" label formatter
│
├── l10n/                            # ARB translation source files (English is source of truth)
│   ├── app_en.arb                   # English strings
│   ├── app_es.arb                   # Spanish translations
│   ├── app_pt.arb                   # Portuguese base locale
│   └── app_pt_BR.arb                # Brazilian Portuguese translations
│
├── generated/
│   └── l10n/                        # Output of `flutter gen-l10n` — never edit manually
│       ├── app_localizations.dart
│       ├── app_localizations_en.dart
│       └── app_localizations_es.dart
│
├── features/                        # One subfolder per product feature
│   └── <feature_name>/              # e.g. login, dashboard, profile
│       ├── data/
│       │   ├── <feature>_mock_repository.dart  # Reads assets/mock-data via MockDataSource
│       │   └── <feature>_local_source.dart # Local data (secure storage, shared prefs)
│       ├── domain/
│       │   ├── <feature>_repository.dart   # Repository interface / implementation
│       │   └── models/
│       │       └── <model>.dart            # Immutable data models
│       └── presentation/
│           ├── providers/
│           │   └── <feature>_provider.dart   # Riverpod providers (state, notifiers)
│           ├── screens/
│           │   └── <screen>_screen.dart      # Full-page route screens
│           └── widgets/
│               └── <widget>.dart             # Feature-scoped reusable widgets
│
│   # Current features:
│   ├── login/
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── invalid_session_exception.dart  # Thrown when a token names no admissible session
│   │   │       └── user.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── login_provider.dart  # AuthNotifier, authNotifierProvider, currentUserProvider
│   │       └── screens/
│   │           ├── biometric_prompt_screen.dart  # Route /app-lock — biometric re-auth
│   │           └── login_screen.dart  # Username/password form (no SSO)
│   ├── welcome/                          # Route /welcome — post-login onboarding carousel
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── welcome_provider.dart               # Active carousel page state
│   │       │   └── welcome_preferences_provider.dart   # Staged preference draft + submit
│   │       ├── screens/
│   │       │   └── welcome_screen.dart           # PageView host + CTA footer
│   │       └── widgets/
│   │           ├── welcome_hero_page.dart        # Page 1: hero copy + illustration
│   │           ├── welcome_personalize_page.dart # Page 2: preference cards
│   │           ├── welcome_preference_card.dart  # Shared preference row widget
│   │           └── welcome_page_dots.dart        # Pagination indicator
│   ├── dashboard/                        # Home tab content (AUM, transactions, allocation)
│   │   ├── data/
│   │   │   └── dashboard_mock_repository.dart      # DashboardRepository over mock-data
│   │   ├── domain/
│   │   │   ├── dashboard_repository.dart       # Abstract repository interface
│   │   │   └── models/
│   │   │       └── dashboard_data.dart         # Dashboard domain models
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── dashboard_provider.dart     # Dashboard data + filter providers
│   │       ├── screens/
│   │       │   └── dashboard_screen.dart
│   │       └── widgets/
│   │           ├── history_chart_widget.dart              # Generic area chart + filters
│   │           ├── total_aum_trend_section.dart           # AUM chart section
│   │           ├── quick_actions_bar.dart                 # Shortcut action icons
│   │           ├── households_insights_section.dart       # Horizontal household cards
│   │           ├── households_insights_header.dart        # Section title + View all link
│   │           ├── households_insights_list.dart          # Horizontal strip of cards
│   │           ├── households_insights_card.dart          # Single household card
│   │           ├── households_insights_metric.dart        # Label-over-value figure column
│   │           ├── households_insights_empty_card.dart    # No-households empty state
│   │           ├── households_insights_shimmer.dart       # Loading placeholder
│   │           ├── asset_allocation_section.dart          # Donut chart + legend
│   │           ├── total_commissions_trend_section.dart   # Commission chart section
│   │           ├── recent_transactions_section.dart       # Recent transaction list
│   │           ├── recent_transactions_heading.dart       # Section title text
│   │           ├── recent_transactions_list.dart          # Bordered card listing rows
│   │           ├── recent_transactions_card.dart          # Single transaction row
│   │           ├── recent_transactions_view_all_button.dart # Footer action to full history
│   │           ├── recent_transactions_empty_card.dart    # Empty-state card
│   │           └── recent_transactions_shimmer.dart       # Loading placeholder
│   ├── home/                             # Bottom-nav shell (tab 0: Home)
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── home_shell_screen.dart  # StatefulShellRoute host + BottomNavBar
│   │       └── widgets/
│   │           ├── leadership_header_bar.dart # Leadership app bar (no notification bell)
│   │           └── page_bar_options.dart   # Overflow menu popover
│   ├── accounts/                         # Accounts pill tab (Households branch, tab 1)
│   │   ├── data/
│   │   │   └── accounts_mock_repository.dart     # AccountsRepository over mock-data
│   │   ├── domain/
│   │   │   ├── accounts_repository.dart      # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── account.dart              # Account model
│   │   │       ├── account_page.dart         # One paginated API page
│   │   │       ├── account_sort_field.dart   # Sortable columns + API sortBy values
│   │   │       ├── accounts_filter_option.dart # Account-type filter + API filter values
│   │   │       └── account_list_state.dart   # Accumulated pages + pagination flags
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── accounts_provider.dart    # Paginated list + filter/sort/search
│   │       ├── screens/
│   │       │   └── accounts_screen.dart      # Accounts tab content — filters + infinite list
│   │       └── widgets/
│   │           ├── account_card.dart         # Account list-item card
│   │           ├── accounts_filter_chip_row.dart   # Account-type filter chips
│   │           ├── accounts_sort_header.dart       # Count header with sort menu
│   │           ├── accounts_list_section.dart      # Refreshable list + empty/error states
│   │           ├── accounts_pagination_footer.dart # Load-more spinner and retry row
│   │           └── accounts_shimmer.dart     # Loading skeleton (filters + list)
│   ├── account_detail_view/              # Full-screen single-account detail
│   │   ├── data/
│   │   │   └── account_detail_mock_repository.dart  # AccountDetailRepository over mock-data
│   │   ├── domain/
│   │   │   ├── account_detail_repository.dart # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── detailed_account.dart     # Detail + allocation models
│   │   │       ├── account_aum_trend.dart    # AUM history model
│   │   │       ├── account_position.dart     # Holdings/positions model
│   │   │       └── account_transaction.dart  # Recent transaction model
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── account_detail_provider.dart  # Detail + AUM trend providers
│   │       ├── screens/
│   │       │   └── account_detail_screen.dart    # AppBar + top card + 3-tab layout
│   │       └── widgets/
│   │           ├── account_detail_top_card.dart             # Fixed top summary card
│   │           ├── account_detail_shimmer.dart              # Loading skeleton
│   │           ├── account_detail_overview_tab.dart         # Overview tab
│   │           ├── account_detail_positions_tab.dart        # Positions tab
│   │           ├── account_detail_transactions_tab.dart     # Transactions tab
│   │           ├── account_detail_allocation_section.dart   # Donut chart + legend
│   │           └── account_detail_transactions_section.dart # Legacy transaction list
│   ├── households_detailed_view/         # Full-screen single-household detail
│   │   ├── data/
│   │   │   └── household_detail_view_mock_repository.dart  # Household detail over mock-data
│   │   ├── domain/
│   │   │   ├── household_detail_view_repository.dart  # Abstract repository interface
│   │   │   └── models/
│   │   │       └── household_detail_view.dart   # Household detail domain models
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── household_detail_view_provider.dart  # Detail + allocation providers
│   │       ├── screens/
│   │       │   └── household_detail_screen.dart    # AppBar + top card + 3-tab layout
│   │       └── widgets/
│   │           ├── households_detail_top_card.dart      # Fixed top summary card
│   │           ├── household_detail_shimmer.dart        # Loading skeleton
│   │           ├── households_overview_tab.dart         # Overview tab
│   │           ├── households_top_accounts_card.dart    # Top-accounts card with header
│   │           ├── households_top_account_row.dart      # Account row: identity, pill, performance
│   │           ├── households_latest_activity_section.dart # Newest-transaction titled section
│   │           ├── households_latest_activity_card.dart # Latest transaction card
│   │           ├── households_asset_allocation.dart     # Donut chart + legend
│   │           ├── households_accounts_tab.dart         # Accounts tab
│   │           └── households_transactions_tab.dart     # Transactions tab
│   ├── households/                       # Bottom-nav tab 1: Households pill tab
│   │   ├── data/
│   │   │   ├── households_mock_repository.dart   # HouseholdsRepository over mock-data
│   │   │   └── accounts_mock_repository.dart     # AccountsRepository over mock-data
│   │   ├── domain/
│   │   │   ├── households_repository.dart    # Abstract repository interface
│   │   │   ├── accounts_repository.dart      # Abstract repository for account data
│   │   │   └── models/
│   │   │       ├── household_detail.dart     # Household + allocation models
│   │   │       ├── household_page.dart       # One paginated API page
│   │   │       ├── household_sort_field.dart # Sortable columns + API sortBy values
│   │   │       ├── household_list_state.dart # Accumulated pages + pagination flags
│   │   │       └── account_detail.dart       # Account detail model
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── households_provider.dart  # Paginated list + filter/sort/search
│   │       ├── screens/
│   │       │   ├── households_shell_screen.dart  # Shared pill + search chrome for both tabs
│   │       │   └── households_list_screen.dart   # Infinite-scrolling household list
│   │       └── widgets/
│   │           ├── household_card.dart       # Household list-item card
│   │           └── households_shimmer.dart   # Loading skeleton (list rows)
│   ├── service_request/                  # Bottom-nav tab 4: service requests
│   │   ├── data/
│   │   │   └── service_request_mock_repository.dart   # IServiceRequestRepository over mock-data
│   │   ├── domain/
│   │   │   ├── service_request_repository.dart   # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── service_request_type.dart     # Request type enum
│   │   │       ├── service_request_item.dart      # Request list-item model
│   │   │       ├── service_request_task.dart      # Workflow task audit-trail entry
│   │   │       ├── service_request_account.dart   # Client picker account model
│   │   │       └── service_request_form_data.dart # Shared form-data models
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── service_request_provider.dart  # List, search, filter providers
│   │       ├── screens/
│   │       │   ├── service_request_list_screen.dart # Search, filter chips, date-grouped list
│   │       │   └── service_request_success_screen.dart # Success screen after SR submission
│   │       └── widgets/
│   │           ├── service_request_search_row.dart       # Search field
│   │           ├── service_request_filter_chips.dart     # All / Active / Closed chips
│   │           ├── service_request_card.dart             # Request card variants
│   │           ├── service_request_detail_bottom_sheet.dart # Request detail bottom sheet
│   │           ├── service_request_sheet_handle.dart     # Drag-handle pill at sheet top
│   │           ├── service_request_sheet_close_button.dart # Full-width sheet dismiss button
│   │           ├── service_request_status_avatar.dart    # Circular workflow-stage glyph
│   │           ├── service_request_workflow_chip.dart    # Workflow-stage pill, raw API text
│   │           ├── service_request_detail_section.dart   # Titled block wrapper
│   │           ├── service_request_section_divider.dart  # Hairline rule between sections
│   │           ├── service_request_pending_action_section.dart # Pending workflow action
│   │           ├── service_request_workflow_section.dart # Timeline section + step builders
│   │           ├── service_request_success_icon.dart     # Animated glow, ring, check circle
│   │           ├── service_request_success_headline.dart # Submission-confirmed headline
│   │           ├── service_request_success_details.dart  # Record ID label + copy badge
│   │           ├── service_request_success_countdown.dart # Redirect countdown line
│   │           ├── service_request_success_action_button.dart # Go-to-service-requests button
│   │           ├── service_request_workflow_stepper.dart # Workflow status timeline
│   │           ├── service_request_type_display.dart     # Type icon/label lookup
│   │           └── service_request_shimmer.dart          # Single-sweep whole-tab loading skeleton
│   ├── new_service_request/              # Route /service-requests/add — new request form
│   │   ├── data/
│   │   │   └── new_service_request_mock_repository.dart   # Accounts + account-holder list
│   │   ├── domain/
│   │   │   └── new_service_request_repository.dart     # Abstract repository interface
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── new_service_request_provider.dart  # Accounts + account-holder providers
│   │       ├── screens/
│   │       │   └── new_service_request_screen.dart    # Account selection + Continue
│   │       └── widgets/
│   │           ├── new_service_request_form.dart      # Cascading account fields + submit flow
│   │           ├── new_service_request_header.dart     # Static heading and subtitle
│   │           ├── new_service_request_section_label.dart # Uppercase field-group label
│   │           ├── new_service_request_select_styles.dart # Shared select label/hint styles
│   │           ├── new_service_request_account_fields.dart # Composes cascading account fields
│   │           ├── new_service_request_financial_account_field.dart # Account number picker
│   │           ├── new_service_request_account_holder_field.dart # Account holder picker
│   │           ├── new_service_request_holder_error_row.dart # Holder-list error with retry
│   │           ├── new_service_request_submit_button.dart # Full-width Continue button
│   │           ├── new_service_request_type_field.dart # Business-function picker with blockable options
│   │           └── new_service_request_shimmer.dart    # Loading skeleton
│   ├── account_maintainance_sr/          # Route /service-requests/add/account-maintenance
│   │   ├── data/
│   │   │   └── account_maintenance_mock_repository.dart  # Dropdowns, canned submit and OCR
│   │   ├── domain/
│   │   │   ├── account_maintenance_repository.dart    # Repository interface
│   │   │   └── models/
│   │   │       ├── account_maintenance_data.dart      # Section form data models
│   │   │       ├── account_maintenance_dropdown.dart  # Picklist values + dependency filtering
│   │   │       ├── account_maintenance_ocr.dart       # OCR request/result + picklist resolution
│   │   │       ├── account_maintenance_submit_request.dart   # Submit payload + participant/address/attachment
│   │   │       ├── account_maintenance_submit_response.dart  # Submit result, participants, errors
│   │   │       └── dial_code_country.dart             # Phone dial-code country list
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── account_maintenance_provider.dart  # Form state + section notifier, dropdowns
│   │       │   └── account_maintenance_ocr_provider.dart  # Per-section OCR pick/crop/extract state
│   │       ├── screens/
│   │       │   └── account_maintainance_sr_screen.dart  # Account info + collapsible sections
│   │       └── widgets/
│   │           ├── account_maintenance_info_card.dart          # Read-only account info card
│   │           ├── account_maintenance_shimmer.dart            # Loading skeleton
│   │           ├── account_maintenance_accordion_section.dart  # Collapsible category card
│   │           ├── account_maintenance_collapse_transition.dart # Shared expand/collapse animation
│   │           ├── account_maintenance_required_label.dart     # Required field label row
│   │           ├── account_maintenance_contact_information_fields.dart  # Contact info fields
│   │           ├── account_maintenance_phone_fields.dart       # Phone number field
│   │           ├── account_maintenance_dial_code_picker.dart   # Dial-code bottom sheet
│   │           ├── account_maintenance_email_fields.dart       # Email field
│   │           ├── account_maintenance_address_fields.dart     # Address form fields
│   │           ├── account_maintenance_address_form_fields.dart # Ordered column of address inputs
│   │           ├── account_maintenance_address_select.dart      # Picklist-backed address select
│   │           ├── account_maintenance_address_text_row.dart    # Labelled free-text address row
│   │           ├── account_maintenance_address_ocr_button.dart  # Use-OCR action row
│   │           ├── account_maintenance_documents_note_fields.dart # Uploads + confirmation note
│   │           ├── account_maintenance_address_controllers.dart # Address controllers, sync + dispose
│   │           ├── account_maintenance_same_as_legal_checkbox.dart # Same-as-legal-address toggle
│   │           ├── account_maintenance_ocr_source_sheet.dart   # Camera/gallery/PDF choice sheet
│   │           ├── account_maintenance_ocr_review_sheet.dart   # Document preview + extracted fields
│   │           ├── account_maintenance_ocr_sheet_header.dart   # Handle, title, close button
│   │           ├── account_maintenance_ocr_cropped_preview.dart # Cropped document image
│   │           ├── account_maintenance_ocr_pdf_preview.dart    # PDF icon, name and size tile
│   │           ├── account_maintenance_ocr_loading.dart        # Rotating extraction status lines
│   │           ├── account_maintenance_ocr_error_notice.dart   # Inline extraction-failure banner
│   │           ├── account_maintenance_ocr_extracted_fields.dart # Card of recognised fields
│   │           ├── account_maintenance_ocr_field_row.dart      # One label/value review row
│   │           ├── account_maintenance_ocr_resolved_rows.dart  # Picklist-resolved country/state rows
│   │           ├── account_maintenance_ocr_sheet_actions.dart  # Extract/retry/apply button
│   │           ├── account_maintenance_ocr_progress.dart       # Rotating extraction status text
│   │           └── account_maintenance_submit_dialog.dart      # Service request submission confirmation
│   ├── online_access_sr/                 # Routes /service-requests/add/online-access and enabled
│   │   ├── data/
│   │   │   └── online_access_mock_repository.dart     # User-ID rules and canned submit
│   │   ├── domain/
│   │   │   ├── online_access_repository.dart          # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── online_access_data.dart            # On-file email of record model
│   │   │       ├── online_access_submit_request.dart  # Submit payload + edelivery record variants
│   │   │       ├── online_access_submit_response.dart # Submit result + field errors
│   │   │       └── user_id_validation_result.dart     # User ID availability verdict
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── online_access_provider.dart  # Form state + notifier
│   │       │   └── online_access_user_id_check_provider.dart  # User ID availability check state
│   │       ├── screens/
│   │       │   ├── online_access_sr_screen.dart       # Toggle + existing/create form cards
│   │       │   └── online_access_enabled_screen.dart  # Success screen when access already enabled
│   │       └── widgets/
│   │           ├── online_access_shimmer.dart            # Loading skeleton
│   │           ├── online_access_toggle_card.dart        # Existing/new user toggle
│   │           ├── online_access_required_label.dart     # Required field label row
│   │           ├── online_access_existing_user_card.dart # Existing user info form
│   │           ├── online_access_create_form_card.dart    # Create-access form
│   │           ├── online_access_create_form_header.dart  # Const title/subtitle block
│   │           ├── online_access_mobile_number_field.dart # Dial code + number with error line
│   │           ├── online_access_dial_code_button.dart    # Flag/dial-code segment opening picker
│   │           ├── online_access_date_of_birth_field.dart # Read-only DOB field with picker
│   │           ├── online_access_form_text_field.dart     # Labelled input with trailing action
│   │           ├── online_access_field_icon_button.dart   # Circular trailing icon button
│   │           ├── online_access_input_styles.dart        # Shared input text and hint styles
│   │           ├── online_access_user_id_check_sheet.dart # User ID availability bottom sheet
│   │           └── online_access_submit_dialog.dart      # Service request submission confirmation
│   ├── insights/                         # Bottom-nav tab 4: market insights & news feed
│   │   ├── data/
│   │   │   └── insights_mock_repository.dart     # InsightsRepository over mock-data
│   │   ├── domain/
│   │   │   ├── insights_repository.dart          # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── insight_article.dart          # Article model
│   │   │       ├── insight_page.dart             # One paginated API page
│   │   │       ├── insight_list_state.dart       # Accumulated pagination state
│   │   │       └── market_insight_category.dart  # Category filter picklist data
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── insights_provider.dart        # Feed, search, category, content-lang providers
│   │       ├── screens/
│   │       │   ├── insights_screen.dart          # Searchable, paginated feed
│   │       │   └── insight_detail_screen.dart    # Article detail
│   │       ├── widgets/
│   │       │   ├── insight_card.dart                 # Feed list card
│   │       │   ├── insight_category_filter_sheet.dart  # Category/language filter sheet
│   │       │   ├── insights_list_shimmer.dart        # Loading skeleton
│   │       │   ├── insight_detail_header_section.dart    # Detail banner section
│   │       │   ├── insight_detail_content_section.dart   # HTML-rendered body
│   │       │   ├── insight_detail_shimmer.dart       # Loading skeleton
│   │       │   ├── insight_video_section.dart        # YouTube embed section
│   │       │   ├── insight_podcast_section.dart      # Podcast embed section
│   │       │   ├── insight_pdf_link_section.dart     # PDF download card
│   │       │   ├── insight_share_icon_button.dart    # Share-to-OS icon for video/podcast/document
│   │       │   └── embed_webview.dart                # Reusable WebView wrapper
│   │       └── utils/
│   │           ├── insight_embed_url.dart        # Embed URL transforms
│   │           ├── html_preview.dart             # HTML-to-plain-text preview helper
│   │           └── pdf_file_name.dart            # PDF filename-from-URL helper
│   ├── leadership_advisor_selection/     # Leadership-only: pick which FA's data to view
│   │   ├── data/
│   │   │   └── leadership_advisor_selection_mock_repository.dart # Advisor list + one advisor
│   │   ├── domain/
│   │   │   ├── advisor_selection_repository.dart     # Repository interface
│   │   │   └── models/
│   │   │       └── advisor_option.dart               # Selectable advisor (id, email, name)
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── advisor_draft_provider.dart                # Pending FA pick, committed on Continue
│   │       │   ├── leadership_advisor_selection_provider.dart # List, search query, filtered list
│   │       │   └── selected_advisor_provider.dart             # Resolves the selected FA (cache-first)
│   │       ├── screens/
│   │       │   └── leadership_advisor_selection_screen.dart   # FA picker: field + Continue
│   │       └── widgets/
│   │           ├── advisor_selection_app_bar.dart             # Logo (first pick) or back arrow, + sign out
│   │           ├── advisor_selection_field.dart               # "Select FA" trigger showing the pick
│   │           └── advisor_selection_sheet.dart               # Searchable FA sheet (avatar, name, id)
│   ├── leadership_commissions/           # Leadership commissions tab (My Commissions, no app bar)
│   │   └── presentation/
│   │       └── screens/
│   │           └── leadership_commissions_screen.dart
│   ├── leadership_dashboard/             # Leadership home tab (advisor sections, no quick actions)
│   │   └── presentation/
│   │       └── screens/
│   │           └── leadership_dashboard_screen.dart
│   ├── my_commissions/                   # Full-screen commission summary
│   │   ├── data/
│   │   │   └── my_commissions_mock_repository.dart  # Stats + summary over mock-data
│   │   ├── domain/
│   │   │   ├── my_commissions_repository.dart   # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── commission_data.dart          # Top-accounts/stats models
│   │   │       └── commission_summary.dart       # Summary + transaction models
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── my_commissions_provider.dart  # Stats + paginated details providers
│   │       ├── screens/
│   │       │   └── my_commissions_screen.dart    # Trend card + Overview/Details tabs
│   │       └── widgets/
│   │           ├── commission_trend_top_card.dart # Trend chart top card
│   │           ├── commissions_overview_tab.dart # KPI grid + top accounts list
│   │           ├── my_commission_metric_card.dart # KPI tile
│   │           ├── top_accounts_card.dart        # Ranked account row
│   │           ├── my_commissions_details_tab.dart  # Search/filter transaction list
│   │           ├── commission_summary_card.dart  # Single transaction card
│   │           └── my_commissions_shimmer.dart   # Screen + details-list skeletons
│   ├── commissions_detailed_view/        # Full-screen commission detail
│   │   ├── data/
│   │   │   └── commissions_detailed_view_mock_repository.dart  # Per-account commission detail
│   │   ├── domain/
│   │   │   ├── commissions_detailed_view_repository.dart # Abstract repository interface
│   │   │   └── models/
│   │   │       └── commission_detail_transaction_card.dart # Single transaction model
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── commissions_detailed_view_provider.dart # Detail-by-id provider
│   │       │   └── commissions_detailed_view_filter_provider.dart # Search and sort
│   │       ├── screens/
│   │       │   └── commissions_detailed_view_screen.dart   # Detail screen
│   │       └── widgets/
│   │           ├── commission_details_body.dart      # Screen body layout
│   │           ├── commission_details_top_card.dart  # Header summary card
│   │           ├── commission_transactions_list_section.dart # Shimmer, error, loaded swap
│   │           ├── commission_transactions_search_field.dart # Search field owning controller
│   │           ├── commission_transactions_sort_header.dart # Header with sort menu
│   │           ├── commission_transactions_list.dart # Lazy card list
│   │           ├── commission_transaction_card.dart  # Transaction card
│   │           └── commission_transactions_list_shimmer.dart # List-region loading skeleton
│   ├── real_time/                        # Bottom-nav tab 2: Real-Time account selector
│   │   ├── data/
│   │   │   └── real_time_mock_repository.dart   # Account picker over mock-data
│   │   ├── domain/
│   │   │   ├── i_real_time_repository.dart      # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── real_time_account.dart        # Account model
│   │   │       ├── real_time_account_page.dart   # One paginated API page
│   │   │       └── real_time_account_list_state.dart # Accumulated picker list state
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── real_time_provider.dart       # Paginated account list provider
│   │       ├── screens/
│   │       │   └── real_time_screen.dart          # Account selector + live-data notice
│   │       └── widgets/
│   │           └── real_time_shimmer.dart         # Loading skeleton
│   ├── real_time_detailed_view/         # Full-screen real-time detail
│   │   ├── data/
│   │   │   └── real_time_detailed_view_mock_repository.dart  # Holdings + activities
│   │   ├── domain/
│   │   │   ├── i_real_time_detailed_view_repository.dart # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── real_time_detailed_data.dart   # Account meta + positions + transactions
│   │   │       ├── real_time_position.dart        # Intraday holding model
│   │   │       └── real_time_transaction.dart     # Intraday activity model
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── real_time_detailed_view_provider.dart # Detail-by-id provider
│   │       ├── screens/
│   │       │   └── real_time_detailed_view_screen.dart   # Account card + pill tabs
│   │       └── widgets/
│   │           ├── real_time_account_selection_card.dart # Account identity card with swap button
│   │           ├── real_time_detailed_view_shimmer.dart # Loading skeleton
│   │           ├── real_time_positions_tab.dart   # Holdings list, search, sort
│   │           ├── real_time_positions_view_state.dart # Immutable search/sort + filter logic
│   │           ├── real_time_positions_as_of_notice.dart # Prices-as-of-date row
│   │           ├── real_time_positions_sort_header.dart # Holdings count with sort control
│   │           ├── real_time_positions_list.dart   # Lazy builder list of cards
│   │           ├── real_time_positions_card.dart   # Single position card
│   │           ├── real_time_positions_card_footer.dart # Market/close price metrics
│   │           ├── real_time_positions_empty_state.dart # No-matching-positions message
│   │           ├── real_time_transactions_tab.dart # Activity list, search, date groups
│   │           ├── real_time_transactions_view_state.dart # Filter, sort, and group rows
│   │           ├── real_time_transactions_sort_header.dart # Count header with sort control
│   │           ├── real_time_transactions_list.dart # Lazy builder list of rows
│   │           ├── real_time_transactions_row.dart # One row: optional header plus card
│   │           ├── real_time_transactions_date_header.dart # Uppercase snapshot group header
│   │           ├── real_time_transactions_card.dart # Single intraday activity card
│   │           ├── real_time_transactions_summary_row.dart # Ticker, quantity, price row
│   │           ├── real_time_transactions_activity_note.dart # Activity label and description
│   │           └── real_time_transactions_empty_state.dart # Refreshable no-records state
│   ├── profile/                          # Full-screen profile (pushed from header avatar)
│   │   ├── data/
│   │   │   └── profile_mock_repository.dart      # ProfileRepository over mock-data
│   │   ├── domain/
│   │   │   ├── profile_repository.dart           # Abstract repository interface
│   │   │   └── models/
│   │   │       └── profile_data.dart             # Profile response + Country/Region models
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── profile_provider.dart         # Profile + preference notifiers
│   │       ├── screens/
│   │       │   ├── leadership_profile_screen.dart # Leadership profile (language only + sign out)
│   │       │   └── profile_screen.dart           # Reads from cached profile
│   │       └── widgets/
│   │           ├── profile_section_card.dart         # Reusable card container
│   │           ├── profile_row_item.dart              # Icon + title + subtitle row
│   │           ├── profile_header_section.dart        # Name + badges + avatar
│   │           ├── profile_avatar.dart                # Avatar with upload flow
│   │           ├── avatar_picker_bottom_sheet.dart    # Photo source picker sheet
│   │           ├── security_section.dart              # Login history row
│   │           ├── recent_login_bottom_sheet.dart     # Full login history list
│   │           ├── tax_jurisdiction_section.dart      # Licensed geographies chips
│   │           ├── mandatory_fields_note.dart         # Required-field asterisk legend
│   │           ├── preferences_section.dart           # Composes preference rows
│   │           ├── country_preference_row.dart        # Advisor base country row
│   │           ├── top_client_country_preference_row.dart # Top client country row
│   │           ├── region_preference_row.dart         # Region/market-served row
│   │           ├── language_preference_row.dart       # Language selection row
│   │           ├── country_selection_sheet.dart       # Shared country bottom sheet
│   │           ├── region_selection_sheet.dart        # Shared region bottom sheet
│   │           ├── language_selection_sheet.dart      # Shared language bottom sheet
│   │           ├── preference_selection_option.dart   # Shared radio/checkbox option rows
│   │           ├── preference_sheet_shimmer.dart      # Selection sheet loading skeleton
│   │           └── logout_section.dart                # Log Out button + app version
│   ├── presentation_mode/                # Presentation Mode client selector + detail
│   │   ├── data/
│   │   │   └── presentation_dropdown_mock_repository.dart  # Household/account dropdowns
│   │   ├── domain/
│   │   │   ├── presentation_dropdown_repository.dart  # Abstract repository interface
│   │   │   └── models/
│   │   │       └── dropdown_options.dart         # Dropdown kind + paged options
│   │   └── presentation/                 # Detail views reuse other features' widgets
│   │       ├── providers/
│   │       │   └── presentation_mode_provider.dart  # Dropdown + selection providers
│   │       ├── screens/
│   │       │   ├── presentation_mode_screen.dart     # Household/account selector
│   │       │   └── presentation_client_detail_screen.dart  # Client detail view
│   │       └── widgets/
│   │           ├── presentation_header.dart          # Selection screen app bar
│   │           ├── presentation_client_header.dart   # Client detail app bar
│   │           ├── presentation_exit_action.dart     # Exit-mode action + button
│   │           ├── presentation_detail_shimmer.dart  # Client card skeleton + detail shimmer
│   │           └── exit_presentation_dialog.dart     # Exit confirmation modal
│   ├── personalize/                      # Full-screen Personalize route
│   │   ├── data/
│   │   │   └── personalize_mock_repository.dart  # Quick actions + notification toggles
│   │   ├── domain/
│   │   │   ├── personalize_repository.dart       # Abstract repository interface
│   │   │   └── models/
│   │   │       └── personalize_data.dart         # Settings + quick-action models
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── personalize_provider.dart     # Settings AsyncNotifier
│   │       ├── screens/
│   │       │   └── personalize_screen.dart       # Draggable quick-actions + prefs
│   │       └── widgets/
│   │           ├── personalize_app_bar.dart      # Screen app bar
│   │           ├── personalize_app_toggle.dart   # Toggle switch
│   │           ├── personalize_quick_action_tile.dart # Draggable/toggleable row
│   │           ├── personalize_notification_tile.dart # Toggleable preference row
│   │           ├── personalize_reset_dialog.dart # Reset-to-default confirmation
│   │           ├── personalize_shimmer.dart      # Loading skeleton
│   │           └── personalize_footer.dart       # Save/Cancel footer
│   ├── task_dashboard/                   # Full-screen Task Dashboard
│   │   ├── data/
│   │   │   └── task_dashboard_mock_repository.dart  # Tasks over mock-data
│   │   ├── domain/
│   │   │   ├── task_dashboard_repository.dart   # Abstract repository interface + page size
│   │   │   └── models/
│   │   │       ├── task_item.dart               # Task model (API keys) + category enum
│   │   │       ├── task_dashboard_summary.dart  # Summary rows + closed-task total
│   │   │       └── task_dashboard_state.dart    # Accumulated list + closed pagination state
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── task_dashboard_provider.dart # List + closed pagination + filter/search/sort
│   │       ├── screens/
│   │       │   └── task_dashboard_screen.dart   # Search, filters, sliver task list
│   │       └── widgets/
│   │           ├── task_item_card.dart          # Task card variants
│   │           ├── task_item_row_content.dart   # Shared inner row composing the regions
│   │           ├── task_item_icon_circle.dart   # Task avatar wrapper over TaskStatusAvatar
│   │           ├── task_status_avatar.dart      # Circular workflow-stage glyph
│   │           ├── task_workflow_chip.dart      # Workflow-stage pill, raw API text
│   │           ├── task_item_details.dart       # Title/subtitle blocks, status and plain
│   │           ├── task_item_due_row.dart       # Due-date metadata row with icon
│   │           ├── task_item_view_action.dart   # Trailing "View" tap link
│   │           ├── task_item_section_label.dart # Uppercase group heading label
│   │           ├── task_item_open_detail.dart   # Entry point opening the detail sheet
│   │           ├── task_detail_bottom_sheet.dart # Draggable full-detail sheet
│   │           ├── task_detail_header.dart      # Icon circle, account line, title, due date
│   │           ├── task_detail_summary.dart     # Description, pending action, progress
│   │           ├── task_detail_additional_details.dart # Divider, label, metadata grid
│   │           ├── task_detail_grid.dart        # Lays detail cells two per row
│   │           ├── task_detail_cell.dart        # Atomic label-over-value cell
│   │           ├── task_detail_info_section.dart # Atomic heading-over-body block
│   │           ├── task_detail_section_label.dart # Atomic uppercase section heading
│   │           ├── task_sheet_handle.dart       # Atomic drag-handle pill
│   │           ├── task_sheet_close_button.dart # Full-width sheet dismiss button
│   │           ├── task_search_row.dart         # Search field with clear button + sort toggle
│   │           ├── task_filter_chips_row.dart   # Filter chip row
│   │           ├── task_pagination_sliver.dart  # Closed-task load-more spinner and retry
│   │           └── task_dashboard_shimmer.dart  # Loading skeleton for task list
│   ├── view_transactions/                 # Full-screen transaction history
│   │   ├── data/
│   │   │   └── view_transactions_mock_repository.dart  # Transactions over mock-data
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── view_transaction.dart           # Transaction domain model
│   │   │   │   ├── view_transactions_page.dart     # One paginated API page
│   │   │   │   └── view_transactions_response.dart # Accumulated list state
│   │   │   └── view_transactions_repository.dart   # Abstract repository interface
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── view_transaction_provider.dart  # Paginated list + filter/search/sort providers
│   │       ├── screens/
│   │       │   └── view_transaction_screen.dart    # Filter chips, dated list, pull-to-refresh
│   │       └── widgets/
│   │           ├── view_transaction_search_field.dart    # Search bar with shimmer swap
│   │           ├── view_transaction_filter_chips.dart    # All/Trade/Non-Trade chip row
│   │           ├── view_transaction_history_list.dart    # Initial-load gate + pull-to-refresh
│   │           ├── view_transaction_scroll_view.dart     # Composes the slivers
│   │           ├── view_transaction_sort_header.dart     # Count label and sort menu
│   │           ├── view_transaction_list_item.dart       # One row with optional date header
│   │           ├── view_transaction_empty_sliver.dart    # No-records sliver
│   │           ├── view_transaction_pagination_sliver.dart # Load-more spinner and retry
│   │           └── view_transaction_shimmer.dart         # Loading skeleton (chips + list)
│   ├── notifications/                    # Full-screen notification list
│   │   ├── data/
│   │   │   └── notifications_mock_repository.dart  # INotificationsRepository over mock-data
│   │   ├── domain/
│   │   │   ├── notifications_repository.dart  # Abstract repository interface
│   │   │   └── models/
│   │   │       ├── notification_count.dart    # total/unread/read counts model
│   │   │       └── notification_item.dart     # NotificationItem, NotificationBody models (NotificationCategory lives in core/notifications)
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── notifications_provider.dart # List + unread-count providers, filter/search notifiers
│   │       ├── screens/
│   │       │   └── notifications_screen.dart   # List, search, filters, overflow menu
│   │       └── widgets/
│   │           ├── notification_filter_chips_row.dart # Filter chip row (All/Unread)
│   │           ├── notification_item_card.dart         # Single notification row
│   │           ├── notification_permission_banner.dart # Persistent warning banner when OS notification permission is denied
│   │           └── notifications_list_shimmer.dart      # Loading skeleton for the list
│   └── access_denied/                    # Shown when a role check fails
│       └── presentation/
│           └── screens/
│               └── access_denied_screen.dart
│
└── shared/                          # Reusable code used across multiple features
    ├── animations/                   # Reusable animation widgets
    │   ├── animations.dart           # isAnimationApplicable master switch for this folder
    │   ├── settle_in.dart            # Staggered fade-and-rise entrance
    │   ├── figure_reveal.dart        # Replayable eased progress for rolling figures
    │   ├── slide_in.dart             # Ported slideLeft/slideRight keyframes, plus their clip
    │   ├── on_scrolled_into_view.dart # One-shot trigger when a box scrolls into view
    │   ├── wipe.dart                 # Left-to-right clip reveal, driven by a caller's progress
    │   └── pressable.dart            # Press-dip wrapper for tappable cards
    ├── models/
    │   ├── uploaded_document.dart      # Picked-file value type (name/size/base64)
    │   └── sort_order.dart             # ASC/DESC enum for list endpoints
    ├── providers/
    │   ├── connectivity_provider.dart  # Network connectivity state
    │   └── theme_provider.dart         # Theme mode (light/dark) state
    └── widgets/
        ├── account_card/
        │   └── risk_badge.dart         # RiskProfile enum + colour-coded risk pill
        ├── adaptive/
        │   ├── adaptive_button.dart    # Platform-aware button
        │   └── adaptive_switch.dart    # Platform-aware switch
        ├── brand/
        │   └── app_logos.dart     # Theme-aware brand logo widgets
        ├── dialogs/
        │   └── confirm_dialog.dart     # Reusable confirmation dialog with callbacks
        ├── charts/
        │   ├── allocation_chart_footnote.dart # Rounding-disclosure footnote under allocation donuts
        │   ├── allocation_donut_chart.dart    # Shared animated allocation donut + centre label
        │   ├── asset_allocation_section.dart  # Shared allocation bar + legend
        │   ├── history_chart_widget.dart      # HistoryChartSection — filterable area chart
        │   ├── history_chart_header.dart       # Eyebrow label and hero dollar value
        │   ├── history_chart_metrics.dart      # Pure computed geometry and headline numbers
        │   ├── history_chart_footnote.dart     # "Data as of" footnote, commission-aware
        │   ├── history_chart_canvas.dart       # Interactive line chart + axis labels + tooltip
        │   ├── history_chart_geometry.dart     # Pure point/label/tooltip pixel math
        │   ├── history_chart_axis_labels.dart  # Below-chart month/week label band
        │   ├── history_chart_line_data.dart    # Builds the fl_chart LineChartData config
        │   ├── history_chart_touch_layer.dart  # Chart layer owning touch and reveal state
        │   ├── history_chart_tooltip.dart      # Floating touch tooltip bubble
        │   ├── history_chart_hero_value.dart   # Hero dollar value + empty placeholder
        │   ├── history_chart_change_row.dart   # Period-over-period change row
        │   ├── history_chart_filter_chips.dart # Filter chip row
        │   ├── history_chart_empty_state.dart  # No-data chart with month-only axis
        │   ├── history_chart_info.dart         # "Data as of" footnote
        │   └── touch_reactive_aum_hero.dart    # Shared touch-reactive AUM hero + chart
        ├── currency/
        │   └── currency_hero_value.dart  # Formatted hero dollar value
        ├── debug/
        │   └── route_banner.dart       # Dev-only active-route stripe
        ├── feedback/
        │   ├── app_error_code.dart     # AppErrorCode enum — icon/color/copy per error type
        │   ├── app_error_widget.dart   # Configurable full-widget error state + retry button
        │   ├── empty_state_view.dart   # Empty list / no-data placeholder
        │   ├── error_view.dart         # Error state with retry action
        │   ├── loading_overlay.dart    # Full-screen loading indicator
        │   ├── no_record_widget.dart   # Empty-state illustration + message
        │   └── pagination_footer.dart  # Infinite-scroll footer
        ├── inputs/
        │   ├── app_text_field.dart     # Styled text input
        │   ├── app_search_field.dart   # App-wide search box with clear button
        │   ├── app_pill_tab_bar.dart   # Segmented pill tab switcher
        │   ├── app_search_field_shimmer.dart # Loading placeholder for the search box
        │   ├── select_option.dart      # Label/value pair used by both selects
        │   ├── select_field_label.dart # Caption above a select trigger field
        │   ├── lazy_select_state.dart  # Options snapshot plus pagination flags
        │   ├── app_select_input_decoration.dart # Shared select-field InputDecoration
        │   ├── select_sheet_toggle.dart # Tracks sheet-open state for the trigger chevron
        │   ├── app_select_sheet_shell.dart # Sheet chrome, handle, hairline, search
        │   ├── app_single_select.dart  # Bottom-sheet single picker
        │   ├── single_select_sheet.dart # Single-select sheet with search + pagination
        │   ├── single_select_list.dart # Option list with load-more hook
        │   ├── single_select_item.dart # Radio-style option row
        │   ├── single_select_trigger_field.dart # Field opening the single-select sheet
        │   ├── app_multi_select.dart   # Bottom-sheet multi picker
        │   ├── multi_select_sheet.dart # Multi-select sheet owning selection + search
        │   ├── multi_select_list.dart  # Option list plus const separator
        │   ├── multi_select_item.dart  # Self-subscribing checkbox row
        │   ├── multi_select_summary_chip.dart # "N selected" header chip with clear
        │   ├── multi_select_trigger_field.dart # Field opening the multi-select sheet
        │   ├── animated_check_circle.dart # Checkbox glyph with sweep + draw animation
        │   ├── document_upload_card.dart # Upload card with type icon, size, remove
        │   ├── document_picker.dart    # Context-free file pick/validate, callable from a Notifier
        │   ├── field_error_text.dart   # Field error message drawn at zero start inset
        │   └── length_limited_input.dart # Caps typing at a max length and reports the cap
        ├── sort/
        │   ├── sort_header_row.dart    # Responsive label + SortMenuButton row
        │   └── sort_menu_button.dart   # Reusable sort control
        ├── status/
        │   └── status_chip.dart        # Status chip and getIconByLabel lookup
        ├── transaction/
        │   ├── transaction_card.dart              # Shared transaction list-item card
        │   ├── transaction_date_label.dart        # Date header shown on change of day
        │   ├── transaction_detail_bottom_sheet.dart  # Transaction detail sheet
        │   ├── transaction_detail_header.dart     # Avatar, account line, security title
        │   ├── transaction_detail_financials.dart # Price, quantity, amount, asset class
        │   ├── transaction_detail_trade_info.dart # Trade id and date section
        │   ├── transaction_detail_row.dart        # Atomic inline label/value row
        │   ├── transaction_detail_cell.dart       # Atomic stacked label-over-value cell
        │   ├── transaction_detail_section_label.dart # Uppercase section heading
        │   ├── transaction_type_avatar.dart       # Circular transaction-type badge
        │   ├── transaction_sheet_handle.dart      # Draggable sheet grab handle
        │   ├── transaction_sheet_close_button.dart # Full-width sheet dismiss button
        │   ├── transaction_filter.dart            # Trade / non-trade filter logic
        │   ├── transaction_filter_chip.dart       # Reusable filter pill chip
        │   ├── transaction_search.dart            # Multi-field search predicate
        │   └── transaction_type_config.dart       # Type-to-color/label mapping
        └── layout/
            ├── app_page_bar.dart           # Shared app bar for push routes
            ├── detail_page_bar.dart        # Picks advisor vs leadership detail bar
            ├── leadership_detail_page_bar.dart # Detail bar: back + advisor switch + avatar
            ├── advisor_switch_button.dart  # Header pill: selected advisor initials + swap
            ├── notification_bell_icon.dart # Header bell: unread dot + pulse animation
            ├── user_avatar_badge.dart      # Small circular avatar
            ├── app_bottom_nav.dart         # Bottom navigation bar
            ├── app_scaffold.dart           # Base scaffold with consistent chrome
            └── client_selection_card.dart  # "Select Client" card + Change button
```

---

## scripts/

```
scripts/
├── check_env.sh        # Pre-build environment audit
└── gen_mock_data.py    # Regenerates every file under assets/mock-data/
```

---

## assets/mock-data/

The app's data, read by the repositories through `lib/core/mock/`. Each file is a
JSON object keyed by whatever scopes that endpoint — a financial advisor id, an
account id, a household id, or `default` for global data. Regenerate with
`python3 scripts/gen_mock_data.py`.

```
assets/mock-data/
├── auth/               # users.json — the 10 advisor + 3 leadership master list
├── accounts/           # list, detail, allocation, positions, transactions, dropdown, aum_history
├── households/         # list, detail, allocation, accounts, transactions, dropdown
├── dashboard/          # summary, aum_history, asset_allocation, household_insights, recent_transactions
├── transactions/       # all.json — the view-all transactions page
├── commissions/        # history, summary, top_accounts, details
├── real_time/          # holdings.json, activities.json — real-time positions and activity
├── tasks/              # summary.json, closed.json
├── service_requests/   # active, closed, accounts, form_data, dropdowns
├── profile/            # profile, advisors, personalization, countries, regions
├── notifications/      # list.json, count.json
└── insights/           # list.json, categories.json
```

---

## Project root (flavor & environment tooling)

The app ships three build flavors — `dev`, `uat`, `prod` — selected via `--flavor`
plus `--dart-define-from-file`. No `flutter_flavorizr` / `flutter_dotenv`: native flavor
config is maintained by hand and environment values are injected as dart-defines.

```
.vscode/
└── launch.json          # VS Code run configs per flavor

environment/             # gitignored — dart-define-from-file sources (BASE_URL, APP_ENV, IS_DEBUG)
├── env.dev.json
├── env.uat.json
└── env.prod.json

Makefile                 # run/build/lint/format shortcuts
```

Per-flavor Firebase configs live with the native projects: Android
`android/app/src/<flavor>/google-services.json`; iOS `ios/Runner/<flavor>/GoogleService-Info.plist`
(copied to the build-time scratch file `ios/Runner/GoogleService-Info.plist` by each
Xcode scheme's pre-action). Dart-side options are `lib/firebase_options_<flavor>.dart`,
selected in `main.dart` by `APP_ENV`.

`ios/ExportOptions-<flavor>.plist` pins manual signing style + exact provisioning profile
name for `flutter build ipa` — required because Flutter/Xcode's automatic export-time
profile matching can't reliably re-validate entitlements (e.g. Push Notifications) on an
Ad Hoc profile.

---

## test/

The `test/` directory mirrors `lib/` exactly. Each file under `lib/` has a corresponding `_test.dart` file in the same relative path under `test/`.

- **Unit tests** live in `data/` and `domain/` — test business logic and data transformation in isolation.
- **Widget tests** live in `presentation/screens/` and `presentation/widgets/` — test UI rendering and interactions.

```
test/
├── flutter_test_config.dart  # Global test setup hook — silences AppLogger console output
├── support/                  # Shared test doubles (fake JWT builder)
├── core/
│   ├── advisor_context/
│   ├── auth/
│   ├── biometric/
│   ├── config/
│   ├── errors/
│   ├── error_logs/
│   ├── feedback/
│   ├── mock/
│   │   └── mock_data_test.dart   # Every repository against the shipped fixtures
│   ├── notifications/
│   ├── observability/
│   ├── roles/
│   ├── routing/
│   ├── storage/
│   ├── theme/
│   └── utils/
│       └── formatters/
│
├── features/
│   └── <feature_name>/
│       ├── data/              # Unit tests for API clients & local sources
│       ├── domain/            # Unit tests for models & repository logic
│       └── presentation/
│           ├── providers/     # Unit tests for Riverpod providers/notifiers
│           ├── screens/       # Widget tests for full-page screens
│           └── widgets/       # Widget tests for feature-scoped widgets
│
│   # Current features:
│   ├── login/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── welcome/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── dashboard/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── home/
│   │   └── presentation/
│   │       └── screens/
│   ├── accounts/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── account_detail_view/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── households/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── providers/
│   │       └── screens/
│   ├── service_request/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/
│   │   └── presentation/
│   │       └── screens/
│   ├── account_maintainance_sr/
│   │   └── domain/
│   │       └── models/
│   ├── online_access_sr/
│   │   ├── domain/
│   │   │   └── models/
│   │   └── presentation/
│   │       └── providers/
│   ├── commissions_detailed_view/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   ├── presentation_mode/
│   │   └── presentation/
│   ├── access_denied/
│   │   └── presentation/
│   │       └── screens/
│   └── (home, households, service_request mirror the lib/ structure; insights has no tests yet)
│
└── shared/
    ├── animations/                   # Widget tests for the shared animations and their switch
    ├── providers/
    └── widgets/
        ├── adaptive/
        ├── buttons/
        ├── charts/
        ├── feedback/
        ├── inputs/
        └── layout/
```

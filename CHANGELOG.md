# Changelog

Versions follow semver. `feat` commits bump minor (major post-1.0), `fix` commits bump patch. Starts at 0.0.0.

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

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/households/domain/models/household_detail.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
import 'package:finhub/features/households_detailed_view/presentation/providers/household_detail_view_provider.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/household_detail_shimmer.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_accounts_tab.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_detail_top_card.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_overview_tab.dart';
import 'package:finhub/features/households_detailed_view/presentation/widgets/households_transactions_tab.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/layout/detail_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Full-screen detail view for a single household.
///
/// Accessed by navigating to `/households/detailed-view/:householdId`.
/// Renders outside the shell so the bottom navigation bar is hidden.
///
/// Layout:
///  1. [DetailPageBar] — back arrow and title only. No notification bell:
///     leadership reaches this screen and holds no notification permission.
///  2. [HouseholdsDetailTopCard] — fixed household name, total AUM, YTD return.
///  3. [TabBar] — Overview / Accounts / Transactions.
///  4. [TabBarView] — each tab's dedicated content widget.
class HouseholdDetailScreen extends ConsumerWidget {
  /// Creates a [HouseholdDetailScreen].
  ///
  /// [household] is the record the caller already has in hand — from the
  /// households list — passed as the route's `extra`. When present, the top
  /// card and asset-allocation chart render from it immediately and only
  /// member accounts/transactions are fetched; when absent (e.g. a deep
  /// link), the full detail is fetched instead.
  const HouseholdDetailScreen({required this.householdId, this.household, super.key});

  /// Identifier of the household to display.
  final String householdId;

  /// The household passed in from the households list, if any.
  final HouseholdDetail? household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listHousehold = household;
    if (listHousehold != null) {
      return _HouseholdDetailFromListHousehold(householdId: householdId, household: listHousehold);
    }

    final asyncHousehold = ref.watch(householdDetailViewProvider(householdId));

    // Show the shimmer for any fetch that has nothing to display yet: the
    // first load, and every retry from the error state. Written out rather
    // than using `when`, whose `skipLoadingOnRefresh` default would keep the
    // error on screen through a retry.
    //
    // A pull-to-refresh is deliberately excluded — it has loaded content and
    // no error, so the list stays put and the RefreshIndicator spins instead.
    if (asyncHousehold.isLoading && (!asyncHousehold.hasValue || asyncHousehold.hasError)) {
      return const _DetailChrome(body: HouseholdDetailShimmer());
    }

    final error = asyncHousehold.error;
    if (error != null) {
      return _DetailChrome(
        // Retry re-runs the provider's fetch, which sends this build back to
        // the shimmer branch above.
        body: AppErrorWidget(
          errorCode: AppErrorCode.fromAppError(error is AppError ? error : const UnknownError()),
          onRetry: () => ref.invalidate(householdDetailViewProvider(householdId)),
        ),
      );
    }

    return _HouseholdDetailBody(
      household: asyncHousehold.requireValue,
      onRefresh: () => ref.refresh(householdDetailViewProvider(householdId).future),
    );
  }
}

/// Scaffold and app bar shared by the shimmer and error states, so the title
/// and back arrow stay put while only the body swaps.
class _DetailChrome extends StatelessWidget {
  const _DetailChrome({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: DetailPageBar(
      label: context.l10n.householdDetailScreenTitle,
      onPrevious: () => context.pop(),
    ),
    backgroundColor: context.appColors.bgPrimary,
    body: body,
  );
}

/// Builds the [HouseholdDetailView] body from a list-screen [household],
/// fetching only member accounts and transactions — never the
/// household/allocation fixtures [household] already covers.
class _HouseholdDetailFromListHousehold extends ConsumerWidget {
  const _HouseholdDetailFromListHousehold({required this.householdId, required this.household});

  final String householdId;
  final HouseholdDetail household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccountsAndTransactions = ref.watch(householdAccountsAndTransactionsProvider(householdId));

    if (asyncAccountsAndTransactions.isLoading &&
        (!asyncAccountsAndTransactions.hasValue || asyncAccountsAndTransactions.hasError)) {
      return const _DetailChrome(body: HouseholdDetailShimmer());
    }

    final error = asyncAccountsAndTransactions.error;
    if (error != null) {
      return _DetailChrome(
        body: AppErrorWidget(
          errorCode: AppErrorCode.fromAppError(error is AppError ? error : const UnknownError()),
          onRetry: () => ref.invalidate(householdAccountsAndTransactionsProvider(householdId)),
        ),
      );
    }

    final (accounts, transactions) = asyncAccountsAndTransactions.requireValue;
    return _HouseholdDetailBody(
      household: HouseholdDetailView.fromListHousehold(
        household: household,
        accounts: accounts,
        transactions: transactions,
      ),
      onRefresh: () => ref.refresh(householdAccountsAndTransactionsProvider(householdId).future),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded body — tab layout
// ---------------------------------------------------------------------------

class _HouseholdDetailBody extends StatelessWidget {
  const _HouseholdDetailBody({required this.household, required this.onRefresh});

  final HouseholdDetailView household;

  /// Called when the user pulls to refresh in any tab.
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.bgPrimary,
        appBar: DetailPageBar(
          label: l10n.householdDetailScreenTitle,
          onPrevious: () => context.pop(),
        ),
        body: Column(
          children: [
            // ── Fixed top card (always visible) ──────────────────────────
            HouseholdsDetailTopCard(household: household),

            // ── Tab bar ───────────────────────────────────────────────────
            ColoredBox(
              color: Colors.transparent,
              child: TabBar(
                tabs: [
                  Tab(text: l10n.householdDetailTabOverview),
                  Tab(text: l10n.householdDetailTabAccounts),
                  Tab(text: l10n.householdDetailTabTransactions),
                ],
                labelColor: colors.bgBrandNavyBlue,
                unselectedLabelColor: colors.textSecondary,
                indicatorColor: colors.bgBrandNavyBlue,
                dividerColor: colors.borderDefault,
                labelStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // ── Tab content ───────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                children: [
                  HouseholdsOverviewTab(household: household, onRefresh: onRefresh),
                  HouseholdsAccountsTab(
                    accounts: household.accounts,
                    onRefresh: onRefresh,
                  ),
                  HouseholdsTransactionsTab(transactions: household.transactions, onRefresh: onRefresh),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

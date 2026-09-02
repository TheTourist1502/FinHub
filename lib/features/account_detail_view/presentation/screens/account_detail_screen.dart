import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';
import 'package:finhub/features/account_detail_view/presentation/providers/account_detail_provider.dart';
import 'package:finhub/features/account_detail_view/presentation/widgets/account_detail_overview_tab.dart';
import 'package:finhub/features/account_detail_view/presentation/widgets/account_detail_positions_tab.dart';
import 'package:finhub/features/account_detail_view/presentation/widgets/account_detail_shimmer.dart';
import 'package:finhub/features/account_detail_view/presentation/widgets/account_detail_top_card.dart';
import 'package:finhub/features/account_detail_view/presentation/widgets/account_detail_transactions_tab.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/layout/detail_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Full-screen detail view for a single investment account.
///
/// Accessed by navigating to `/accounts/detailed-account-view/:accountId`.
/// Renders outside the shell so the bottom navigation bar is hidden.
/// The layout consists of:
///  1. [DetailPageBar] — back arrow and title only. No notification bell:
///     leadership reaches this screen and holds no notification permission.
///  2. [AccountDetailTopCard] — fixed client name, account type/number, and custodian.
///  3. [TabBar] — Overview / Positions / Transactions.
///  4. [TabBarView] — each tab's dedicated content widget.
class AccountDetailScreen extends ConsumerWidget {
  /// Creates an [AccountDetailScreen].
  const AccountDetailScreen({required this.accountId, super.key});

  /// The identifier of the account to display.
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccount = ref.watch(detailedAccountProvider(accountId));

    // Show the shimmer for any fetch that has nothing to display yet: the
    // first load, and every retry from the error state. Written out rather
    // than using `when`, whose `skipLoadingOnRefresh` default would keep the
    // error on screen through a retry.
    if (asyncAccount.isLoading && (!asyncAccount.hasValue || asyncAccount.hasError)) {
      return const _DetailChrome(body: AccountDetailShimmer());
    }

    final error = asyncAccount.error;
    if (error != null) {
      return _DetailChrome(
        // Retry re-runs the provider's fetch, which sends this build back to
        // the shimmer branch above.
        body: AppErrorWidget(
          errorCode: AppErrorCode.fromAppError(error is AppError ? error : const UnknownError()),
          onRetry: () => ref.invalidate(detailedAccountProvider(accountId)),
        ),
      );
    }

    return _AccountDetailBody(account: asyncAccount.requireValue);
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
      label: context.l10n.accountDetailScreenTitle,
      onPrevious: () => context.pop(),
    ),
    backgroundColor: context.appColors.bgPrimary,
    body: body,
  );
}

// ---------------------------------------------------------------------------
// Loaded body — tab layout
// ---------------------------------------------------------------------------

class _AccountDetailBody extends StatelessWidget {
  const _AccountDetailBody({required this.account});

  final DetailedAccount account;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.bgPrimary,
        // The transactions tab's search field would otherwise shrink the body
        // by the keyboard height, compressing the tab content (and collapsing
        // the empty state's `SliverFillRemaining`) instead of letting the
        // keyboard sit over it. Each scrollable tab pads its own trailing edge
        // by the bottom view inset so nothing stays trapped behind the keyboard.
        resizeToAvoidBottomInset: false,
        appBar: DetailPageBar(
          label: l10n.accountDetailScreenTitle,
          onPrevious: () => context.pop(),
        ),
        body: Column(
          children: [
            // ── Fixed top card (always visible) ──────────────────────────
            AccountDetailTopCard(account: account),

            // ── Tab bar ──────────────────────────────────────────────────
            ColoredBox(
              color: Colors.transparent,
              child: TabBar(
                tabs: [
                  Tab(text: l10n.accountDetailTabOverview),
                  Tab(text: l10n.accountDetailPositions),
                  Tab(text: l10n.accountDetailTabTransactions),
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
                  AccountDetailOverviewTab(account: account),
                  AccountDetailPositionsTab(positions: account.positions),
                  AccountDetailTransactionsTab(transactions: account.transactions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

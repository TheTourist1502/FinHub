import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/accounts/presentation/providers/accounts_provider.dart';
import 'package:finhub/features/accounts/presentation/widgets/account_card.dart';
import 'package:finhub/features/accounts/presentation/widgets/accounts_pagination_footer.dart';
import 'package:finhub/features/accounts/presentation/widgets/accounts_shimmer.dart';
import 'package:finhub/features/accounts/presentation/widgets/accounts_sort_header.dart';
import 'package:finhub/shared/animations/pressable.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pull-to-refresh region holding the sort header and the scrollable
/// [AccountCard] list, including its loading, error and empty states.
class AccountsListSection extends ConsumerWidget {
  /// Creates an [AccountsListSection].
  const AccountsListSection({required this.scrollController, required this.onRefresh, super.key});

  /// Controller owned by the screen, which drives scroll-based pagination.
  final ScrollController scrollController;

  /// Re-fetches the list from the first page.
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(filteredAccountsProvider);
    // The server knows the real match count before every page has loaded, so
    // use `totalCount` when it is paging. In the in-memory mode the search
    // and filter ran locally, so only the visible rows count.
    final listState = ref.watch(accountsNotifierProvider).value;
    final shouldLazyLoadData = listState?.shouldLazyLoadData ?? false;

    return RefreshIndicator(
      onRefresh: onRefresh,
      // Crossfades the skeleton out as the data arrives instead of cutting to
      // it. The three states are distinct widget types, so the switcher
      // detects the change without explicit keys.
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.base),
        child: accountsAsync.when(
          loading: () => const AccountsListShimmer(),
          error: (error, _) => AppErrorWidget(
            errorCode: AppErrorCode.fromAppError(error is AppError ? error : const UnknownError()),
            onRetry: onRefresh,
          ),
          data: (accounts) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: AccountsSortHeader(
                  count: shouldLazyLoadData ? (listState?.totalCount ?? accounts.length) : accounts.length,
                  showSortMenu: accounts.length > 1,
                ),
              ),
              Expanded(
                child: accounts.isEmpty
                    ? const _EmptyAccountsList()
                    : _AccountsListView(accounts: accounts, scrollController: scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Scrollable account list with a trailing pagination footer row.
class _AccountsListView extends StatelessWidget {
  const _AccountsListView({required this.accounts, required this.scrollController});

  final List<Account> accounts;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      // +1 for the pagination footer row.
      itemCount: accounts.length + 1,
      itemBuilder: (context, index) => index == accounts.length
          ? const AccountsPaginationFooter()
          // Rows deal in one at a time as the reader scrolls to them, the
          // same entrance the dashboard's recent-transaction rows use.
          : SettleIn(
              index: index,
              revealOnScroll: true,
              child: Pressable(
                child: AccountCard(account: accounts[index], isLast: index == accounts.length - 1),
              ),
            ),
    );
  }
}

/// Empty state stretched to full height so pull-to-refresh stays available.
class _EmptyAccountsList extends StatelessWidget {
  const _EmptyAccountsList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: constraints.maxHeight, child: const NoRecordWidget()),
        ],
      ),
    );
  }
}

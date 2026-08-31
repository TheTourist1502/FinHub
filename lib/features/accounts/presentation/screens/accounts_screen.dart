import 'dart:async';

import 'package:finhub/features/accounts/domain/models/account_list_state.dart';
import 'package:finhub/features/accounts/presentation/providers/accounts_provider.dart';
import 'package:finhub/features/accounts/presentation/widgets/accounts_filter_chip_row.dart';
import 'package:finhub/features/accounts/presentation/widgets/accounts_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Content of the Accounts pill tab within the Households branch.
///
/// The pill switcher and the search box belong to `HouseholdsShellScreen`
/// above this route, so this widget starts at the filter chips: it owns the
/// list's scroll controller and its pagination only.
class AccountsScreen extends ConsumerStatefulWidget {
  /// Creates an [AccountsScreen].
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  /// Cap on how many matching accounts the auto-lazy-load chain fetches in
  /// the background during a search before the user must scroll for more.
  static const _kMaxAutoFetchedResults = 50;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async => ref.read(accountsNotifierProvider.notifier).refresh();

  /// Loads the next page once the user scrolls past 85 % of the list.
  ///
  /// Skips a non-scrollable list (zero extent) so an empty result set cannot
  /// trigger unbounded auto-fetching.
  void _onScroll() {
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    if (position.maxScrollExtent == 0) return;
    if (position.pixels >= position.maxScrollExtent * 0.85) {
      // Fire-and-forget: loadMore() guards against duplicate in-flight calls.
      unawaited(ref.read(accountsNotifierProvider.notifier).loadMore());
    }
  }

  /// Keeps fetching pages during a search, so a short result set the user
  /// cannot scroll still loads its remaining matches.
  ///
  /// Runs on every state change and stops on any of these:
  /// - the state is not settled [AsyncData] — mid-reload Riverpod still
  ///   exposes the *previous* value, and using it would send the new query
  ///   with the old query's cursor;
  /// - no search is active — then only [_onScroll] paginates;
  /// - a page failed, so an error doesn't retry in a tight loop;
  /// - [_kMaxAutoFetchedResults] rows are already loaded. [_onScroll] still
  ///   loads more past that point, uncapped.
  ///
  /// Never fires in the in-memory mode: the cursor is `null` there, so
  /// [AccountListState.hasMore] is `false`.
  void _maybeContinueSearchLazyLoad(AsyncValue<AccountListState> next) {
    if (next is! AsyncData<AccountListState>) return;
    final state = next.value;
    final searchQuery = ref.read(accountsSearchQueryProvider).trim();
    final withinAutoFetchBudget = state.accounts.length < _kMaxAutoFetchedResults;
    if (searchQuery.isNotEmpty &&
        state.hasMore &&
        !state.isLoadingMore &&
        state.paginationError == null &&
        withinAutoFetchBudget) {
      unawaited(ref.read(accountsNotifierProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(accountsNotifierProvider, (previous, next) => _maybeContinueSearchLazyLoad(next));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AccountsFilterChipRow(),
        const SizedBox(height: 10),
        Expanded(
          child: AccountsListSection(
            scrollController: _scrollController,
            onRefresh: _onRefresh,
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/features/households/domain/models/household_list_state.dart';
import 'package:finhub/features/households/domain/models/household_sort_field.dart';
import 'package:finhub/features/households/presentation/providers/households_provider.dart';
import 'package:finhub/features/households/presentation/widgets/household_card.dart';
import 'package:finhub/features/households/presentation/widgets/households_shimmer.dart';
import 'package:finhub/shared/animations/pressable.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:finhub/shared/widgets/feedback/pagination_footer.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Scrollable list of all filtered + sorted households.
///
/// Sits inside [HouseholdsShellScreen] which owns the search bar and tab
/// switcher. This widget renders the "ALL HOUSEHOLDS" header row and the
/// infinite-scrolling list of [HouseholdCard] items loaded via cursor-based
/// pagination.
class HouseholdsListScreen extends ConsumerStatefulWidget {
  /// Creates a [HouseholdsListScreen].
  const HouseholdsListScreen({super.key});

  @override
  ConsumerState<HouseholdsListScreen> createState() => _HouseholdsListScreenState();
}

class _HouseholdsListScreenState extends ConsumerState<HouseholdsListScreen> {
  /// Cap on how many matching households the auto-lazy-load chain will fetch
  /// in the background during an active search before requiring the user to
  /// scroll for further pages (see [_maybeContinueSearchLazyLoad]).
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

  /// Triggers [HouseholdsNotifier.loadMore] when the user has scrolled past
  /// 85 % of the list.
  ///
  /// Skips when [maxScrollExtent] is zero (list fits on screen without
  /// scrolling) to prevent unbounded auto-fetching when search results are
  /// empty.
  void _onScroll() {
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    if (position.maxScrollExtent == 0) return;
    if (position.pixels >= position.maxScrollExtent * 0.85) {
      // Fire-and-forget: loadMore() guards against duplicate in-flight calls.
      unawaited(ref.read(householdsNotifierProvider.notifier).loadMore());
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
  /// - a page failed, so an error doesn't retry in a tight loop (the user
  ///   retries from [PaginationFooter]);
  /// - [_kMaxAutoFetchedResults] rows are already loaded, so a broad term
  ///   doesn't chase the whole result set. [_onScroll] still loads more past
  ///   that point, uncapped.
  ///
  /// Never fires in the in-memory mode: the cursor is `null` there, so
  /// [HouseholdListState.hasMore] is `false`.
  void _maybeContinueSearchLazyLoad(AsyncValue<HouseholdListState> next) {
    if (next is! AsyncData<HouseholdListState>) return;
    final state = next.value;
    final searchQuery = ref.read(householdsSearchQueryProvider).trim();
    final withinAutoFetchBudget = state.households.length < _kMaxAutoFetchedResults;
    if (searchQuery.isNotEmpty &&
        state.hasMore &&
        !state.isLoadingMore &&
        state.paginationError == null &&
        withinAutoFetchBudget) {
      unawaited(ref.read(householdsNotifierProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final householdsAsync = ref.watch(filteredHouseholdsProvider);

    ref.listen(householdsNotifierProvider, (previous, next) => _maybeContinueSearchLazyLoad(next));

    final listState = ref.watch(householdsNotifierProvider.select((s) => s.value));
    final isLoadingMore = listState?.isLoadingMore ?? false;
    final paginationError = listState?.paginationError;

    return RefreshIndicator(
      onRefresh: () => ref.read(householdsNotifierProvider.notifier).refresh(),
      // Crossfades the skeleton out as the data arrives instead of cutting to
      // it. The three states are distinct widget types, so the switcher
      // detects the change without explicit keys.
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.base),
        child: householdsAsync.when(
          data: (households) {
            // The server knows the real match count before every page has
            // loaded, so use `totalCount` when it is paging. In the in-memory
            // mode the search ran locally, so only the visible rows count.
            final headerCount = (listState?.shouldLazyLoadData ?? false)
                ? (listState?.totalCount ?? households.length)
                : households.length;

            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header row: count label + sort button
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SortHeaderRow(
                      label: context.l10n.householdsAllLabel(headerCount).toUpperCase(),
                      sortMenuButton: households.length > 1
                          ? SortMenuButton(
                              fields: [
                                SortField(id: HouseholdSortField.aum.id, label: l10n.dashboardAumLabel),
                                SortField(id: HouseholdSortField.name.id, label: l10n.commonName),
                              ],
                              activeFieldId: ref.watch(householdsSortFieldProvider).id,
                              isDescending: ref.watch(householdsSortDescendingProvider),
                              onChanged: (id, {required descending}) {
                                ref.read(householdsSortFieldProvider.notifier).field = HouseholdSortField.fromId(id);
                                ref.read(householdsSortDescendingProvider.notifier).descending = descending;
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                if (households.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: NoRecordWidget(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 16),
                    sliver: SliverList.builder(
                      // +1 for the pagination footer row.
                      itemCount: households.length + 1,
                      itemBuilder: (context, index) {
                        if (index == households.length) {
                          return PaginationFooter(
                            isLoadingMore: isLoadingMore,
                            hasError: paginationError != null,
                            errorLabel: l10n.householdsPaginationError,
                            onRetry: () => ref.read(householdsNotifierProvider.notifier).loadMore(),
                          );
                        }
                        // Rows deal in one at a time as the reader scrolls to
                        // them, the same entrance the dashboard's
                        // recent-transaction rows use.
                        return SettleIn(
                          index: index,
                          revealOnScroll: true,
                          child: Pressable(child: HouseholdCard(household: households[index])),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
          loading: () => const HouseholdsListShimmer(),
          error: (error, _) => AppErrorWidget(
            errorCode: AppErrorCode.fromAppError(error is AppError ? error : const UnknownError()),
            onRetry: () => ref.read(householdsNotifierProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

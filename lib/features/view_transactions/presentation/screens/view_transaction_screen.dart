import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/view_transactions/presentation/providers/view_transaction_provider.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_filter_chips.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_history_list.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_search_field.dart';
import 'package:finhub/shared/widgets/layout/detail_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Full-screen transaction history screen pushed outside the bottom-nav shell.
///
/// Displays a search bar, trade / non-trade filter chips, and an
/// infinite-scrolling list of transaction rows with date headers, loaded via
/// cursor-based pagination. Supports pull-to-refresh and graceful
/// pagination-error recovery.
class ViewTransactionScreen extends ConsumerStatefulWidget {
  /// Creates a [ViewTransactionScreen].
  const ViewTransactionScreen({super.key});

  @override
  ConsumerState<ViewTransactionScreen> createState() => _ViewTransactionScreenState();
}

/// Owns the scroll controller and everything that decides when to fetch the
/// next page; the visible pieces are separate widgets that watch their own
/// providers.
class _ViewTransactionScreenState extends ConsumerState<ViewTransactionScreen> {
  /// How many extra pages the screen may fetch on its own to fill the viewport
  /// after a chip or search narrows the list.
  ///
  /// Filtering runs over the pages loaded so far, so a narrow filter can leave
  /// too few rows to scroll — and [_onScroll] can never fire on a list that
  /// doesn't overflow. Without this the user would be stranded on a blank
  /// screen even though later pages hold matching rows. Capped so a filter
  /// that matches nothing walks a few pages rather than draining the whole
  /// history.
  static const int _maxAutoFillPages = 3;

  late final ScrollController _scrollController;

  /// Auto-fill fetches spent since the filter or query last changed.
  int _autoFillPages = 0;

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

  /// Fetches the next page when the current list is too short to scroll.
  ///
  /// Runs after layout so the scroll position has real content dimensions.
  /// Each completed page re-emits the list and schedules another check, so
  /// this walks forward one page at a time until the list overflows the
  /// viewport, the server runs out of pages, or [_maxAutoFillPages] is spent.
  void _maybeAutoFill() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_autoFillPages >= _maxAutoFillPages) return;

    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent > 0) return;

    final listState = ref.read(viewTransactionsNotifierProvider).value;
    if (listState == null || !listState.hasMore) return;
    if (listState.isLoadingMore || listState.paginationError != null) return;

    _autoFillPages++;
    // Fire-and-forget: loadMore() guards against duplicate in-flight calls.
    unawaited(ref.read(viewTransactionsNotifierProvider.notifier).loadMore());
  }

  /// Triggers [ViewTransactionsNotifier.loadMore] once the user has scrolled
  /// past 85 % of the list.
  ///
  /// Skips when [ScrollPosition.maxScrollExtent] is zero — a list that fits on
  /// screen has no scroll to react to. That case belongs to [_maybeAutoFill],
  /// which fetches against a hard cap so an empty filter result can't fetch
  /// unbounded.
  void _onScroll() {
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    if (position.maxScrollExtent == 0) return;
    if (position.pixels >= position.maxScrollExtent * 0.85) {
      // Fire-and-forget: loadMore() guards against duplicate in-flight calls.
      unawaited(ref.read(viewTransactionsNotifierProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    // A new filter or query gets its own auto-fill budget: the rows it needs
    // may sit on pages an earlier, wider filter never had to reach for.
    ref
      ..listen(viewTransactionFilterProvider, (_, _) => _autoFillPages = 0)
      ..listen(viewTransactionSearchProvider, (_, _) => _autoFillPages = 0)
      // Every change to the rendered list — a new page, a new filter, a new
      // sort — is a chance the viewport is now under-filled, so re-check once
      // the frame that shows it has been laid out.
      ..listen(
        filteredViewTransactionsProvider,
        (_, _) => WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoFill()),
      );

    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      appBar: DetailPageBar(
        label: context.l10n.viewTransactionsTitle,
        onPrevious: () => context.pop(),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ViewTransactionSearchField(),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ViewTransactionFilterChips(),
          ),
          const SizedBox(height: 8),
          Expanded(child: ViewTransactionHistoryList(scrollController: _scrollController)),
        ],
      ),
    );
  }
}

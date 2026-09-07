import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:finhub/features/my_commissions/presentation/providers/my_commissions_provider.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/commission_summary_card.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/my_commissions_shimmer.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:finhub/shared/widgets/feedback/pagination_footer.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Details tab content for the My Commissions screen.
///
/// Provides a search field (matches the account-detail transactions tab
/// pattern) and renders the filtered list of [CommissionSummary] cards
/// below, lazily loading further pages via [commissionsDetailsNotifierProvider]
/// as the user scrolls.
class MyCommissionsDetailsTab extends ConsumerStatefulWidget {
  /// Creates a [MyCommissionsDetailsTab].
  const MyCommissionsDetailsTab({super.key});

  @override
  ConsumerState<MyCommissionsDetailsTab> createState() => _MyCommissionsDetailsTabState();
}

class _MyCommissionsDetailsTabState extends ConsumerState<MyCommissionsDetailsTab> with AutomaticKeepAliveClientMixin {
  /// Keeps the tab mounted while the other tab is shown, so the autoDispose
  /// pagination provider (and the scroll/search state) survives a tab switch.
  @override
  bool get wantKeepAlive => true;

  String _query = '';
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Triggers `loadMore` when the user has scrolled past 85% of the list.
  ///
  /// Skips when [maxScrollExtent] is zero (list fits on screen without
  /// scrolling) to prevent unbounded auto-fetching when search results are
  /// empty.
  void _onScroll() {
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    if (position.maxScrollExtent == 0) return;
    if (position.pixels >= position.maxScrollExtent * 0.85) {
      unawaited(ref.read(commissionsDetailsNotifierProvider.notifier).loadMore());
    }
  }

  List<CommissionSummary> _filter(List<CommissionSummary> transactions) {
    if (_query.isEmpty) return transactions;
    final q = _query.toLowerCase();
    return transactions.where((tx) {
      return tx.accountHolderName.toLowerCase().contains(q) || (tx.accountNumber?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final detailsAsync = ref.watch(commissionsDetailsNotifierProvider);

    final listState = ref.watch(commissionsDetailsNotifierProvider.select((s) => s.value));
    final isLoadingMore = listState?.isLoadingMore ?? false;
    final paginationError = listState?.paginationError;

    return Column(
      children: [
        // ── Search bar ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: AppSearchField(
            hintText: l10n.myCommissionsSearchHint,
            controller: _searchController,
            // Also fires with '' when the built-in clear button empties the
            // field, so the filter resets with it.
            onChanged: (v) => setState(() => _query = v),
          ),
        ),

        const SizedBox(height: 16),

        // ── Transaction list ─────────────────────────────────────────────
        Expanded(
          child: detailsAsync.when(
            data: (state) {
              final filtered = _filter(state.transactions);

              return RefreshIndicator(
                onRefresh: () => ref.read(commissionsDetailsNotifierProvider.notifier).refresh(),
                child: filtered.isEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) => ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: constraints.maxHeight,
                              child: const NoRecordWidget(),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        // +1 for the pagination footer row.
                        itemCount: filtered.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (_, i) {
                          if (i == filtered.length) {
                            return PaginationFooter(
                              isLoadingMore: isLoadingMore,
                              hasError: paginationError != null,
                              errorLabel: l10n.myCommissionsPaginationError,
                              onRetry: () => ref.read(commissionsDetailsNotifierProvider.notifier).loadMore(),
                            );
                          }
                          final tx = filtered[i];
                          return CommissionSummaryCard(
                            transaction: tx,
                            onViewDetails: () => context.push(
                              AppRoutes.commissionDetailedView.replaceFirst(
                                ':accountId',
                                tx.accountId!,
                              ),
                              extra: tx,
                            ),
                          );
                        },
                      ),
              );
            },
            loading: () => const CommissionsDetailsListShimmer(),
            error: (e, _) => Center(child: Text('$e')),
          ),
        ),
      ],
    );
  }
}

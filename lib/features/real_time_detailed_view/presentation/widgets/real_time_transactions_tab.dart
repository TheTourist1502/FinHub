import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_transaction.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_detailed_view_shimmer.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_as_of_notice.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_empty_state.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_list.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_sort_header.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_view_state.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Transactions tab content for the Real-Time Detailed View screen.
///
/// Owns the loading, error, and loaded rendering of its own request — its
/// fetch starts only once the Positions request has finished, so this tab can
/// still be shimmering while Positions is already on screen.
class RealTimeTransactionsTab extends StatefulWidget {
  /// Creates a [RealTimeTransactionsTab].
  const RealTimeTransactionsTab({
    required this.transactions,
    required this.onRefresh,
    required this.onRetry,
    super.key,
  });

  /// The activities request backing this tab.
  final AsyncValue<List<RealTimeTransaction>> transactions;

  /// Called when the user pulls to refresh; should reload the account's data.
  final Future<void> Function() onRefresh;

  /// Called by the error state's retry button.
  final VoidCallback onRetry;

  @override
  State<RealTimeTransactionsTab> createState() => _RealTimeTransactionsTabState();
}

class _RealTimeTransactionsTabState extends State<RealTimeTransactionsTab> {
  bool _sortDescending = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = widget.transactions;

    // First load (or a retry after failure) — nothing to show yet.
    if (!async.hasValue && async.isLoading) return const RealTimeTabContentShimmer();

    if (!async.hasValue) {
      return AppErrorWidget(
        errorCode: AppErrorCode.fromAppError(async.error is AppError ? async.error! as AppError : const UnknownError()),
        onRetry: widget.onRetry,
      );
    }

    final transactions = async.requireValue;
    final rows = buildRealTimeTransactionRows(
      transactions: transactions,
      query: _searchQuery,
      sortDescending: _sortDescending,
      // The snapshot timestamp lives in the sort header, so no row carries
      // its own date header.
      dateHeaderOf: (_) => null,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          AppSearchField(
            hintText: context.l10n.realTimeSearchTransactions,
            controller: _searchController,
            enabled: transactions.isNotEmpty,
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const RealTimePositionsAsOfNotice(),
          const SizedBox(height: 12),
          RealTimeTransactionsSortHeader(
            count: rows.length,
            isDescending: _sortDescending,
            onSortChanged: ({required descending}) => setState(() => _sortDescending = descending),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: widget.onRefresh,
              child: async.isLoading
                  ? const RealTimeCardListShimmer()
                  : rows.isEmpty
                  ? const RealTimeTransactionsEmptyState()
                  : RealTimeTransactionsList(rows: rows),
            ),
          ),
        ],
      ),
    );
  }
}

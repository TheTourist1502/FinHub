import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_detailed_view_shimmer.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_as_of_notice.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_empty_state.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_list.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_sort_header.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_view_state.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Positions tab content for the Real-Time Detailed View screen.
///
/// Owns the loading, error, and loaded rendering of its own request, so a
/// holdings failure stays inside this tab instead of blanking the screen.
/// Lays out like the transactions tab: search field, delay notice, and sort
/// header stay put while only the card list scrolls.
class RealTimePositionsTab extends StatefulWidget {
  /// Creates a [RealTimePositionsTab].
  const RealTimePositionsTab({
    required this.positions,
    required this.onRefresh,
    required this.onRetry,
    super.key,
  });

  /// The positions request backing this tab.
  final AsyncValue<List<RealTimePosition>> positions;

  /// Called when the user pulls to refresh; should reload the account's data.
  final Future<void> Function() onRefresh;

  /// Called by the error state's retry button.
  final VoidCallback onRetry;

  @override
  State<RealTimePositionsTab> createState() => _RealTimePositionsTabState();
}

class _RealTimePositionsTabState extends State<RealTimePositionsTab> {
  final TextEditingController _searchController = TextEditingController();

  /// Search + sort selection, held in a notifier so a change rebuilds only
  /// the sort header and the list rather than the whole tab.
  final ValueNotifier<RealTimePositionsViewState> _view = ValueNotifier(const RealTimePositionsViewState());

  @override
  void dispose() {
    _searchController.dispose();
    _view.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) => _view.value = _view.value.copyWith(query: query);

  void _onSortChanged(String id, {required bool descending}) =>
      _view.value = _view.value.copyWith(sortField: id, sortDescending: descending);

  @override
  Widget build(BuildContext context) {
    final async = widget.positions;

    // First load (or a retry after failure) — nothing to show yet.
    if (!async.hasValue && async.isLoading) return const RealTimeTabContentShimmer();

    if (!async.hasValue) {
      return AppErrorWidget(
        errorCode: AppErrorCode.fromAppError(async.error is AppError ? async.error! as AppError : const UnknownError()),
        onRetry: widget.onRetry,
      );
    }

    final positions = async.requireValue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          AppSearchField(
            hintText: context.l10n.realTimeSearchPositions,
            controller: _searchController,
            onChanged: _onQueryChanged,
            enabled: positions.isNotEmpty,
          ),
          const RealTimePositionsAsOfNotice(),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<RealTimePositionsViewState>(
              valueListenable: _view,
              builder: (context, view, _) {
                final filtered = view.apply(positions);
                return Column(
                  children: [
                    RealTimePositionsSortHeader(count: filtered.length, view: view, onChanged: _onSortChanged),
                    const SizedBox(height: 8),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: widget.onRefresh,
                        child: async.isLoading
                            ? const RealTimeCardListShimmer()
                            : filtered.isEmpty
                            ? const RealTimePositionsEmptyState()
                            : RealTimePositionsList(positions: filtered),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

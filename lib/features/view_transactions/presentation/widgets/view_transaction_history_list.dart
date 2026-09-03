import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/view_transactions/presentation/providers/view_transaction_provider.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_scroll_view.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_shimmer.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initial-load gate for the transaction list: shimmer, error, or content,
/// wrapped in pull-to-refresh.
class ViewTransactionHistoryList extends ConsumerWidget {
  /// Creates a [ViewTransactionHistoryList].
  const ViewTransactionHistoryList({required this.scrollController, super.key});

  /// Controller the screen uses to drive infinite-scroll pagination.
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(filteredViewTransactionsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(viewTransactionsNotifierProvider.notifier).refresh(),
      color: context.appColors.interactiveDefault,
      // Crossfades the skeleton out as the data arrives instead of cutting to
      // it. The states are distinct widget types, so the switcher detects the
      // change without explicit keys.
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.base),
        child: async.when(
          loading: ViewTransactionListShimmer.new,
          error: (err, _) => Center(
            child: ErrorView(
              error: err is AppError ? err : const UnknownError(),
              onRetry: () => ref.invalidate(viewTransactionsNotifierProvider),
            ),
          ),
          data: (transactions) => ViewTransactionScrollView(
            scrollController: scrollController,
            transactions: transactions,
          ),
        ),
      ),
    );
  }
}

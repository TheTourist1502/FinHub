import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/view_transactions/presentation/providers/view_transaction_provider.dart';
import 'package:finhub/shared/widgets/feedback/pagination_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom-of-list sliver showing the load-more spinner, the pagination error
/// with retry, or nothing.
///
/// Watches the pagination flags itself so a spinner appearing never rebuilds
/// the rows above it.
class ViewTransactionPaginationSliver extends ConsumerWidget {
  /// Creates a [ViewTransactionPaginationSliver].
  const ViewTransactionPaginationSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(viewTransactionsNotifierProvider.select((s) => s.value));

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      sliver: SliverToBoxAdapter(
        child: PaginationFooter(
          isLoadingMore: listState?.isLoadingMore ?? false,
          hasError: listState?.paginationError != null,
          errorLabel: context.l10n.viewTransactionsPaginationError,
          onRetry: () => ref.read(viewTransactionsNotifierProvider.notifier).loadMore(),
        ),
      ),
    );
  }
}

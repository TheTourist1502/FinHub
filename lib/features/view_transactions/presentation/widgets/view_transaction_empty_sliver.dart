import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/view_transactions/presentation/providers/view_transaction_provider.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Empty-state sliver rendered when the filtered list has no rows.
///
/// Stays blank while another page is in flight, so a filter whose matches sit
/// further down the history doesn't flash "no records" as those pages arrive.
class ViewTransactionEmptySliver extends ConsumerWidget {
  /// Creates a [ViewTransactionEmptySliver].
  const ViewTransactionEmptySliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoadingMore = ref.watch(
      viewTransactionsNotifierProvider.select((s) => s.value?.isLoadingMore ?? false),
    );

    if (isLoadingMore) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverFillRemaining(
      // hasScrollBody: false lets the sliver take exactly the leftover viewport
      // height, so the widget centres in the space below the header rather than
      // at the top of an otherwise empty list.
      hasScrollBody: false,
      child: Center(child: NoRecordWidget(message: context.l10n.viewTransactionsEmpty)),
    );
  }
}

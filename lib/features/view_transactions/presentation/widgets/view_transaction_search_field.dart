import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/view_transactions/presentation/providers/view_transaction_provider.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Search bar for the transaction history screen.
///
/// Owns the initial-load shimmer swap so the screen above it never rebuilds
/// when the first page arrives.
class ViewTransactionSearchField extends ConsumerWidget {
  /// Creates a [ViewTransactionSearchField].
  const ViewTransactionSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(viewTransactionsNotifierProvider.select((s) => s.isLoading));

    return isLoading ? const AppSearchFieldShimmer() : const _SearchInput();
  }
}

/// The text field itself, writing each keystroke to
/// [viewTransactionSearchProvider].
class _SearchInput extends ConsumerWidget {
  const _SearchInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppSearchField(
      hintText: context.l10n.viewTransactionsSearchHint,
      onChanged: (value) {
        ref.read(viewTransactionSearchProvider.notifier).query = value;
      },
    );
  }
}

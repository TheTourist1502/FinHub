import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/view_transactions/presentation/providers/view_transaction_provider.dart';
import 'package:finhub/features/view_transactions/presentation/widgets/view_transaction_shimmer.dart';
import 'package:finhub/shared/widgets/transaction/transaction_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Horizontal All / Trade / Non-Trade chip row bound to
/// [viewTransactionFilterProvider], with the initial-load shimmer swap.
class ViewTransactionFilterChips extends ConsumerWidget {
  /// Creates a [ViewTransactionFilterChips].
  const ViewTransactionFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(viewTransactionsNotifierProvider.select((s) => s.isLoading));

    return isLoading ? const ViewTransactionFilterChipsShimmer() : const _ChipRow();
  }
}

/// Scrollable row of the three filter chips.
class _ChipRow extends StatelessWidget {
  const _ChipRow();

  @override
  Widget build(BuildContext context) {
    // The scroll view shrink-wraps to the chips' width, so without the
    // [Align] the parent column centres the whole row on wide screens.
    return const Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(filter: TransactionFilter.all),
            SizedBox(width: 8),
            _FilterChip(filter: TransactionFilter.trade),
            SizedBox(width: 8),
            _FilterChip(filter: TransactionFilter.nonTrade),
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped chip that selects one [TransactionFilter].
///
/// Watches only whether its own [filter] is the active one, so selecting a
/// chip repaints the chips and nothing above them.
class _FilterChip extends ConsumerWidget {
  const _FilterChip({required this.filter});

  /// Filter this chip applies when tapped.
  final TransactionFilter filter;

  String _label(AppLocalizations l10n) => switch (filter) {
    TransactionFilter.all => l10n.transactionFilterAllTransactions,
    TransactionFilter.trade => l10n.transactionFilterTrade,
    TransactionFilter.nonTrade => l10n.transactionFilterNonTrade,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(viewTransactionFilterProvider.select((active) => active == filter));
    final colors = context.appColors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref.read(viewTransactionFilterProvider.notifier).filter = filter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? colors.bgBrandNavyBlue : colors.surfaceDefault,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: isActive ? colors.bgBrandNavyBlue : colors.borderDefault),
          boxShadow: isActive
              ? const [BoxShadow(color: AppColors.cardShadow, blurRadius: 1, offset: Offset(0, 1))]
              : null,
        ),
        child: Text(
          _label(context.l10n),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? colors.textOnAccent : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

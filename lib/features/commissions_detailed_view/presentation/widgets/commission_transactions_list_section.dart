import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/providers/commissions_detailed_view_provider.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_transactions_list.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_transactions_list_shimmer.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_transactions_sort_header.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetch-dependent region of the Commission Detailed View: the shimmer while
/// the transactions load, a retryable error state when the fetch fails, and the
/// loaded list otherwise.
///
/// Kept as its own [ConsumerWidget] so a fetch state change rebuilds only this
/// region, leaving the header card and search field above it untouched.
class CommissionTransactionsListSection extends ConsumerWidget {
  /// Creates a [CommissionTransactionsListSection] for [accountId].
  const CommissionTransactionsListSection({required this.accountId, super.key});

  /// Account whose commission transactions are being fetched.
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Crossfades the skeleton out as the rows arrive instead of cutting to
    // them, the same swap the insights feed and the transaction history use.
    // The three states are distinct widget types, so the switcher detects the
    // change without explicit keys.
    return AnimatedSwitcher(
      duration: AppMotion.duration(context, AppMotion.base),
      child: _stateFor(context, ref),
    );
  }

  /// The branch currently on screen: shimmer, error, or the loaded list.
  Widget _stateFor(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(commissionDetailedViewProvider(accountId));

    // Show the shimmer for any fetch that has nothing to display yet: the
    // first load, and every retry from the error state. Written out rather
    // than using `when`, whose `skipLoadingOnRefresh` default would keep the
    // error on screen through a retry.
    if (asyncTransactions.isLoading && (!asyncTransactions.hasValue || asyncTransactions.hasError)) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CommissionTransactionsListShimmer(),
      );
    }

    final error = asyncTransactions.error;
    if (error != null) {
      return AppErrorWidget(
        errorCode: AppErrorCode.fromAppError(error is AppError ? error : const UnknownError()),
        // Retry re-runs the provider's fetch, which sends this build back to
        // the shimmer branch above.
        onRetry: () => ref.invalidate(commissionDetailedViewProvider(accountId)),
      );
    }

    return _LoadedTransactions(accountId: accountId);
  }
}

/// Loaded content: sort header above the transaction list.
///
/// Neither child watches [commissionDetailedViewProvider], so once the fetch
/// has landed a search or sort change rebuilds only the child that cares.
class _LoadedTransactions extends StatelessWidget {
  const _LoadedTransactions({required this.accountId});

  /// Account whose sort header and transaction list are rendered.
  final String accountId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CommissionTransactionsSortHeader(accountId: accountId),
        ),
        const SizedBox(height: 10),
        Expanded(child: CommissionTransactionsList(accountId: accountId)),
      ],
    );
  }
}

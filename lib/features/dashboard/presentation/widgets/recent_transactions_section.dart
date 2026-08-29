import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_heading.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_list.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_shimmer.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Re-exported so importers of this section keep seeing [RecentTransactionCard].
export 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_card.dart';

/// Dashboard section showing recent account transactions with icons,
/// household attribution, relative dates, and colour-coded amounts.
///
/// Loads data via [recentTransactionsProvider]; the leaves own their own
/// theme and l10n reads so a provider update rebuilds as little as possible.
class RecentTransactionsSection extends ConsumerWidget {
  /// Creates a [RecentTransactionsSection].
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(recentTransactionsProvider);
    final transactions = asyncData.hasValue ? asyncData.requireValue : const <RecentTransaction>[];

    // Crossfades the skeleton out as the data arrives instead of cutting to
    // it. The two states are distinct widget types, so the switcher detects
    // the change without explicit keys.
    return AnimatedSwitcher(
      duration: AppMotion.duration(context, AppMotion.base),
      child: asyncData.isLoading
          ? const RecentTransactionsShimmer()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The list is newest-first, so the first row carries the
                // snapshot date.
                RecentTransactionsHeading(
                  asOfDate: transactions.isEmpty ? null : transactions.first.asOfDate,
                ),
                const SizedBox(height: 12),
                if (asyncData.hasError)
                  const ErrorView(error: UnknownError())
                else
                  RecentTransactionsList(transactions: transactions),
              ],
            ),
    );
  }
}

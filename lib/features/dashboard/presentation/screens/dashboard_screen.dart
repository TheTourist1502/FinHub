import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/features/dashboard/presentation/widgets/asset_allocation_section.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_section.dart';
import 'package:finhub/features/dashboard/presentation/widgets/quick_actions_bar.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_transactions_section.dart';
import 'package:finhub/features/dashboard/presentation/widgets/total_aum_trend_section.dart';
import 'package:finhub/features/dashboard/presentation/widgets/total_commissions_trend_section.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/animations/slide_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home tab content screen — the FA dashboard.
///
/// Layout (top to bottom):
/// 1. [TotalAumTrendSection] — owns its white bottom-rounded card.
/// 2. 1 px separator gap.
/// 3. Gray main section (`bgPrimary`) with 16 px horizontal padding:
///    - [QuickActionsBar]
///    - [HouseholdsInsightsSection]
///    - [AssetAllocationSection]
///    - [TotalCommissionsTrendSection] — owns its white rounded card with shadow.
///    - [RecentTransactionsSection]
///
/// The screen opens with the AUM hero rolling into place and its chart drawing
/// a step behind, both owned by [TotalAumTrendSection]. Everything below is
/// revealed on scroll rather than on mount: an entrance three screens down
/// would otherwise be over before the reader ever reached it. The two sections
/// usually already on screen at first paint keep a small stagger between them;
/// the rest each settle in on their own as they clear the fold, so the
/// staggering is done by the reader's scrolling rather than by an index.
///
/// Each section manages its own loading shimmer and error state — no global
/// shimmer is shown. Pull-to-refresh invalidates all providers simultaneously
/// using [Future.wait] with `eagerError: false` so every provider completes
/// before the spinner dismisses, regardless of partial failures.
///
/// The app bar and bottom navigation are provided by the home shell screen.
class DashboardScreen extends ConsumerWidget {
  /// Creates a [DashboardScreen].
  const DashboardScreen({super.key});

  /// Invalidates all dashboard providers simultaneously and waits for all to
  /// settle before dismissing the [RefreshIndicator] spinner.
  Future<void> _onRefresh(WidgetRef ref) async {
    try {
      await Future.wait([
        ref.refresh(dashboardSummaryProvider.future),
        ref.refresh(faAumHistoryProvider.future),
        ref.refresh(commissionSummaryProvider.future),
        ref.refresh(commissionHistoryProvider.future),
        ref.refresh(faAllocationsProvider.future),
        ref.refresh(householdsProvider.future),
        ref.refresh(recentTransactionsProvider.future),
        ref.refresh(quickActionsProvider.future),
      ]);
    } on Object catch (e, s) {
      AppLogger.e('Dashboard refresh failed', e, s);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final showQuickActions = ref
        .watch(quickActionsProvider)
        .maybeWhen(
          data: (actions) => actions.isNotEmpty,
          orElse: () => true,
        );

    return ColoredBox(
      color: colors.bgPrimary,
      child: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(ref),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TotalAumTrendSection(),
                const SizedBox(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showQuickActions) ...[
                        // Rises the full height of the bar rather than
                        // [SettleIn]'s 12 px: it is the one row of actions on a
                        // screen of figures, and the livelier entrance is what
                        // separates it from the balances above and below.
                        const SlideInClip(
                          direction: SlideDirection.up,
                          child: SlideIn(
                            direction: SlideDirection.up,
                            revealOnScroll: true,
                            child: QuickActionsBar(),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      const SettleIn(index: 1, revealOnScroll: true, child: HouseholdsInsightsSection()),
                      const SizedBox(height: 16),
                      const SettleIn(revealOnScroll: true, child: AssetAllocationSection()),
                      const SizedBox(height: 16),
                      const SettleIn(revealOnScroll: true, child: TotalCommissionsTrendSection()),
                      const SizedBox(height: 24),
                      const SettleIn(revealOnScroll: true, child: RecentTransactionsSection()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_detailed_data.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_transaction.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/providers/real_time_detailed_view_provider.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_account_selection_card.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_detailed_view_shimmer.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_tab.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_tab.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/inputs/app_pill_tab_bar.dart';
import 'package:finhub/shared/widgets/layout/detail_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Full-screen real-time detail view for a single financial account.
///
/// Accessed via `/real-time/:accountId`. Renders outside the shell so the
/// bottom navigation bar is hidden. Shows a pill tab switcher between
/// Positions and Transactions, both fed from live mock data.
class RealTimeDetailedViewScreen extends ConsumerWidget {
  /// Creates a [RealTimeDetailedViewScreen].
  const RealTimeDetailedViewScreen({required this.accountId, super.key});

  /// The identifier of the account to display.
  final String accountId;

  /// Reloads both tabs. Invalidating positions is enough — the transactions
  /// provider watches it and re-runs once it settles.
  Future<void> _onRefresh(WidgetRef ref) async {
    ref.invalidate(realTimePositionsProvider(accountId));
    await ref.read(realTimeTransactionsProvider(accountId).future).catchError((_) => <RealTimeTransaction>[]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Crossfades the page-wide skeleton out as the data arrives instead of
    // cutting to it. The three states are distinct widget types, so the
    // switcher sees the change without explicit keys — and a refresh keeps
    // rendering the same [_DetailBody], so it updates in place rather than
    // replaying the entrance.
    return _DetailChrome(
      body: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.base),
        child: _body(ref),
      ),
    );
  }

  /// The page's current state: skeleton, error, or the loaded body.
  Widget _body(WidgetRef ref) {
    final account = ref.watch(realTimeAccountProvider(accountId));
    final positions = ref.watch(realTimePositionsProvider(accountId));
    final transactions = ref.watch(realTimeTransactionsProvider(accountId));

    // The account header cannot render without its metadata, so that request
    // alone drives the whole-page states.
    if (!account.hasValue) {
      if (account.isLoading) return const RealTimeDetailedViewShimmer();
      return AppErrorWidget(
        errorCode: AppErrorCode.fromAppError(
          account.error is AppError ? account.error! as AppError : const UnknownError(),
        ),
        onRetry: () => ref.invalidate(realTimeAccountProvider(accountId)),
      );
    }

    // Both tabs still on their first load — one page-wide shimmer instead of
    // two tab-sized ones.
    if (!positions.hasValue && positions.isLoading && !transactions.hasValue && transactions.isLoading) {
      return const RealTimeDetailedViewShimmer();
    }

    return _DetailBody(
      data: account.requireValue,
      positions: positions,
      transactions: transactions,
      onRefresh: () => _onRefresh(ref),
      onRetryPositions: () => ref.invalidate(realTimePositionsProvider(accountId)),
      onRetryTransactions: () => ref.invalidate(realTimeTransactionsProvider(accountId)),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared chrome
// ---------------------------------------------------------------------------

/// Scaffold shell shared by the loading, error, and loaded states, so all
/// three render the same background and back-navigable app bar — the header
/// never shifts as the screen moves between them.
class _DetailChrome extends StatelessWidget {
  const _DetailChrome({required this.body});

  /// Content rendered inside the scaffold body.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      appBar: DetailPageBar(
        label: context.l10n.realTimeDetailedViewTitle,
        onPrevious: () => context.pop(),
      ),
      body: body,
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded body
// ---------------------------------------------------------------------------

class _DetailBody extends StatefulWidget {
  const _DetailBody({
    required this.data,
    required this.positions,
    required this.transactions,
    required this.onRefresh,
    required this.onRetryPositions,
    required this.onRetryTransactions,
  });

  final RealTimeDetailedData data;

  /// Positions request, rendered by the Positions tab.
  final AsyncValue<List<RealTimePosition>> positions;

  /// Transactions request, rendered by the Transactions tab.
  final AsyncValue<List<RealTimeTransaction>> transactions;

  /// Called when the user pulls to refresh on either tab.
  final Future<void> Function() onRefresh;

  /// Retry callbacks for each tab's own error state.
  final VoidCallback onRetryPositions;

  /// Retry callback for the Transactions tab's error state.
  final VoidCallback onRetryTransactions;

  @override
  State<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<_DetailBody> {
  int _tabIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _tabIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        // ── Account header card ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          // The header and the switcher beneath it settle in as a pair, ahead
          // of the rows in the tab below them.
          child: SettleIn(
            child: RealTimeAccountSelectionCard(
              data: widget.data,
              onChange: () => context.pop(),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Pill tab switcher ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SettleIn(
            index: 1,
            child: AppPillTabBar(
              selectedIndex: _tabIndex,
              tabs: [l10n.realTimePositionsTab, l10n.realTimeTransactionsTab],
              onTabSelected: _onTabSelected,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Tab content (swipeable) ────────────────────────────────────
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _tabIndex = i),
            children: [
              RealTimePositionsTab(
                positions: widget.positions,
                onRefresh: widget.onRefresh,
                onRetry: widget.onRetryPositions,
              ),
              RealTimeTransactionsTab(
                transactions: widget.transactions,
                onRefresh: widget.onRefresh,
                onRetry: widget.onRetryTransactions,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

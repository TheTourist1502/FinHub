import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_data.dart';
import 'package:finhub/features/my_commissions/presentation/providers/my_commissions_provider.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/commission_trend_top_card.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/commissions_overview_tab.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/my_commissions_details_tab.dart';
import 'package:finhub/features/my_commissions/presentation/widgets/my_commissions_shimmer.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:finhub/shared/widgets/layout/detail_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Full-screen My Commissions page.
///
/// Accessed via `/my-commissions`, pushed from the dashboard. Renders
/// outside the bottom-nav shell so the shell is hidden.
///
/// Layout:
///  1. [DetailPageBar] — back arrow and title only.
///  2. [CommissionTrendTopCard] — full-bleed trend card, bottom-rounded
///     corners, total commission + change delta + area chart.
///  3. Tab bar — "Overview" and "Details" tabs.
///  4. [CommissionsOverviewTab] / [MyCommissionsDetailsTab] — tab content.
class MyCommissionsScreen extends ConsumerWidget {
  /// Creates a [MyCommissionsScreen].
  ///
  /// Set [showAppBar] to `false` when the screen is rendered inside the
  /// bottom-nav shell, which supplies its own header — see
  /// `LeadershipCommissionsScreen`. The default `true` keeps the pushed
  /// advisor route unchanged, back arrow and all.
  const MyCommissionsScreen({super.key, this.showAppBar = true});

  /// Whether to render the screen's own [DetailPageBar].
  final bool showAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(myCommissionsProvider);
    final l10n = context.l10n;
    final colors = context.appColors;

    return asyncData.when(
      loading: () => Scaffold(
        backgroundColor: colors.bgPrimary,
        appBar: showAppBar ? DetailPageBar(label: l10n.myCommissionsTitle, onPrevious: () => context.pop()) : null,
        body: const MyCommissionsShimmer(),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: colors.bgPrimary,
        appBar: showAppBar ? DetailPageBar(label: l10n.myCommissionsTitle, onPrevious: () => context.pop()) : null,
        body: Center(child: ErrorView(error: e is AppError ? e : const UnknownError())),
      ),
      data: (data) => _CommissionsBody(
        data: data,
        showAppBar: showAppBar,
        onRefresh: () => ref.refresh(myCommissionsProvider.future),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded body — summary card + tab layout
// ---------------------------------------------------------------------------

class _CommissionsBody extends StatefulWidget {
  const _CommissionsBody({required this.data, required this.onRefresh, required this.showAppBar});

  final CommissionData data;

  /// Whether to render the screen's own [DetailPageBar]; false inside the shell.
  final bool showAppBar;

  /// Called when the user pulls to refresh; should re-fetch all commission data.
  final Future<void> Function() onRefresh;

  @override
  State<_CommissionsBody> createState() => _CommissionsBodyState();
}

class _CommissionsBodyState extends State<_CommissionsBody> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: widget.showAppBar
          ? DetailPageBar(label: l10n.myCommissionsTitle, onPrevious: () => context.pop())
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Trend card — full-bleed, bottom-rounded corners ─────────────
          CommissionTrendTopCard(
            commissionEarned: widget.data.commissionEarned,
            commissionsTrend: widget.data.commissionsTrend,
          ),

          const SizedBox(height: 8),

          // ── Tab bar — pixel-perfect: gray bg, 2 px bottom border ─────
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.borderStrong),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: colors.bgBrandNavyBlue,
              labelColor: colors.bgBrandNavyBlue,
              unselectedLabelColor: colors.textSecondary,
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 20 / 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 20 / 14,
              ),
              dividerHeight: 0,
              tabs: [
                Tab(text: l10n.myCommissionsTabOverview),
                Tab(text: l10n.myCommissionsTabDetails),
              ],
            ),
          ),

          // ── Tab content ──────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CommissionsOverviewTab(data: widget.data, onRefresh: widget.onRefresh),
                const MyCommissionsDetailsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

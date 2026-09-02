import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_aum_trend.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_transaction.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';
import 'package:finhub/features/account_detail_view/presentation/providers/account_detail_provider.dart';
import 'package:finhub/features/account_detail_view/presentation/widgets/account_detail_allocation_section.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/charts/history_chart_widget.dart';
import 'package:finhub/shared/widgets/charts/touch_reactive_aum_hero.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_avatar.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

/// Overview tab content on the account detail screen.
///
/// Renders the AUM trend chart with period filters, asset allocation donut,
/// two quick-info tiles (Cash Available and Risk Profile), and the latest
/// activity list. Matches the Figma overview tab design (node 1728:2962).
class AccountDetailOverviewTab extends ConsumerWidget {
  /// Creates an [AccountDetailOverviewTab].
  const AccountDetailOverviewTab({required this.account, super.key});

  /// The loaded account data to display.
  final DetailedAccount account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final aumTrendsAsync = ref.watch(accountAumTrendsProvider(account.accountId));

    // Most recent transaction for the Latest Activity section.
    final sortedTxns = [...account.transactions]
      ..sort((a, b) => compareDatesDesc(a.transactionDate, b.transactionDate));
    final latestTxns = sortedTxns.take(1).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      children: [
        // ── AUM trend card ────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.borderDefault),
            boxShadow: [
              BoxShadow(color: colors.cardShadow, blurRadius: 8, spreadRadius: -2, offset: const Offset(0, 2)),
            ],
          ),
          child: aumTrendsAsync.when(
            data: (aumTrends) => _AccountAumTrendContent(
              accountId: account.accountId,
              currentValue: account.currentValue,
              aumTrends: aumTrends,
            ),
            loading: () => const _AumTrendChartShimmer(),
            error: (_, _) => _AccountAumTrendContent(
              accountId: account.accountId,
              currentValue: account.currentValue,
              aumTrends: const [],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Asset Allocation ──────────────────────────────────────────────
        AccountDetailAllocationSection(account: account),

        // ── Latest Activity ───────────────────────────────────────────────
        if (latestTxns.isNotEmpty) ...[
          const SizedBox(height: 24),
          // Sits below the fold on every screen size, so its entrance waits
          // for the reader to scroll down to it.
          SettleIn(
            revealOnScroll: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.accountDetailLatestActivity, style: AppTypography.cardTitle),
                const SizedBox(height: 12),
                ...latestTxns.map(
                  (tx) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LatestActivityCard(transaction: tx),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// AUM trend chart — real weekly history via the shared HistoryChartSection
// ---------------------------------------------------------------------------

/// Renders the "AUM Trend" eyebrow, this account's Total AUM hero value
/// (always shown, since [currentValue] comes from a separate, independent
/// fetch), and its trend via [TouchReactiveAumHero] — or an empty-state
/// message below the hero when no history is available for this account.
/// Owns the card's only heading — the parent doesn't render one of its own.
class _AccountAumTrendContent extends StatelessWidget {
  const _AccountAumTrendContent({required this.accountId, required this.currentValue, required this.aumTrends});

  /// Identifies which account's filter selection to read/write — see
  /// [accountAumTrendFilterProviderFor].
  final String accountId;

  /// The account's authoritative current AUM, shown as the hero value at
  /// rest (untouched) and whenever no trend history is available to touch.
  final double currentValue;

  final List<AccountAumTrend> aumTrends;

  @override
  Widget build(BuildContext context) {
    return TouchReactiveAumHero<AccountAumTrend>(
      eyebrowLabel: context.l10n.accountDetailAumTrend,
      restValue: currentValue,
      restLabel: context.l10n.accountDetailHeroYtdLabel,
      entries: aumTrends,
      filterProvider: accountAumTrendFilterProviderFor(accountId),
      getDate: (e) => e.weekDate,
      getValue: (e) => e.aum,
      chartContext: HistoryChartContext.accountAum,
      emptyMessage: context.l10n.accountDetailAumTrendEmpty,
    );
  }
}

/// Shimmer placeholder shown while the AUM trend history is loading.
///
/// Mirrors the shape of [_AccountAumTrendContent]'s eyebrow/hero row plus
/// [HistoryChartSection]'s change row, chart, and filter chip row so the
/// loading state doesn't visibly jump once data arrives.
class _AumTrendChartShimmer extends StatelessWidget {
  const _AumTrendChartShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow — Inter 14px, ~×1.2 ≈ 17 → 18
          _ShimmerBox(width: 80, height: 18),
          SizedBox(height: 6),
          // Hero value — Inter 28px, ~×1.2 ≈ 33.6 → 34
          _ShimmerBox(width: 200, height: 34),
          SizedBox(height: 8),
          // Change row — Inter 16px, ~×1.2 ≈ 19.2 → 20
          _ShimmerBox(width: 130, height: 20),
          SizedBox(height: 16),
          _ShimmerBox(width: double.infinity, height: 96, radius: 8),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ShimmerBox(width: 52, height: 28, radius: 20),
              SizedBox(width: 8),
              _ShimmerBox(width: 52, height: 28, radius: 20),
              SizedBox(width: 8),
              _ShimmerBox(width: 52, height: 28, radius: 20),
              SizedBox(width: 8),
              _ShimmerBox(width: 52, height: 28, radius: 20),
            ],
          ),
        ],
      ),
    );
  }
}

/// Rounded rectangle placeholder block used inside shimmer skeletons.
///
/// Filled white like every other shimmer placeholder in the app (see
/// [AccountDetailShimmer]) so the tint is supplied solely by the enclosing
/// [Shimmer.fromColors] gradient — the screen-level skeleton this hands off
/// from renders an identical block in the same position.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 4,
  });
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Latest activity card
// ---------------------------------------------------------------------------

/// Card showing a single recent transaction in the Latest Activity section.
///
/// Mirrors [RecentTransactionCard]'s layout (avatar, title, account/date
/// subtitle, amount) and colours transaction types via [transactionTypeConfig]
/// so the badge styling stays consistent with the rest of the app.
class _LatestActivityCard extends StatelessWidget {
  const _LatestActivityCard({required this.transaction});

  final AccountTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final config = transactionTypeConfig(transaction.transactionType, colors, l10n);

    final amountStr = NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: 2,
    ).format(transaction.displayAmount);

    final title = _securityLabel(transaction.securityName, transaction.tickerSymbol);
    // Undated transactions show no date segment at all rather than a
    // placeholder — see the subtitle row below.
    final date = transaction.transactionDate;
    final dateLabel = date == null ? null : _relativeDate(l10n, date);
    final hasAccountName = (transaction.accountName ?? '').isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            // ── Avatar circle ─────────────────────────────────────────────
            TransactionTypeAvatar(config: config, size: 40, fontSize: 11),
            const SizedBox(width: 12),

            // ── Title + account/date subtitle ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (hasAccountName)
                        Flexible(
                          child: Text(
                            transaction.accountName!,
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (dateLabel != null)
                        Text(
                          hasAccountName ? ' • $dateLabel' : dateLabel,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // ── Amount ──────────────────────────────────────────────────────
            // Capped at a quarter of the row width so long values scale down
            // instead of squeezing title and subtitle.
            SizedBox(
              width: constraints.maxWidth * 0.25,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  amountStr,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: config.displayColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds the security label as `Security Name (TICKER)`, `TICKER`, or `Security Name`.
String _securityLabel(String securityName, String? ticker) {
  final hasTicker = (ticker ?? '').isNotEmpty;
  final hasName = securityName.isNotEmpty;
  if (hasTicker && hasName) return '$securityName (${ticker!})';
  if (hasTicker) return ticker!;
  return hasName ? securityName : '';
}

/// Returns a human-readable relative date string ("Today", "Yesterday", or
/// the formatted date).
String _relativeDate(AppLocalizations l10n, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final txDay = DateTime(date.year, date.month, date.day);
  final diff = today.difference(txDay).inDays;

  if (diff == 0) return l10n.dashboardTransactionDateToday;
  if (diff == 1) return l10n.dashboardTransactionDateYesterday;
  return DateFormat('MMM d').format(date);
}

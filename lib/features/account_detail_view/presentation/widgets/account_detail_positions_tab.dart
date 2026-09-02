import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/account_detail_view/domain/models/account_position.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/animations/wipe.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:finhub/shared/widgets/transaction/transaction_filter_chip.dart';
import 'package:flutter/material.dart';

/// Height of a position card's allocation bar.
const double _barHeight = 6;

/// Pill radius for the allocation bar — half its height, so the ends are round
/// at any width. Held as a `const` so the two bar layers share one instance
/// instead of allocating a `BorderRadius` per card, per build.
const BorderRadius _barRadius = BorderRadius.all(Radius.circular(_barHeight / 2));

/// Positions tab content on the account detail screen.
///
/// Renders an asset-class filter chip row, a header with the holding count and
/// a sort control, followed by a card for each position showing the security
/// name, market value, gain/loss, and allocation progress bar.
/// Matches the Figma positions tab design (node 1728:2584).
class AccountDetailPositionsTab extends StatefulWidget {
  /// Creates an [AccountDetailPositionsTab].
  const AccountDetailPositionsTab({required this.positions, super.key});

  /// The list of positions to display.
  final List<AccountPosition> positions;

  @override
  State<AccountDetailPositionsTab> createState() => _AccountDetailPositionsTabState();
}

class _AccountDetailPositionsTabState extends State<AccountDetailPositionsTab> {
  String _sortField = 'value';
  bool _sortDescending = true;

  /// Raw asset class the chip row is filtering on; `null` shows every holding.
  ///
  /// Holds the unlocalised [AccountPosition.securityType] value so it can be
  /// compared straight against the positions — only the chip label is
  /// translated.
  String? _assetClass;

  static const _fieldName = 'name';

  /// Distinct asset classes present in [AccountDetailPositionsTab.positions],
  /// heaviest sleeve first.
  ///
  /// Built from the data rather than a fixed enum: the API is free to add
  /// asset classes, and a hardcoded list would silently hide the holdings of
  /// any class it doesn't know about. Ordering by total market value puts the
  /// classes the advisor cares about most at the head of the scrollable row.
  List<String> get _assetClasses {
    final totals = <String, double>{};
    for (final position in widget.positions) {
      if (position.securityType.isEmpty) continue;
      totals.update(position.securityType, (v) => v + position.marketValue, ifAbsent: () => position.marketValue);
    }
    return totals.keys.toList()..sort((a, b) => totals[b]!.compareTo(totals[a]!));
  }

  /// The positions to render: filtered by [_assetClass], then sorted.
  List<AccountPosition> get _visible {
    final filtered = _assetClass == null
        ? widget.positions
        : widget.positions.where((p) => p.securityType == _assetClass);

    return [...filtered]..sort((a, b) {
      if (_sortField == _fieldName) {
        return _sortDescending ? b.securityName.compareTo(a.securityName) : a.securityName.compareTo(b.securityName);
      }
      return _sortDescending ? b.marketValue.compareTo(a.marketValue) : a.marketValue.compareTo(b.marketValue);
    });
  }

  /// Drops a selection whose asset class no longer exists in the new data
  /// (e.g. the account is refreshed and the last holding of that class is
  /// gone), which would otherwise leave the tab stuck on an empty list with
  /// no chip rendered to clear it.
  @override
  void didUpdateWidget(covariant AccountDetailPositionsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_assetClass != null && !_assetClasses.contains(_assetClass)) {
      _assetClass = null;
    }
  }

  /// Horizontally scrollable asset-class chip row, `All` first.
  Widget _filterChips(List<String> assetClasses, AppLocalizations l10n) => SizedBox(
    height: 34,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: assetClasses.length + 1,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, index) {
        final assetClass = index == 0 ? null : assetClasses[index - 1];
        return TransactionFilterChip(
          label: assetClass == null ? l10n.accountDetailPositionsFilterAll : assetClassMediumLabel(l10n, assetClass),
          selected: _assetClass == assetClass,
          onTap: () => setState(() => _assetClass = assetClass),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.positions.isEmpty) return const NoRecordWidget();

    final l10n = context.l10n;
    final colors = context.appColors;
    final assetClasses = _assetClasses;
    final visible = _visible;

    // Allocation bar colour per asset class, keyed by the same heaviest-first
    // ranking the donut chart's legend uses, so a class reads the same colour
    // in both places.
    final chartColors = [
      colors.chart1,
      colors.chart2,
      colors.chart3,
      colors.chart4,
      colors.chart5,
      colors.chart6,
      colors.chart7,
      colors.chart8,
      colors.chart9,
      colors.chart10,
    ];
    final barColors = {
      for (var i = 0; i < assetClasses.length; i++) assetClasses[i]: chartColors[i % chartColors.length],
    };

    // A single asset class leaves nothing to narrow, so the row is dropped
    // entirely — the same rule the sort menu follows.
    final showChips = assetClasses.length > 1;

    return CustomScrollView(
      slivers: [
        // ── Asset class filter chips ────────────────────────────────────
        if (showChips)
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: SliverToBoxAdapter(child: _filterChips(assetClasses, l10n)),
          ),

        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, showChips ? 12 : 16, 16, 0),
          sliver: SliverToBoxAdapter(
            // ── Header row ──────────────────────────────────────────────
            child: SortHeaderRow(
              label: l10n.accountDetailAllHoldings(visible.length).toUpperCase(),
              sortMenuButton: visible.length > 1
                  ? SortMenuButton(
                      fields: [
                        SortField(id: 'value', label: l10n.commonValue),
                        SortField(id: _fieldName, label: l10n.commonName),
                      ],
                      activeFieldId: _sortField,
                      isDescending: _sortDescending,
                      onChanged: (id, {required descending}) => setState(() {
                        _sortField = id;
                        _sortDescending = descending;
                      }),
                    )
                  : null,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ── Position cards ──────────────────────────────────────────────
        if (visible.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: NoRecordWidget(message: l10n.accountDetailPositionsEmptyFilter),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.builder(
              itemCount: visible.length,
              itemBuilder: (_, index) {
                final isLast = index == visible.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                  // Rows deal in one at a time as the reader scrolls to them,
                  // the same entrance the accounts list uses.
                  child: SettleIn(
                    index: index,
                    revealOnScroll: true,
                    child: _PositionCard(
                      position: visible[index],
                      barColor: barColors[visible[index].securityType] ?? colors.interactiveDefault,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Position card
// ---------------------------------------------------------------------------

/// Card showing a single security position with value, gain/loss, and
/// an allocation progress bar.
class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position, required this.barColor});

  final AccountPosition position;

  /// Fill colour of the allocation bar — the position's asset class colour
  /// from the donut chart's palette.
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    final allocationFraction = (position.allocationPercentage / 100).clamp(0.0, 1.0);

    // Everything that does not roll is built once here and handed back to the
    // reveal's builder unchanged, so only the two figures and the bar's clip
    // are recomputed per frame.
    final identity = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ticker avatar, filled with the asset-class colour
        _SecurityAvatar(ticker: position.tickerSymbol, accent: barColor),
        const SizedBox(width: 12),
        // Name + asset class
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                position.securityName,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),

                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // "Asset Class: <class>" — label at w400, value at w500.
              //
              // `viewTransactionsDetailLabelAssetClass` is the existing key for
              // this exact label; its name is scoped to the transactions detail
              // sheet where it was first added, but the string is generic and
              // already translated in all four ARB files, so it is reused here
              // rather than adding a second key saying the same thing.
              Text.rich(
                TextSpan(
                  text: '${l10n.viewTransactionsDetailLabelAssetClass}: ',
                  children: [
                    TextSpan(
                      text: assetClassLongLabel(l10n, position.securityType),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    final allocationLabel = Text(
      l10n.assetAllocationLabel,
      style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
    );

    // Laid out once at its real width and uncovered by the wipe, so the bar
    // never renders at a width that misstates the allocation. Sized by
    // fraction rather than a LayoutBuilder — the same result without a layout
    // callback and relayout boundary on every card in the list.
    final bar = Stack(
      children: [
        const SizedBox(
          height: _barHeight,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.allocationBarBg, borderRadius: _barRadius),
          ),
        ),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: allocationFraction,
          child: SizedBox(
            height: _barHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: barColor, borderRadius: _barRadius),
            ),
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: colors.borderDefault),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      // One reveal drives the market value, the allocation percentage and the
      // bar's wipe together — separate controllers would drift and leave the
      // percentage reading a figure the bar has not reached.
      child: FigureReveal(
        revealOnScroll: true,
        duration: AppMotion.settle,
        curve: AppMotion.enter,
        builder: (context, t) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + value row ────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: identity),
                const SizedBox(width: 8),
                // Market value
                Text(
                  compactDollar(position.marketValue * t),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Allocation label + percentage ───────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                allocationLabel,
                Text(
                  '${(position.allocationPercentage * t).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // ── Allocation progress bar ─────────────────────────────────────
            Wipe(progress: t, child: bar),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Security avatar
// ---------------------------------------------------------------------------

/// Circular avatar showing the full ticker symbol, scaled down to fit, filled
/// with the position's asset-class colour so it reads as the same sleeve as
/// the allocation bar and the donut slice below it.
///
/// Falls back to a `$` glyph when [ticker] is null (cash/sweep positions
/// with no underlying security).
class _SecurityAvatar extends StatelessWidget {
  const _SecurityAvatar({required this.ticker, required this.accent});

  final String? ticker;

  /// Asset-class colour filling the circle — the same value the card's
  /// allocation bar is drawn in.
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final letters = ticker ?? r'$';

    // The glyph flips with the fill's own luminance rather than following a
    // theme token: the chart palette spans navy through pale gold, so a single
    // fixed text colour is unreadable on one end of it or the other.
    final onAccent = accent.computeLuminance() > 0.5 ? AppColors.brandNavyBlue : AppColors.staticWhite;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FittedBox(
        child: Text(
          letters.toUpperCase(),
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: onAccent,
          ),
        ),
      ),
    );
  }
}

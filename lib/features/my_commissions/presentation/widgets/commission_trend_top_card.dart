import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/my_commissions/presentation/providers/my_commissions_provider.dart';
import 'package:finhub/shared/widgets/charts/history_chart_widget.dart';
import 'package:finhub/shared/widgets/currency/currency_hero_value.dart';
import 'package:flutter/material.dart';

/// Top summary card on the My Commissions screen — total commission earned,
/// period-over-period change delta, and a trend area chart with time-range
/// filter chips.
///
/// Mirrors the dashboard's `TotalAumTrendSection` layout: a full-bleed white
/// surface with bottom-only rounded corners (20 px radius) so the parent
/// screen needs no horizontal padding around it. The hero value comes from
/// [commissionEarned] (the authoritative summary total) while the change
/// delta and chart are derived from [commissionsTrend] inside
/// [HistoryChartSection].
class CommissionTrendTopCard extends StatelessWidget {
  /// Creates a [CommissionTrendTopCard].
  const CommissionTrendTopCard({
    required this.commissionEarned,
    required this.commissionsTrend,
    super.key,
  });

  /// Total commission earned, in USD — the authoritative summary total.
  final double commissionEarned;

  /// Weekly commission history used to derive the change delta and chart.
  final List<FaCommissionEntry> commissionsTrend;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CurrencyHeroValue(value: commissionEarned),
              const SizedBox(width: 4),
              Text(
                l10n.myCommissionsHeroYtdLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          HistoryChartSection<FaCommissionEntry>(
            showHeader: false,
            isCompact: true,
            entries: commissionsTrend,
            filterProvider: myCommissionsTrendFilterProvider,
            getDate: (e) => e.weekDate,
            getValue: (e) => e.commission,
            label: l10n.myCommissionsTotalCommissions,
            chartContext: HistoryChartContext.totalCommission,
            height: 80,
          ),
        ],
      ),
    );
  }
}

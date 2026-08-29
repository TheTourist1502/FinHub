import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/widgets/households_insights_metric.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';

const double kHouseholdsInsightsCardWidthFactor = 0.72;

/// Single household card showing name, id, AUM and YTD change.
///
/// Height is auto — the enclosing [IntrinsicHeight] equalises all cards.
class HouseholdsInsightsCard extends StatelessWidget {
  /// Creates a [HouseholdsInsightsCard].
  const HouseholdsInsightsCard({required this.household, this.fullWidth = false, super.key});

  /// Household rendered by this card.
  final HouseholdInsight household;

  /// When true the card fills the available width instead of leaving room for
  /// the next card — used when it is the only household in the strip.
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: fullWidth ? double.infinity : MediaQuery.sizeOf(context).width * kHouseholdsInsightsCardWidthFactor,
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 20, spreadRadius: -2, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        // spaceBetween pins the figures to the bottom of whatever height
        // IntrinsicHeight settles on for the tallest card in the row.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HouseholdIdentity(name: household.householdName, id: household.householdId),
          _HouseholdFigures(totalAum: household.totalAum, aumChangePercentage: household.aumChangePercentage),
        ],
      ),
    );
  }
}

/// Top block of a household card: display name over the household id.
class _HouseholdIdentity extends StatelessWidget {
  /// Creates a [_HouseholdIdentity].
  const _HouseholdIdentity({required this.name, required this.id});

  /// Household display name.
  final String name;

  /// Household identifier shown beneath the name.
  final String id;

  /// Name style; color is applied per theme in [build].
  static const TextStyle _nameStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 1,
  );

  /// Id style; color is applied per theme in [build].
  static const TextStyle _idStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.33,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: _nameStyle.copyWith(color: colors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.dashboardHouseholdIdLabel(id),
            style: _idStyle.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Bottom block of a household card: divider above the AUM and YTD figures.
class _HouseholdFigures extends StatelessWidget {
  /// Creates a [_HouseholdFigures].
  const _HouseholdFigures({required this.totalAum, required this.aumChangePercentage});

  /// Assets under management for the household.
  final double totalAum;

  /// Year-to-date change, rendered with an explicit sign.
  final double aumChangePercentage;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final isPositive = aumChangePercentage >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 1, color: colors.borderDefault, indent: 15, endIndent: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 13, 15, 16),
          // Both figures roll off one clock so the pair lands together.
          // Shorter than the dashboard hero on purpose: these are a strip of
          // secondary cards, and matching the hero's pace would have them
          // competing with it for the reader.
          child: FigureReveal(
            duration: AppMotion.settle,
            builder: (context, t) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HouseholdsInsightsMetric(
                  label: l10n.dashboardAumLabel,
                  value: compactDollar(lerpDouble(0, totalAum, t)!),
                ),
                HouseholdsInsightsMetric(
                  label: l10n.dashboardYtdChangeLabel,
                  value: '${isPositive ? '+' : ''}${lerpDouble(0, aumChangePercentage, t)!.toStringAsFixed(1)}%',
                  valueColor: isPositive ? colors.chartPositive : colors.statusErrorDefault,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

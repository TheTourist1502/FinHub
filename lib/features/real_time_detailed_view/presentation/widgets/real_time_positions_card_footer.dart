import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Footer of a position card: market price and prior close, split by a rule.
class RealTimePositionsCardFooter extends StatelessWidget {
  /// Creates a [RealTimePositionsCardFooter].
  const RealTimePositionsCardFooter({required this.marketPrice, required this.closingPrice, super.key});

  /// Current intraday market price per unit.
  final double marketPrice;

  /// Prior session's closing price per unit.
  final double closingPrice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Built per build, not cached: a NumberFormat binds its locale at
    // construction, so a cached one would survive a language switch.
    final currency = NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 2);
    return Row(
      children: [
        _Metric(label: l10n.realTimeMarketPriceLabel, value: currency.format(marketPrice)),
        const SizedBox(width: 24),
        Container(width: 1, height: 24, color: AppColors.cardBorder),
        const SizedBox(width: 24),
        _Metric(label: l10n.realTimeClosePriceLabel, value: currency.format(closingPrice)),
      ],
    );
  }
}

/// A small label-over-value column used by the footer; [value] arrives
/// pre-formatted so both metrics share one formatter.
class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.metricLabelMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.metricValueDense,
          ),
        ),
      ],
    );
  }
}

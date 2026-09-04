import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_transaction.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_activity_note.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_transactions_summary_row.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Fraction of the trade price the roll starts from. Close enough to the real
/// figure that its digit count — and so the width of the trailing price
/// column — does not change while it rolls.
const double _entranceFraction = 0.9;

/// [value] part-way through its entrance roll, at progress [t].
double _rolled(double value, double t) => lerpDouble(value * _entranceFraction, value, t)!;

/// Card for one intraday activity: CUSIP header, ticker/quantity/price row,
/// then the account-activity description.
class RealTimeTransactionsCard extends StatelessWidget {
  /// Creates a [RealTimeTransactionsCard] for [activity].
  const RealTimeTransactionsCard({required this.activity, super.key});

  /// The activity rendered by this card.
  final RealTimeTransaction activity;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // Built per-build so a locale switch re-formats the amount.
    final currencyFmt = NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        border: Border.all(color: colors.borderDefault),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            context.l10n.realTimeCusipIdentifier(activity.cusipIdentifier),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          // Only the trade price rolls; the quantity is a count rather than a
          // figure to read a value off, and lerping it would just flicker.
          // No `replayKey` — a refresh rewrites the price in place rather than
          // replaying the roll.
          FigureReveal(
            revealOnScroll: true,
            duration: AppMotion.settle,
            curve: AppMotion.enter,
            builder: (context, t) => RealTimeTransactionsSummaryRow(
              title: activity.tickerSymbol ?? activity.cusipIdentifier,
              activity: activity.accountActivity,
              quantity: activity.activityQuantity.toInt(),
              price: currencyFmt.format(_rolled(activity.tradePriceInBaseCurrency, t)),
            ),
          ),
          RealTimeTransactionsActivityNote(description: activity.accountActivityDescription),
        ],
      ),
    );
  }
}

import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:finhub/features/real_time_detailed_view/presentation/widgets/real_time_positions_card_footer.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Fraction of a figure the roll starts from. Close enough to the real value
/// that the digit count — and so the width of the end-aligned price column —
/// does not change while it rolls, which would shove the description beside it
/// sideways on every frame.
const double _entranceFraction = 0.9;

/// [value] part-way through its entrance roll, at progress [t].
double _rolled(double value, double t) => lerpDouble(value * _entranceFraction, value, t)!;

/// A single position card: CUSIP header, ticker/description/price row, and a
/// market-price / close-price footer.
///
/// Its own widget class so a price tick repaints one row, not the whole tab.
class RealTimePositionsCard extends StatelessWidget {
  /// Creates a [RealTimePositionsCard].
  const RealTimePositionsCard({required this.position, super.key});

  /// The position rendered by this card.
  final RealTimePosition position;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // The parts with no figure in them are built once, outside the reveal's
    // builder, so a roll only rebuilds the numbers.
    final cusip = Text(
      context.l10n.realTimeCusipIdentifier(position.cusipIdentifier),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: colors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
    final identity = _Identity(position: position);

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
      // One reveal drives the market price, today's change and both footer
      // metrics off the same clock. Two controllers would drift, and a card
      // whose header price disagrees with its own footer mid-roll is worse
      // than no motion. No `replayKey`: the feed rewrites these figures as it
      // refreshes, and re-rolling on every tick would leave the advisor
      // reading a number that is never at rest.
      child: FigureReveal(
        revealOnScroll: true,
        duration: AppMotion.settle,
        curve: AppMotion.enter,
        builder: (context, t) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            cusip,
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.borderDefault)),
              ),
              child: Row(
                children: [
                  Expanded(child: identity),
                  const SizedBox(width: 12),
                  _DailyChange(position: position, progress: t),
                ],
              ),
            ),
            RealTimePositionsCardFooter(
              marketPrice: _rolled(position.marketPrice, t),
              closingPrice: _rolled(position.closingPrice, t),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ticker (or CUSIP fallback) above the full security description.
class _Identity extends StatelessWidget {
  const _Identity({required this.position});

  final RealTimePosition position;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          position.tickerSymbol ?? position.cusipIdentifier,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          position.securityDescription,
          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Market price with today's gain/loss amount and percentage beneath it.
class _DailyChange extends StatelessWidget {
  const _DailyChange({required this.position, required this.progress});

  final RealTimePosition position;

  /// Entrance progress from the card's single [FigureReveal].
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // Built per build, not cached: a NumberFormat binds its locale at
    // construction, so a cached one would survive a language switch.
    final currency = NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 2);
    final changeColor = position.isGain ? colors.chartPositive : colors.statusErrorDefault;
    final changeSign = position.isGain ? '+' : '';
    final changeStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: changeColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          currency.format(_rolled(position.marketPrice, progress)),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$changeSign${currency.format(_rolled(position.dailyChangeAmount, progress))}',
          style: changeStyle,
        ),
        Text(
          '(${_rolled(position.dailyChangePercent.abs(), progress).toStringAsFixed(2)}%)',
          style: changeStyle,
        ),
      ],
    );
  }
}

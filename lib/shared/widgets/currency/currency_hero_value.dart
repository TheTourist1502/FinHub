import 'dart:ui' show lerpDouble;

import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Renders a formatted dollar hero value: bold 28 px integer part + muted
/// 24 px cents suffix (derived from [value]).
///
/// On its first appearance the number rolls into place — the app's one
/// deliberately attention-holding moment. It rolls in from [_entranceFraction]
/// of the total, not from zero: a balance spinning up from `$0.00` reads as a
/// slot machine, while a short decelerating approach reads as the figure
/// settling.
///
/// The roll is a first-appearance effect only. Later changes to [value] are
/// shown immediately, because the value this hero carries is touch-reactive:
/// dragging along the chart below rewrites it many times a second, and rolling
/// to each new figure would leave the number trailing the reader's finger.
///
/// Purely presentational — callers own any eyebrow label placed above it.
class CurrencyHeroValue extends StatelessWidget {
  /// Creates a [CurrencyHeroValue].
  const CurrencyHeroValue({
    required this.value,
    this.integerStyle,
    this.decimalStyle,
    this.revealOnScroll = false,
    super.key,
  });

  /// Dollar amount to display in USD.
  final double value;

  /// Additional style merged onto the bold integer-part style.
  final TextStyle? integerStyle;

  /// Additional style merged onto the muted decimal-part style.
  final TextStyle? decimalStyle;

  /// Waits for the value to scroll into view before rolling. The dashboard's
  /// AUM hero is the first thing on screen and leaves this `false`; the
  /// commissions hero sits below the fold and sets it.
  final bool revealOnScroll;

  /// Fraction of [value] the entrance roll starts from.
  static const double _entranceFraction = 0.96;

  @override
  Widget build(BuildContext context) {
    // No `replayKey`, so the reveal runs once on mount and every later value
    // lands immediately.
    return FigureReveal(
      revealOnScroll: revealOnScroll,
      builder: (context, t) => _valueText(context, lerpDouble(value * _entranceFraction, value, t)!),
    );
  }

  /// Builds the two-part dollar figure for the currently displayed [amount].
  Widget _valueText(BuildContext context, double amount) {
    final colors = context.appColors;
    final formatted = NumberFormat('#,##0.00', 'en_US').format(amount);
    final [integerPart, decimalPart] = formatted.split('.');

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '\$$integerPart',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: colors.textPrimary,
              letterSpacing: -0.9,
              height: 40 / 28,
            ).merge(integerStyle),
          ),
          TextSpan(
            text: '.$decimalPart',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 24,
              color: colors.textPrimary,
              letterSpacing: -0.9,
              height: 32 / 24,
            ).merge(decimalStyle),
          ),
        ],
      ),
    );
  }
}

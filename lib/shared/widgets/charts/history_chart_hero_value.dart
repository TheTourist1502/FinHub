import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Renders the large dollar amount with a smaller ".00" suffix.
///
/// e.g. `$142,850,290.00` — the integer part is bold 28 px and the cents
/// are regular 24 px in muted colour, matching the Figma spec.
class HistoryChartHeroValue extends StatelessWidget {
  /// Creates a [HistoryChartHeroValue].
  const HistoryChartHeroValue({required this.integerPart, super.key});
  final String integerPart;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

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
            ),
          ),
          TextSpan(
            text: '.00',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 24,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A "-" placeholder shown in place of [HistoryChartHeroValue] when the
/// selected filter window has no data points to report a total for.
class HistoryChartEmptyHeroValue extends StatelessWidget {
  /// Creates a [HistoryChartEmptyHeroValue].
  const HistoryChartEmptyHeroValue({required this.colors, super.key});
  final AppColorTokens colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      '-',
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 28,
        color: colors.textPrimary,
      ),
    );
  }
}

import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/charts/history_chart_hero_value.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The eyebrow label and hero dollar value above a history chart.
///
/// Its own widget so a touch-driven value change repaints only this block
/// instead of the whole chart section.
class HistoryChartHeader extends StatelessWidget {
  /// Creates a [HistoryChartHeader].
  const HistoryChartHeader({
    required this.label,
    required this.value,
    required this.hasData,
    super.key,
  });

  /// Eyebrow label shown above the value (e.g. "TOTAL AUM").
  final String label;

  /// The amount rendered as the hero figure. Ignored when [hasData] is false.
  final double value;

  /// Whether the selected window has any data — `false` renders a "-".
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        if (hasData)
          HistoryChartHeroValue(integerPart: _integerPart(value))
        else
          HistoryChartEmptyHeroValue(colors: colors),
        const SizedBox(height: 4),
      ],
    );
  }

  /// Formats the integer part of a dollar amount with commas, e.g.
  /// "142,850,290".
  String _integerPart(double value) => NumberFormat('#,##0', 'en_US').format(value.toInt());
}

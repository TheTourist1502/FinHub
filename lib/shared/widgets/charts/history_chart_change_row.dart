import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';

/// Shows the period-over-period change: "+$3.4M (8%) • YTD" (AUM charts,
/// [isCommissionChart] `false`). The amount is compacted with a K/M/B suffix
/// (see `compactDollar`) rather than showing the full number.
///
/// When [hasData] is `false` (the selected filter window has no data
/// points), renders "- • {filterLabel}" instead of a computed delta.
///
/// [isCommissionChart] switches to a "{amount} • {filter}" layout instead:
/// no +/- sign, the amount in [AppColorTokens.textSecondary], and no
/// percentage — `change` there is already the total for the plotted range
/// (a sum of every period in range) rather than a first-vs-last delta.
///
/// On the commission chart, once a month has been drilled into,
/// [selectedMonthLabel] turns the filter segment into a breadcrumb — "YTD >
/// Mar" — with the filter part tappable (underlined in
/// [AppColors.brandFinHubBlue]) via [onFilterLabelTap] to return to the
/// full filter range. With no month selected, [selectedMonthLabel] and
/// [onFilterLabelTap] are both `null` and [filterLabel] renders alone. Only
/// ever set alongside [isCommissionChart] — drilling into a month is
/// commission-only.
class HistoryChartChangeRow extends StatelessWidget {
  /// Creates a [HistoryChartChangeRow].
  const HistoryChartChangeRow({
    required this.hasData,
    required this.showPercent,
    required this.change,
    required this.changePercent,
    required this.isPositive,
    required this.filterLabel,
    this.touchedDateLabel,
    this.selectedMonthLabel,
    this.onFilterLabelTap,
    this.isCommissionChart = false,
    this.revealKey,
    super.key,
  });

  final bool hasData;

  /// Whether to append the percentage in parentheses. Only consulted for
  /// AUM charts ([isCommissionChart] `false`) — the commission chart never
  /// shows a percentage, regardless of mode.
  final bool showPercent;
  final double change;
  final double changePercent;
  final bool isPositive;

  /// The selected filter's label (e.g. "YTD") — the trailing segment on the
  /// commission chart (alone, or as the tappable half of a breadcrumb with
  /// [selectedMonthLabel]), and on AUM charts whenever [touchedDateLabel] is
  /// `null`.
  final String filterLabel;

  /// AUM charts only: while a point is touched, that point's own formatted
  /// date, shown in place of [filterLabel] so the trailing segment reads
  /// consistently with the touch-reactive [change] beside it. Leave `null`
  /// at rest, and always on the commission chart, which has no touch
  /// reactivity (see [isCommissionChart]).
  final String? touchedDateLabel;

  /// The drilled-into month's short name (e.g. "Mar"), or `null` when no
  /// month is selected and [filterLabel] should render alone.
  final String? selectedMonthLabel;

  /// Called when the [filterLabel] segment of the breadcrumb is tapped, to
  /// clear the month selection and go back to the full filter range. Only
  /// non-null — and only then is [filterLabel] rendered as tappable — when
  /// [selectedMonthLabel] is also non-null.
  final VoidCallback? onFilterLabelTap;

  /// Whether this is the commission chart — `false` (default) uses the AUM
  /// sign/percent layout instead. See the class doc for what setting this to
  /// `true` changes.
  final bool isCommissionChart;

  /// Replays the figure roll whenever this changes — pass the plotted range
  /// (the selected filter, plus any drilled-into month), because that is what
  /// recomputes the delta into a genuinely different number. A touch along
  /// the chart also rewrites [change], but many times a second, so it is
  /// deliberately excluded: the figure would never finish rolling.
  final Object? revealKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final segmentStyle = TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: colors.textSecondary,
      letterSpacing: 0,
    );

    final Widget content;
    if (!hasData) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '-',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: colors.textSecondary,
              letterSpacing: 0,
            ),
          ),
          Text(context.l10n.historyChartChangeRowSeparator, style: segmentStyle),
          Text(filterLabel, style: segmentStyle),
        ],
      );
    } else {
      if (isCommissionChart) {
        final formatted = compactDollar(change.abs());
        final separator = context.l10n.historyChartChangeRowSeparator;
        final month = selectedMonthLabel;
        final onFilterTap = onFilterLabelTap;

        content = Row(
          children: [
            FigureReveal(
              replayKey: revealKey,
              duration: AppMotion.settle,
              builder: (context, t) => Text(
                t == 1 ? formatted : compactDollar(lerpDouble(0, change.abs(), t)!),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: colors.textSecondary,
                  letterSpacing: 0,
                ),
              ),
            ),
            Text(separator, style: segmentStyle),
            if (month == null || onFilterTap == null)
              Text(filterLabel, style: segmentStyle)
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onFilterTap,
                    child: Text(
                      filterLabel,
                      style: segmentStyle.copyWith(
                        color: AppColors.brandFinHubBlue,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.brandFinHubBlue,
                      ),
                    ),
                  ),
                  Text(context.l10n.historyChartBreadcrumbSeparator, style: segmentStyle),
                  Text(month, style: segmentStyle),
                ],
              ),
          ],
        );
      } else {
        final sign = isPositive ? '+' : '';
        final color = isPositive ? colors.chartPositive : colors.statusErrorDefault;

        content = Row(
          children: [
            // Amount and percentage roll off one clock, so they stay in step
            // instead of drifting apart on two controllers.
            FigureReveal(
              replayKey: revealKey,
              duration: AppMotion.settle,
              builder: (context, t) {
                final amount = compactDollar(lerpDouble(0, change.abs(), t)!);
                final pct = lerpDouble(0, changePercent, t)!;
                final pctSuffix = showPercent ? ' (${pct.toStringAsFixed(1)}%)' : '';
                return Text(
                  '$sign$amount$pctSuffix',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: color,
                    letterSpacing: 0,
                  ),
                );
              },
            ),
            Text(context.l10n.historyChartChangeRowSeparator, style: segmentStyle),
            Text(touchedDateLabel ?? filterLabel, style: segmentStyle),
          ],
        );
      }
    }

    return SizedBox(
      height: 24,
      child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: content),
    );
  }
}

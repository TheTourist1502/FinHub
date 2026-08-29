import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Section title above the dashboard's recent-transactions card, optionally
/// followed by an `( As of <date> )` qualifier.
///
/// Isolated so the title's theme and l10n reads do not rebuild the list.
class RecentTransactionsHeading extends StatelessWidget {
  /// Creates a [RecentTransactionsHeading] showing [asOfDate] when given.
  const RecentTransactionsHeading({this.asOfDate, super.key});

  /// Parsed snapshot date from the newest record; null when the record had no
  /// date (or there is no data), in which case the qualifier is omitted.
  ///
  /// A pure calendar date — rendered as sent, never shifted into the device
  /// time zone.
  final DateTime? asOfDate;

  /// Trailing "( As of … )" qualifier style; color is applied per theme in [build].
  static const TextStyle _qualifierStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 0,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // A calendar date with no time component, so it is formatted as sent
    // rather than shifted into the device time zone.
    final date = asOfDate;

    return Text.rich(
      TextSpan(
        text: context.l10n.dashboardRecentTransactions,
        style: AppTypography.sectionTitle.copyWith(color: colors.textPrimary),
        children: [
          if (date != null)
            TextSpan(
              // Built per build, not hoisted: a DateFormat captures the ambient
              // locale at construction, so a cached one would survive a
              // language switch.
              text: ' ${context.l10n.dashboardRecentTransactionsAsOf(DateFormat('d MMM yyyy').format(date))}',
              style: _qualifierStyle.copyWith(color: colors.textSecondary),
            ),
        ],
      ),
      // Wraps onto a second line on narrow screens or in locales with a longer
      // title; anything beyond two lines is clipped rather than pushing the
      // card down.
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

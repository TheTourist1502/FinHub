import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/formatters/currency_formatter.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_avatar.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Single recent-transaction row: type avatar, title and account/date
/// subtitle, then the amount.
///
/// Holds no theme or l10n reads itself; each leaf resolves what it needs.
class RecentTransactionCard extends StatelessWidget {
  /// Creates a [RecentTransactionCard] for [transaction].
  const RecentTransactionCard({required this.transaction, super.key});

  /// The transaction rendered by this card.
  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            TransactionTypeAvatar(
              config: transactionTypeConfig(
                transaction.transactionType,
                context.appColors,
                context.l10n,
              ),
              size: 40,
              fontSize: 11,
            ),
            const SizedBox(width: 12),
            Expanded(child: _Description(transaction: transaction)),
            const SizedBox(width: 12),
            // The amount is capped at a quarter of the row width so long
            // values scale down instead of squeezing title and subtitle.
            SizedBox(
              width: constraints.maxWidth * 0.25,
              child: _Amount(
                type: transaction.transactionType,
                amount: transaction.displayAmount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular avatar showing the tinted transaction-type abbreviation.
/// Title line plus the "account • relative date" subtitle.
class _Description extends StatelessWidget {
  /// Creates a [_Description] for [transaction].
  const _Description({required this.transaction});

  /// The transaction whose title and subtitle are rendered.
  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context) {
    // A transaction with no trade date shows the account name alone — the
    // bullet separator goes with the date rather than dangling on its own.
    final date = transaction.transactionDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _transactionTitle(context, transaction),
          style: AppTypography.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Flexible(
              child: Text(
                transaction.accountName,
                style: AppTypography.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (date != null)
              Text(
                ' • ${_relativeDate(context, date)}',
                style: AppTypography.bodySmall,
                maxLines: 1,
              ),
          ],
        ),
      ],
    );
  }
}

/// Right-aligned transaction amount, tinted by transaction type.
///
/// Rolls in from [_entranceFraction] of the figure rather than from zero. The
/// amount sits in a [FittedBox], so counting up from `$0` would change the
/// digit count and rescale the text on nearly every frame; starting close to
/// the real figure keeps the width — and therefore the type size — steady.
class _Amount extends StatelessWidget {
  /// Creates an [_Amount] for a raw transaction [type] and its [amount].
  const _Amount({required this.type, required this.amount});

  /// Raw transaction type ("BUY", "SELL", …), which drives the colour.
  final String type;

  /// The value to format as currency.
  final double amount;

  /// Colour is theme-dependent and applied via `copyWith` in `build`.
  static const TextStyle _amountStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  /// Fraction of the amount the roll starts from.
  static const double _entranceFraction = 0.9;

  @override
  Widget build(BuildContext context) {
    final config = transactionTypeConfig(type, context.appColors, context.l10n);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: FigureReveal(
        duration: AppMotion.settle,
        builder: (context, t) => Text(
          formatCurrency(lerpDouble(amount * _entranceFraction, amount, t)!),
          maxLines: 1,
          style: _amountStyle.copyWith(color: config.displayColor),
        ),
      ),
    );
  }
}

/// Returns a human-readable relative date string.
String _relativeDate(BuildContext context, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final txDay = DateTime(date.year, date.month, date.day);
  final diff = today.difference(txDay).inDays;

  if (diff == 0) return context.l10n.dashboardTransactionDateToday;
  if (diff == 1) return context.l10n.dashboardTransactionDateYesterday;
  return DateFormat('MMM d').format(date);
}

/// Builds the security label as `Security Name (TICKER)`, `TICKER`, or `Security Name`.
String _securityLabel(RecentTransaction t) {
  final ticker = t.tickerSymbol;
  final name = t.securityName;
  final hasTicker = ticker != null && ticker.isNotEmpty;
  final hasName = name != null && name.isNotEmpty;
  if (hasTicker && hasName) return '$name ($ticker)';
  if (hasTicker) return ticker;
  return hasName ? name : '';
}

/// Returns the row title: the security label, whatever the transaction type.
String _transactionTitle(BuildContext context, RecentTransaction t) {
  return _securityLabel(t);
}

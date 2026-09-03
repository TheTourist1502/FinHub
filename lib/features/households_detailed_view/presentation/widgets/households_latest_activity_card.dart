import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Card showing the household's most recent transaction.
///
/// Lays out avatar, title, account/date subtitle and amount, colouring the
/// badge via [transactionTypeConfig] so it matches other transaction surfaces.
class HouseholdsLatestActivityCard extends StatelessWidget {
  /// Creates a [HouseholdsLatestActivityCard].
  const HouseholdsLatestActivityCard({required this.transaction, super.key});

  /// The transaction to render.
  final HouseholdDetailTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final config = transactionTypeConfig(transaction.transactionType, colors, l10n);

    final amountStr = NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: 2,
    ).format(transaction.displayAmount);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          _TransactionAvatar(config: config),
          const SizedBox(width: 12),
          Expanded(
            child: _TransactionSummary(transaction: transaction, config: config),
          ),
          const SizedBox(width: 12),
          Text(
            amountStr,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: config.displayColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular badge showing the transaction type label (e.g. "BUY").
class _TransactionAvatar extends StatelessWidget {
  const _TransactionAvatar({required this.config});

  final TransactionTypeConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: config.badgeBgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            config.label,
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: config.badgeTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Title line plus the "account • date" subtitle of the activity card.
class _TransactionSummary extends StatelessWidget {
  const _TransactionSummary({required this.transaction, required this.config});

  final HouseholdDetailTransaction transaction;
  final TransactionTypeConfig config;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final subtitleStyle = AppTypography.bodySmall.copyWith(color: colors.textSecondary);
    final txDate = transaction.transactionDate;
    final dateLabel = txDate == null ? null : _relativeDate(l10n, txDate);
    final hasAccountName = transaction.accountName.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _transactionTitle(transaction),
          style: AppTypography.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (hasAccountName)
              Flexible(
                child: Text(
                  transaction.accountName,
                  style: subtitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            // An undated transaction drops the date entirely — including the
            // bullet separator, so the account name is not left dangling.
            if (dateLabel != null)
              Text(
                hasAccountName ? ' • $dateLabel' : dateLabel,
                style: subtitleStyle,
                maxLines: 1,
              ),
          ],
        ),
      ],
    );
  }
}

/// Formats the security as `Name (TICKER)`, `TICKER`, or `Name`.
String _securityLabel(String securityName, String ticker) {
  final hasTicker = ticker.isNotEmpty;
  final hasName = securityName.isNotEmpty;
  if (hasTicker && hasName) return '$securityName ($ticker)';
  if (hasTicker) return ticker;
  return hasName ? securityName : '';
}

/// Returns the row title: the security label, whatever the transaction type.
String _transactionTitle(HouseholdDetailTransaction txn) => _securityLabel(txn.securityName, txn.tickerSymbol);

/// Relative date string: "Today", "Yesterday", or the formatted date.
String _relativeDate(AppLocalizations l10n, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final txDay = DateTime(date.year, date.month, date.day);
  final diff = today.difference(txDay).inDays;

  if (diff == 0) return l10n.dashboardTransactionDateToday;
  if (diff == 1) return l10n.dashboardTransactionDateYesterday;
  return DateFormat('MMM d, yyyy').format(date);
}

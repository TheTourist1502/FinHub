import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/formatters/currency_formatter.dart';
import 'package:finhub/features/commissions_detailed_view/domain/models/commission_detail_transaction_card.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Trade-date format for the card footer.
final DateFormat _dateFmt = DateFormat('MMM d, yyyy');

/// Text styles used by [CommissionTransactionCard].
///
/// Public so `CommissionTransactionsListShimmer` can size its placeholder bars
/// from the same values instead of keeping its own copy of the numbers. A
/// skeleton with copied metrics drifts the moment a style changes here — which
/// is how the previous one came to draw a 24 px bar for [name], a style whose
/// line is a little over 18 px.
abstract final class CommissionTransactionCardStyles {
  /// Security name — the card's primary line. Deliberately has no `height`, so
  /// the line is whatever Inter's own metrics make it.
  static const TextStyle name = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 15,
  );

  /// The `TYPE • n Shares @ price` line under the name.
  static const TextStyle detail = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
  );

  /// Uppercase caption above each amount.
  static const TextStyle amountLabel = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 10,
  );

  /// The amounts themselves.
  static const TextStyle amountValue = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 28 / 18,
  );

  /// Trade ID and trade date.
  static const TextStyle footer = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 15 / 10,
    letterSpacing: 0.25,
  );
}

/// A card displaying a single transaction within a commission detail record.
///
/// Shows the security name + ticker, transaction type with share count and
/// price, commission earned alongside the transaction amount, and a footer
/// with the trade ID and trade date.
/// Pixel-perfect to Figma node 2835:1082.
///
/// Split into three leaf sections so a change to one (e.g. the amounts row)
/// does not rebuild the others, and so each section's text styles are built
/// only when that section actually rebuilds.
class CommissionTransactionCard extends StatelessWidget {
  /// Creates a [CommissionTransactionCard].
  const CommissionTransactionCard({required this.transaction, super.key});

  /// The transaction to display.
  final CommissionDetailTransactionCard transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SecurityHeader(transaction: transaction),
          _AmountsRow(
            commissionEarned: transaction.commissionEarned,
            transactionAmount: transaction.transactionAmount,
          ),
          const SizedBox(height: 12),
          _CardFooter(tradeId: transaction.tradeId, tradeDate: transaction.tradeDate),
        ],
      ),
    );
  }
}

/// Security name over the type / quantity / unit-price line, on a subtle
/// tinted background.
class _SecurityHeader extends StatelessWidget {
  const _SecurityHeader({required this.transaction});

  /// Transaction supplying the name, type, quantity and unit price.
  final CommissionDetailTransactionCard transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    // Shared config, so the type accent matches every other transaction surface.
    final typeColor = transactionTypeConfig(transaction.transactionType, colors, l10n).displayColor;
    final detail = l10n.commissionDetailedViewSharesAtPrice(
      '${transaction.quantity.toInt()}',
      formatCurrency(transaction.unitPrice),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.displayName,
            style: CommissionTransactionCardStyles.name.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: transaction.transactionType,
                  style: CommissionTransactionCardStyles.detail.copyWith(color: typeColor),
                ),
                TextSpan(
                  text: ' • $detail',
                  style: CommissionTransactionCardStyles.detail.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Commission earned and transaction amount side by side, with the divider
/// that separates them from the footer.
class _AmountsRow extends StatelessWidget {
  const _AmountsRow({required this.commissionEarned, required this.transactionAmount});

  /// Commission earned on the transaction, in USD.
  final double commissionEarned;

  /// Total invested amount for the transaction, in USD.
  final double transactionAmount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 13),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderDefault)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _InfoBlock(
              label: l10n.myCommissionsCommissionEarned,
              value: '+${formatCurrency(commissionEarned)}',
              color: colors.textBrandNavyBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _InfoBlock(
              label: l10n.commonTrnxAmount.toUpperCase(),
              value: formatCurrency(transactionAmount),
              color: colors.textPrimary,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// Trade ID on the left, trade date on the right.
class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.tradeId, required this.tradeDate});

  /// Trade identifier shown at the leading edge.
  final String tradeId;

  /// Calendar date the trade executed. Pure date — never time-zone shifted.
  /// Null when the backend sent none, in which case the label is dropped.
  final DateTime? tradeDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = CommissionTransactionCardStyles.footer.copyWith(color: context.appColors.textSecondary);

    final date = tradeDate;

    return Row(
      children: [
        Expanded(child: Text(l10n.commissionDetailedViewTxnIdLabel(tradeId), style: style)),
        // Undated trades drop the label and its gap rather than showing a
        // placeholder date.
        if (date != null) ...[
          const SizedBox(width: 12),
          Text(l10n.commissionDetailedViewTradeDateLabel(_dateFmt.format(date)), style: style),
        ],
      ],
    );
  }
}

/// A small label-over-value block used in the card's amounts row.
class _InfoBlock extends StatelessWidget {
  /// Creates an [_InfoBlock].
  const _InfoBlock({
    required this.label,
    required this.value,
    required this.color,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Uppercase-styled caption above the value.
  final String label;

  /// Formatted currency value.
  final String value;

  /// Colour applied to both label and value.
  final Color color;

  /// Horizontal alignment of the label and value.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: CommissionTransactionCardStyles.amountLabel.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(value, style: CommissionTransactionCardStyles.amountValue.copyWith(color: color)),
      ],
    );
  }
}

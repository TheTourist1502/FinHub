import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/asset_class_labels.dart';
import 'package:finhub/core/utils/formatters/currency_formatter.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/shared/animations/pressable.dart';
import 'package:finhub/shared/widgets/transaction/transaction_detail_bottom_sheet.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_config.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Placeholder shown in place of a field the backend left empty.
const _kEmptyValue = '—';

/// Diameter of the dot separating the account name from the account type.
const _kIdentityDotSize = 3.0;

/// Space on each side of the identity-line dot.
const _kIdentityDotGap = 4.0;

/// Total width the dot and its gaps consume on the identity line.
const double _kIdentitySeparatorWidth = _kIdentityDotSize + _kIdentityDotGap * 2;

/// Card showing a single [Transaction]: account name • type, security +
/// ticker, asset class, amount, quantity, type badge, unit price, and a
/// View Details button that opens [TransactionDetailBottomSheet].
///
/// Shared by every transactions list (household detail, account detail, the
/// View All Transactions screen) so type colors and layout stay consistent
/// across the app.
class TransactionCard extends StatelessWidget {
  /// Creates a [TransactionCard] for [transaction].
  const TransactionCard({required this.transaction, super.key});

  /// The transaction to display.
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final config = transactionTypeConfig(transaction.transactionType, colors, l10n);

    // Ticker alone stands in when the backend sends no security name, so the
    // row is never left without an identifying label.
    final ticker = transaction.tickerSymbol ?? '';
    final securityLabel = (transaction.securityName.isNotEmpty && ticker.isNotEmpty)
        ? '${transaction.securityName} ($ticker)'
        : (transaction.securityName.isNotEmpty ? transaction.securityName : ticker);

    // Shared style for the account name / account type identity line.
    final identityStyle = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontWeight: FontWeight.w500,
      fontSize: 10,
      letterSpacing: 0.25,
    );
    // The dot only separates two present values — it is never a leading or
    // trailing bullet when one half of the identity line is missing.
    final hasAccountName = transaction.accountName.isNotEmpty;
    final hasAccountType = transaction.accountType.isNotEmpty;

    final assetClass = transaction.assetClass ?? '';
    // A transaction with no type carries no badge, so the description takes
    // the badge's place as the row's identifying detail.
    final hasType = transaction.transactionType.trim().isNotEmpty;
    final description = transaction.transactionDescription?.trim() ?? '';

    // Account name and security label, sized to 65% of the card's top row.
    final identityColumn = Flexible(
      flex: 65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasAccountName || hasAccountType)
            LayoutBuilder(
              builder: (context, identityConstraints) {
                // The type is laid out first at its natural width, capped at
                // three quarters of the line, and the name then takes every
                // pixel left over. A short type therefore lets the name run
                // long, while a long one still leaves the name its quarter.
                final lineWidth = identityConstraints.maxWidth;
                final maxTypeWidth = hasAccountName
                    ? (lineWidth * 0.75 - _kIdentitySeparatorWidth).clamp(0.0, lineWidth)
                    : lineWidth;
                return Row(
                  children: [
                    if (hasAccountName)
                      Flexible(
                        child: Text(
                          transaction.accountName,
                          style: identityStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (hasAccountName && hasAccountType)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: _kIdentityDotGap),
                        child: Iconify(
                          Mdi.circle,
                          size: _kIdentityDotSize,
                          color: colors.textSecondary,
                        ),
                      ),
                    if (hasAccountType)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxTypeWidth),
                        child: Text(
                          transaction.accountType,
                          style: identityStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                );
              },
            ),
          if (securityLabel.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              securityLabel,
              style: AppTypography.labelMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );

    // Dips under a finger, the same press feedback the account and household
    // cards get from their lists.
    return Pressable(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderDefault),
          boxShadow: [
            BoxShadow(color: colors.cardShadow, blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: account info (65%) | amount & quantity (35%) ─────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                identityColumn,
                const SizedBox(width: 8),
                Flexible(
                  flex: 35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Long amounts shrink to fit the column instead of
                      // wrapping or clipping.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatCurrency(transaction.displayAmount),
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: config.displayColor,
                            height: 18 / 13,
                            letterSpacing: 0.1,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      // Quantity always shows, including a zero — the row reads
                      // as a real value of 0 rather than a missing field.
                      const SizedBox(height: 2),
                      _QuantityLabel(
                        quantity: transaction.quantity,
                        style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (assetClass.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                l10n.viewTransactionsAssetClass(assetClassMediumLabel(l10n, assetClass)),
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],

            // ── Divider ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: colors.borderDefault),
            ),

            // ── Bottom row: type badge + unit price ────────────────────────
            Row(
              // Badge and price sit at opposite ends only when both are there;
              // a lone survivor stays left-aligned instead of drifting right.
              mainAxisAlignment: hasType ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              children: [
                // No badge at all when the transaction has no type — null, "",
                // or whitespace only.
                if (hasType)
                  _TypeBadge(
                    label: config.label,
                    bgColor: config.badgeBgColor,
                    textColor: config.badgeTextColor,
                  ),
                Text(
                  l10n.transactionPrice(formatCurrency(transaction.unitPrice)),
                  style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
                ),
              ],
            ),

            // Description stands in for the missing badge on an untyped
            // transaction, so the row still says what it was.
            if (!hasType) ...[
              const SizedBox(height: 8),
              Text(
                l10n.viewTransactionsDescription(description.isEmpty ? _kEmptyValue : description),
                style: AppTypography.bodySmall.copyWith(color: colors.textSecondary, fontSize: 12),
              ),
            ],

            // ── View Details button ─────────────────────────────────────────
            const SizedBox(height: 12),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showTransactionDetailSheet(context, transaction),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.viewTransactionsViewDetails,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.interactiveDefault,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Iconify(Mdi.arrow_right, size: 10, color: colors.interactiveDefault),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quantity line beside the amount, rendered with the full "Quantity: n"
/// wording whenever it fits on one line.
///
/// The column that holds it is only 35% of the card, so a long locale word
/// plus a four-decimal figure can outgrow it. Rather than abbreviate
/// everywhere, the label compares the full string's natural width against the
/// width it actually got, and falls back to the short form ("Qty: n") only
/// when the full one would not fit. It never ellipsises.
class _QuantityLabel extends StatelessWidget {
  const _QuantityLabel({required this.quantity, required this.style});

  /// Number of units traded, formatted by the ARB placeholder.
  final double quantity;

  /// Style applied to the label, and used to measure it.
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final full = l10n.viewTransactionsQuantity(quantity);

    final textDirection = Directionality.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    /// Natural single-line width of [text] in [style], laid out unbounded so
    /// the result is the width the string *wants*, not one clamped to the box.
    double naturalWidth(String text) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: textDirection,
        textScaler: textScaler,
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final label = naturalWidth(full) <= constraints.maxWidth ? full : l10n.viewTransactionsQuantityShort(quantity);

        // scaleDown rather than ellipsis: a clipped number is unreadable, so
        // if even the short form overruns its column it shrinks to fit.
        return SizedBox(
          width: constraints.maxWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(label, style: style, maxLines: 1, softWrap: false),
          ),
        );
      },
    );
  }
}

/// Token-coloured pill badge for the transaction type.
class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.bgColor, required this.textColor});

  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

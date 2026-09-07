import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/account_number_utils.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Fraction of the commission the roll starts from, matching the top-accounts
/// card so both lists speak the same way about money.
const double _entranceFraction = 0.9;

/// A card displaying a single commission transaction record.
///
/// Shows the account holder name, commission earned, the account number,
/// and a "View Details" link.
/// Pixel-perfect implementation of Figma node 2835:1027.
class CommissionSummaryCard extends StatelessWidget {
  /// Creates a [CommissionSummaryCard].
  const CommissionSummaryCard({
    required this.transaction,
    this.onViewDetails,
    super.key,
  });

  /// The commission transaction to display.
  final CommissionSummary transaction;

  /// Optional callback invoked when the user taps "View Details".
  final VoidCallback? onViewDetails;

  static final _currencyFmt = NumberFormat('#,##0.00', 'en_US');

  String _formatCommission(double amount) => '+\$${_currencyFmt.format(amount)}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          // ── Account holder name ─────────────────────────────────────────
          Text(
            transaction.accountHolderName.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: colors.textSecondary,
              letterSpacing: 0.25,
            ),
          ),

          const SizedBox(height: 12),

          // ── Commission earned, left-aligned, with full-width bottom divider ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 13),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.borderStrong),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.myCommissionsCommissionEarned,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                // Rolls when the card is scrolled to: this list paginates, so
                // most cards are built well below the fold.
                FigureReveal(
                  revealOnScroll: true,
                  duration: AppMotion.settle,
                  builder: (context, t) => Text(
                    _formatCommission(
                      lerpDouble(transaction.commissionEarned * _entranceFraction, transaction.commissionEarned, t)!,
                    ),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: colors.textPrimary,
                      height: 28 / 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Footer: identifier + view details link ──────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  transaction.accountNumber != null
                      ? l10n.myCommissionsAccountNumber(maskAccountNumber(transaction.accountNumber!))
                      : '',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: colors.textSecondary,
                    height: 16 / 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: onViewDetails,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.myCommissionsViewDetails,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: colors.textPrimary,
                        height: 16 / 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '→',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/account_number_utils.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_data.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Fraction of the commission the roll starts from. Close enough to the real
/// figure that the digit count — and so the width of the end-aligned column —
/// does not change while it rolls.
const double _entranceFraction = 0.9;

/// A single ranked account row on the My Commissions overview tab's top
/// accounts list.
///
/// Row 1: account holder name (65% width) and total commission, formatted
/// to two decimals. Row 2: masked account number and the "TOTAL COMMISSION"
/// label.
class TopAccountsCard extends StatelessWidget {
  /// Creates a [TopAccountsCard].
  const TopAccountsCard({
    required this.account,
    super.key,
  });

  /// The ranked account to display.
  final TopAccount account;

  /// Formatter applied to [TopAccount.totalCommission].
  static final _commissionFmt = NumberFormat('#,##0.00', 'en_US');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 1, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: account name (65%) | total commission ────────────────
          Row(
            children: [
              Expanded(
                flex: 65,
                child: Text(
                  account.accountHolderName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colors.textPrimary,
                    height: 18 / 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 35,
                // Rolls when the row is scrolled to, not on mount: the list
                // runs past the fold, and a figure that finished rolling above
                // the reader has shown them nothing.
                child: FigureReveal(
                  revealOnScroll: true,
                  duration: AppMotion.settle,
                  builder: (context, t) => Text(
                    '\$${_commissionFmt.format(lerpDouble(account.totalCommission * _entranceFraction, account.totalCommission, t))}',
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: colors.textBrandNavyBlue,
                      height: 24 / 16,
                      letterSpacing: 0.125,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // ── Row 2: masked account number | total commission label ───────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  l10n.myCommissionsAccountLabel(maskAccountNumber(account.accountNumberMasked)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: colors.textSecondary,
                    height: 14 / 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.myCommissionsTotalCommission,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: colors.textSecondary,
                  height: 15 / 10,
                  letterSpacing: 0.125,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

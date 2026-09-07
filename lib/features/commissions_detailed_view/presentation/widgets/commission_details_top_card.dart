import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/account_number_utils.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:finhub/shared/widgets/currency/currency_hero_value.dart';
import 'package:flutter/material.dart';

/// Header card displayed at the top of the Commission Detailed View screen.
///
/// Shows account holder name, masked account number, and the total commission
/// with its YTD label.
/// Pixel-perfect to Figma node 2835:1082.
class CommissionDetailsTopCard extends StatelessWidget {
  /// Creates a [CommissionDetailsTopCard].
  const CommissionDetailsTopCard({required this.summary, super.key});

  /// The commission summary (from the My Commissions list) whose header is shown.
  final CommissionSummary summary;

  static const _nameStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static const _captionStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
  );

  static const _labelStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(summary.accountHolderName, style: _nameStyle.copyWith(color: colors.textPrimary)),
          const SizedBox(height: 4),
          Text(
            l10n.myCommissionsAccountNumber(maskAccountNumber(summary.accountNumber ?? '')),
            style: _captionStyle.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.commissionDetailedViewTotalCommission,
            style: _labelStyle.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CurrencyHeroValue(value: summary.commissionEarned),
              const SizedBox(width: 4),
              Text(
                l10n.commissionDetailedViewYtdLabel,
                style: _captionStyle.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

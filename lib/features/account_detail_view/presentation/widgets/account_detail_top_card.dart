import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/account_number_utils.dart';
import 'package:finhub/features/account_detail_view/domain/models/detailed_account.dart';
import 'package:finhub/shared/widgets/account_card/risk_badge.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Fixed top card shared by all three tabs on the account detail screen.
///
/// Shows only identity details (name, type, number, custodian) — the Total
/// AUM hero value now lives in the Overview tab's AUM Trend chart card
/// instead (see `_AccountAumTrendContent`), so it can react to the chart's
/// own touch state; that card's own change row shows the period change.
class AccountDetailTopCard extends StatelessWidget {
  /// Creates an [AccountDetailTopCard].
  const AccountDetailTopCard({required this.account, super.key});

  /// The loaded account whose data is rendered.
  final DetailedAccount account;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    /// Shared style for the account number and account type on the identity
    /// line, so both sides of the dot separator match.
    final identityStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
      color: colors.textSecondary,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderDefault),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              offset: Offset(0, 4),
              blurRadius: 20,
              spreadRadius: -2,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    account.accountName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 22 / 20,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Account number and type share one line, separated by a dot.
            // One [Text.rich] paragraph rather than a [Wrap] of separate
            // [Text]s so a long type wraps word by word mid-line instead of
            // dropping to a line of its own as an indivisible block.
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.accountDetailAccountNumberLabel(
                      maskAccountNumber(account.accountNumber),
                    ),
                  ),
                  if (account.accountType.isNotEmpty) ...[
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Iconify(Mdi.circle, size: 4, color: colors.textSecondary),
                      ),
                    ),
                    TextSpan(text: account.accountType),
                  ],
                ],
              ),
              style: identityStyle,
            ),
            const SizedBox(height: 2),
            Text(
              l10n.accountsCustodianLabel(
                account.custodian.trim().isEmpty ? '-' : account.custodian,
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
            ),
            if (account.riskProfile.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text(
                    l10n.accountDetailRiskProfileLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                  RiskBadge(riskProfile: account.riskProfile),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

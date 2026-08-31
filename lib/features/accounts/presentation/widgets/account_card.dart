import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/utils/account_number_utils.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:finhub/shared/widgets/account_card/risk_badge.dart';
import 'package:finhub/shared/widgets/charts/asset_allocation_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Card representing a single investment account in the Accounts list.
///
/// Layout (top → bottom):
/// 1. Row split 75% / 25%: name / account-number / custodian | current
///    value / YTD return / "YTD Change" label.
/// 2. Risk badge + account type.
/// 3. Segmented equity / fixed-income allocation bar.
/// 4. Hairline divider + "View Details" link.
/// Fraction of a figure the roll starts from. Close enough to the real value
/// that the digit count — and so the column's width — does not change while it
/// rolls.
const double _entranceFraction = 0.9;

class AccountCard extends StatelessWidget {
  /// Creates an [AccountCard] for the given [account].
  ///
  /// Set [isLast] to `true` on the final item to suppress the bottom margin.
  const AccountCard({required this.account, this.isLast = false, this.onViewDetails, super.key});

  final Account account;

  /// Suppresses bottom margin on the last item in a list.
  final bool isLast;

  /// Overrides "View Details" navigation. When `null` (the default), tapping
  /// pushes the real [AppRoutes.accountDetailView] route. Presentation Mode
  /// passes a callback here instead, so drilling into an account stays
  /// inside its own detail screen rather than leaving to the real one.
  final void Function(Account account)? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final isPositive = account.aumChangePercentage >= 0;
    final returnColor = isPositive ? colors.chartPositive : colors.statusErrorDefault;
    final returnSign = isPositive ? '+' : '-';

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: identity (75%) | value + YTD change (25%) ───────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.accountName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.accountsIdLabel(maskAccountNumber(account.accountNumber)),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.accountsCustodianLabel(
                          account.custodian.trim().isEmpty ? '-' : account.custodian,
                        ),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Value and percentage roll off one clock so the pair
                      // lands together, and wait for the row to scroll into
                      // view. Both start at [_entranceFraction] of their real
                      // figure rather than at zero: the column is end-aligned,
                      // so a changing digit count would shuffle it sideways on
                      // every frame.
                      FigureReveal(
                        revealOnScroll: true,
                        duration: AppMotion.settle,
                        builder: (context, t) => Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              compactDollar(
                                lerpDouble(account.currentValue * _entranceFraction, account.currentValue, t)!,
                              ),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Iconify(
                                  isPositive ? Mdi.trending_up : Mdi.trending_down,
                                  color: returnColor,
                                  size: 12,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '$returnSign'
                                  '${lerpDouble(account.aumChangePercentage.abs() * _entranceFraction, account.aumChangePercentage.abs(), t)!.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: returnColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.dashboardYtdChangeLabel,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Row 2: risk profile | account type ──────────────────────────────
            Row(
              children: [
                RiskBadge(riskProfile: account.riskProfile),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    account.accountType,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Asset allocation ──────────────────────────────────────────────
            if (account.assetAllocation.isNotEmpty) ...[
              AssetAllocationSection(
                allocations: account.assetAllocation
                    .map(
                      (a) => AssetAllocationEntry(
                        assetClass: a.assetClass,
                        percent: a.allocationPercentage,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ── Divider + View Details ────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.borderDefault)),
              ),
              padding: const EdgeInsets.only(top: 17),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onViewDetails != null
                    ? onViewDetails!(account)
                    : context.push(
                        AppRoutes.accountDetailView.replaceFirst(
                          ':accountId',
                          account.accountId,
                        ),
                      ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.dashboardViewDetails,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.interactiveDefault,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Iconify(Mdi.arrow_right, color: colors.interactiveDefault, size: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets

/// Circular initials avatar: white fill, subtle border, bold initials.
// class _AccountAvatar extends StatelessWidget {
//   const _AccountAvatar({required this.initials});

//   final String initials;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final colors = context.appColors;
//     return Container(
//       width: 48,
//       height: 48,
//       decoration: BoxDecoration(
//         color: colors.surfaceDefault,
//         shape: BoxShape.circle,
//         border: Border.all(color: AppColors.allocationBarBg, width: 2),
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         initials,
//         style: TextStyle(
//           fontFamily: 'Inter',
//           fontSize: 16,
//           fontWeight: FontWeight.w700,
//           color: cs.onSurface,
//         ),
//       ),
//     );
//   }
// }

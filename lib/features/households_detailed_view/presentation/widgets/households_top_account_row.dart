import 'dart:ui' show lerpDouble;

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/account_number_utils.dart';
import 'package:finhub/core/utils/currency_utils.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/shared/animations/figure_reveal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Fraction of each figure the entrance roll starts from. Close enough to the
/// real value that the digit count — and so the width of the end-aligned
/// column — does not change while it rolls.
const double _entranceFraction = 0.9;

/// Single tappable account row inside the Top Accounts card.
///
/// Splits 75% / 25% between account identity and performance, and opens the
/// account detail screen unless [onTap] overrides the navigation.
class HouseholdsTopAccountRow extends StatelessWidget {
  /// Creates a [HouseholdsTopAccountRow].
  const HouseholdsTopAccountRow({required this.account, this.onTap, super.key});

  /// The account rendered by this row.
  final Account account;

  /// Overrides the default push to [AppRoutes.accountDetailView] when set.
  final void Function(Account account)? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap != null
          ? onTap!(account)
          : context.push(
              AppRoutes.accountDetailView.replaceFirst(':accountId', account.accountId),
            ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _AccountIdentity(account: account)),
            const SizedBox(width: 12),
            Expanded(child: _AccountPerformance(account: account)),
          ],
        ),
      ),
    );
  }
}

/// Left column of a row: account name, masked number, and account-type pill.
class _AccountIdentity extends StatelessWidget {
  const _AccountIdentity({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          account.accountName,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.householdDetailAccountNumberLabel(maskAccountNumber(account.accountNumber)),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        _AccountTypePill(accountType: account.accountType),
      ],
    );
  }
}

/// Grey pill showing the localised account type.
class _AccountTypePill extends StatelessWidget {
  const _AccountTypePill({required this.accountType});

  final String accountType;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceDisabled,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        context.l10n.householdDetailAccountTypeLabel(accountType),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Right column of a row: current value, YTD return pill, and its label.
class _AccountPerformance extends StatelessWidget {
  const _AccountPerformance({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final isPositive = account.aumChangePercentage >= 0;
    final returnColor = isPositive ? colors.statusSuccess : colors.statusError;
    final returnSign = isPositive ? '+' : '-';
    final returnPercent = account.aumChangePercentage.abs();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Value and percentage roll off one clock so the pair lands together,
        // and wait for the row to scroll into view. Both start at
        // [_entranceFraction] of their real figure rather than at zero: the
        // column is end-aligned, so a changing digit count would shuffle it
        // sideways on every frame.
        FigureReveal(
          revealOnScroll: true,
          duration: AppMotion.settle,
          builder: (context, t) => Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                compactDollar(lerpDouble(account.currentValue * _entranceFraction, account.currentValue, t)!),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
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
                    '${lerpDouble(returnPercent * _entranceFraction, returnPercent, t)!.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: returnColor,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.dashboardYtdChangeLabel,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_detailed_data.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/charm.dart';

/// Blue-tinted header card shown at the top of the real-time detailed view —
/// account holder initials, name, and account number, with a circular swap
/// button that pops back so the advisor can pick a different account.
class RealTimeAccountSelectionCard extends StatelessWidget {
  /// Creates a [RealTimeAccountSelectionCard].
  const RealTimeAccountSelectionCard({required this.data, required this.onChange, super.key});

  /// The account whose identity is displayed.
  final RealTimeDetailedData data;

  /// Called when the advisor taps the swap button.
  final VoidCallback onChange;

  /// Derives up to two initials from the account name.
  String get _initials {
    final parts = data.accountName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        border: Border.all(color: AppColors.blue200),
        borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
      ),
      child: Row(
        children: [
          // ── Avatar — initials in a 40×40 circle, filled a step deeper than
          // the card behind it ──
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.blue100, shape: BoxShape.circle),
            child: Text(
              _initials,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: colors.textBrandNavyBlue,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Text(
                  data.accountName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colors.textPrimary,
                    height: 16 / 14,
                  ),
                ),
                Text(
                  l10n.householdDetailAccountNumberLabel(data.accountNumber),
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // ── Change button — swap icon in a 30×30 circular ink target,
          // matching the avatar's fill ──
          Material(
            type: MaterialType.transparency,
            child: Tooltip(
              message: l10n.realTimeChangeAccount,
              child: InkWell(
                onTap: onChange,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.blue100, shape: BoxShape.circle),
                  child: Iconify(Charm.swap_horizontal, size: 12, color: colors.textBrandNavyBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

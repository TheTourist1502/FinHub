import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/charm.dart';

/// "Select Client" card shown at the top of every New Service Request
/// business-function form — displays the client carried over from the New
/// Service Request screen with a circular swap button that pops back to let
/// the advisor pick a different one.
///
/// Shared by the Account Maintenance and Online Access service request
/// forms, and by Presentation Mode's client detail screen.
class ClientSelectionCard extends StatelessWidget {
  /// Creates a [ClientSelectionCard].
  const ClientSelectionCard({required this.clientName, required this.subtitle, required this.onChange, super.key});

  /// The selected client's display name, e.g. "Liam Anderson".
  final String clientName;

  /// Fully-formatted subtitle line, e.g. "Account • XYZ127382" or
  /// "Household • #882910". Callers format their own prefix so this widget
  /// stays agnostic to what kind of client is selected.
  final String subtitle;

  /// Called when the advisor taps the swap button.
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final initials = _initials(clientName);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        border: Border.all(color: AppColors.purple200),
        borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
      ),
      child: Row(
        children: [
          // ── Avatar — initials in a bordered 36×36 circle, filled a step
          // deeper than the card behind it ──
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.purple100,
              shape: BoxShape.circle,
              // border: Border.fromBorderSide(BorderSide(color: AppColors.purple200)),
            ),
            child: Text(
              initials,
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
              children: [
                Text(
                  clientName,
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
                  subtitle,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // ── Change button — swap icon in a bordered 36×36 circular ink
          // target, matching the avatar's fill ──
          Material(
            type: MaterialType.transparency,
            child: Tooltip(
              message: l10n.commonButtonChange,
              child: InkWell(
                onTap: onChange,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.purple100,
                    shape: BoxShape.circle,
                    // border: Border.fromBorderSide(BorderSide(color: AppColors.purple200)),
                  ),
                  child: Iconify(Charm.swap_horizontal, size: 12, color: colors.textBrandNavyBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}

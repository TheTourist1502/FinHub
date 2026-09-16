import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/utils/formatters/advisor_id_formatter.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';
import 'package:finhub/shared/widgets/layout/user_avatar_badge.dart';
import 'package:flutter/material.dart';

/// The "Select FA" field on the advisor picker: shows the pending selection
/// and opens the advisor sheet when tapped.
///
/// Looks like a dropdown but is a plain tappable surface — the option list has
/// its own search and belongs in a sheet, not a menu anchored to this field.
///
/// Prop-driven with no Riverpod dependency, so the screen stays the single
/// place that knows about the draft selection.
class AdvisorSelectionField extends StatelessWidget {
  /// Creates an [AdvisorSelectionField].
  const AdvisorSelectionField({required this.advisor, required this.onTap, super.key});

  /// Currently chosen advisor, or `null` to show the placeholder.
  final AdvisorOption? advisor;

  /// Opens the advisor selection sheet.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final selected = advisor;

    return Semantics(
      button: true,
      label: l10n.selectAdvisorFieldHint,
      value: selected?.fullName,
      child: Material(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
          child: Container(
            // A min height rather than a fixed one so the two-line selected
            // state can grow with the user's text scale instead of clipping.
            constraints: const BoxConstraints(minHeight: 57),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceSm + 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
              border: Border.all(color: colors.borderDefault),
            ),
            child: Row(
              children: [
                if (selected != null) ...[
                  UserAvatarBadge(
                    initials: advisorInitials(selected.fullName),
                    avatarUrl: selected.avatarUrl,
                    backgroundColor: colors.surfaceSunken,
                    textColor: Theme.of(context).colorScheme.primary,
                    initialsBorderColor: colors.textBrandNavyBlue,
                  ),
                  const SizedBox(width: AppDimensions.spaceSm + 2),
                ],
                Expanded(
                  child: selected == null
                      ? Text(
                          l10n.selectAdvisorFieldHint,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: colors.inputHintColor),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${selected.fullName} '
                              '(${formatShortMaskedAdvisorId(selected.financialAdvisorId, visible: 4)})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              selected.companyEmail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
                            ),
                          ],
                        ),
                ),
                const SizedBox(width: AppDimensions.spaceSm),
                Icon(Icons.keyboard_arrow_down, size: 24, color: colors.iconSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Initials shown by [UserAvatarBadge] when the advisor has no picture —
/// first letters of the first two words in [fullName], uppercased.
String advisorInitials(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
}

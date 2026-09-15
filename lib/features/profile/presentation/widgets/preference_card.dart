import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Tappable preference row used by the Profile screen's country, region and
/// language rows.
///
/// `full-app`'s equivalent (`WelcomePreferenceCard`) lives in a `welcome`
/// feature that hasn't been ported to this branch, so this is a fresh,
/// smaller widget built for the profile screen alone rather than a straight
/// port — same shape (icon, label/subtitle, current value, required
/// asterisk, loading state) but with no dependency on unported code.
class ProfilePreferenceCard extends StatelessWidget {
  /// Creates a [ProfilePreferenceCard].
  const ProfilePreferenceCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    super.key,
    this.value,
    this.isRequired = false,
    this.isLoading = false,
  });

  /// `mdi` glyph shown in the leading icon box.
  final String icon;

  final String label;
  final String subtitle;

  /// The current selection's display text; `null` shows no value yet.
  final String? value;

  /// Draws a red asterisk beside [label] when this row is a required field.
  final bool isRequired;

  /// Shows a spinner in place of the chevron while an update is in flight.
  final bool isLoading;

  /// Opens the row's selection sheet; `null` while [isLoading] disables the tap.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: ProfileSectionCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: colors.statusInfoBg, borderRadius: BorderRadius.circular(8)),
                child: Center(child: Iconify(icon, size: 20, color: colors.statusInfoDefault)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurface),
                          ),
                        ),
                        if (isRequired)
                          Text(' *', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: cs.error)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value?.isNotEmpty ?? false ? value! : subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: (value?.isNotEmpty ?? false) ? cs.onSurface : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isLoading)
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary))
              else
                Iconify(Mdi.chevron_right, size: 16, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

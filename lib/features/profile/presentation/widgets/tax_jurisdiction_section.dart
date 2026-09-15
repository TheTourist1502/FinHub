import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Placeholder state codes shown until a real jurisdiction fixture exists.
const _kPlaceholderStates = ['NY', 'FL', 'CA', 'TX', 'CT'];

/// Profile section displaying the advisor's licensed geographies as chips.
///
/// Ported from `full-app` for parity, but — matching `full-app` itself —
/// not composed into either [ProfileScreen] or [LeadershipProfileScreen]
/// yet: there is no jurisdiction fixture behind it, so [states] stays a
/// placeholder until one exists.
class TaxJurisdictionSection extends StatelessWidget {
  /// Creates a [TaxJurisdictionSection].
  const TaxJurisdictionSection({this.states = _kPlaceholderStates, super.key});

  final List<String> states;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSectionHeader(label: context.l10n.profileTaxJurisdictionTitle),
        const SizedBox(height: 12),
        ProfileSectionCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: context.appColors.statusSuccessBg, borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Iconify(Mdi.earth, size: 20, color: context.appColors.statusSuccessDefault)),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.l10n.profileLicensedGeosTitle,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 6, children: states.map((code) => _StateChip(code: code)).toList()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A single bordered chip displaying a US state abbreviation.
class _StateChip extends StatelessWidget {
  const _StateChip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(code, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: colors.textSecondary)),
    );
  }
}

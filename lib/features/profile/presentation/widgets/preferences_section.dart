import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/profile/presentation/widgets/country_preference_row.dart';
import 'package:finhub/features/profile/presentation/widgets/language_preference_row.dart';
import 'package:finhub/features/profile/presentation/widgets/mandatory_fields_note.dart';
import 'package:finhub/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:finhub/features/profile/presentation/widgets/region_preference_row.dart';
import 'package:flutter/material.dart';

/// Profile section for user preferences: country, region/market served, and
/// language selection.
///
/// Composes the independent [CountryPreferenceRow], [RegionPreferenceRow] and
/// [LanguagePreferenceRow] widgets, each owning its own bottom sheet and
/// update loading state.
///
/// The top-client-country row is kept (`TopClientCountryPreferenceRow`) but
/// not composed here — matches `full-app`, which leaves it temporarily
/// hidden while keeping the widget and its provider ready to restore.
class PreferencesSection extends StatelessWidget {
  /// Creates a [PreferencesSection].
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSectionHeader(label: context.l10n.profilePreferencesTitle),
        const SizedBox(height: 12),
        const CountryPreferenceRow(),
        const SizedBox(height: 12),
        const RegionPreferenceRow(),
        const SizedBox(height: 12),
        const LanguagePreferenceRow(),
        const SizedBox(height: 12),
        const MandatoryFieldsNote(),
      ],
    );
  }
}

import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/country_selection_sheet.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Profile preferences row for the advisor's registered (base) country.
///
/// [ProfileData.countryDisplayName] fills the value slot once resolved.
/// Tapping the row opens the shared [showCountrySelectionSheet], which
/// lazily fetches [countriesProvider] only on first open (Riverpod caches it
/// after that). Loading state is driven by [countryPreferenceProvider],
/// independent of the other preference rows' loaders.
class CountryPreferenceRow extends ConsumerWidget {
  /// Creates a [CountryPreferenceRow].
  const CountryPreferenceRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref.watch(countryPreferenceProvider).isLoading;
    final profile = ref.watch(currentProfileProvider).value;
    final countryDisplayName = profile?.countryDisplayName ?? '';

    return ProfilePreferenceCard(
      icon: Mdi.map_marker_radius_outline,
      label: context.l10n.profileCountryLabel,
      subtitle: context.l10n.profileCountrySubtitle,
      value: countryDisplayName.isEmpty ? null : countryDisplayName,
      isRequired: true,
      isLoading: isUpdating,
      onTap: isUpdating ? null : () => _showCountrySheet(context, ref),
    );
  }

  void _showCountrySheet(BuildContext context, WidgetRef ref) {
    final selectedId = ref.read(currentProfileProvider).value?.selectedCountryId;
    unawaited(
      showCountrySelectionSheet(
        context,
        title: context.l10n.profileSelectCountryTitle,
        selectedId: selectedId,
        onSelected: (id) => ref.read(countryPreferenceProvider.notifier).updateCountry(id),
      ),
    );
  }
}

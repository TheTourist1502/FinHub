import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_card.dart';
import 'package:finhub/features/profile/presentation/widgets/region_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Value switches to the "N selected" ICU string past this count, instead of
/// joining every market-served name — keeps the card from wrapping onto
/// several lines once an advisor serves many regions.
const _kJoinedNamesLimit = 2;

/// Profile preferences row for the regions/markets the advisor serves.
///
/// Multi-select, unlike the country/language rows — opens
/// [showRegionSelectionSheet] and drives the `regionIds` preference key via
/// [regionPreferenceProvider].
class RegionPreferenceRow extends ConsumerWidget {
  /// Creates a [RegionPreferenceRow].
  const RegionPreferenceRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref.watch(regionPreferenceProvider).isLoading;
    final profile = ref.watch(currentProfileProvider).value;
    final cachedRegions = profile?.regions ?? const [];
    final selectedIds = profile?.selectedRegionIds ?? const [];
    final regions = ref.watch(regionsProvider).value ?? const [];
    final selectedNames = cachedRegions.isNotEmpty
        ? [for (final r in cachedRegions) '${r.name} ( ${r.marketsServed} )']
        : [
            for (final r in regions)
              if (selectedIds.contains(r.id)) '${r.name} ( ${r.marketsServed} )',
          ];
    final value = selectedNames.isEmpty
        ? null
        : (selectedNames.length > _kJoinedNamesLimit ? context.l10n.selectNSelected(selectedNames.length) : selectedNames.join(', '));

    return ProfilePreferenceCard(
      icon: Mdi.earth,
      label: context.l10n.profileRegionLabel,
      subtitle: context.l10n.profileRegionSubtitle,
      value: value,
      isRequired: true,
      isLoading: isUpdating,
      onTap: isUpdating ? null : () => _showRegionSheet(context, ref, selectedIds),
    );
  }

  void _showRegionSheet(BuildContext context, WidgetRef ref, List<int> selectedIds) {
    unawaited(
      showRegionSelectionSheet(
        context,
        title: context.l10n.profileSelectRegionTitle,
        selectedIds: selectedIds,
        onSelected: (ids) => ref.read(regionPreferenceProvider.notifier).updateRegions(ids),
      ),
    );
  }
}

import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/country_selection_sheet.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Profile preferences row for the advisor's top client's country.
///
/// Reuses the same [showCountrySelectionSheet] as [CountryPreferenceRow] —
/// the country picker is shared — but drives the separate
/// `topClientCountryId` preference key via
/// [topClientCountryPreferenceProvider], so selecting one field never
/// touches the other's loading state or value.
///
/// Kept, but not composed into [ProfileScreen] — mirrors `full-app`, which
/// hides this row for the same reason (temporarily out of scope) while
/// keeping the widget and its provider ready to restore.
class TopClientCountryPreferenceRow extends ConsumerWidget {
  /// Creates a [TopClientCountryPreferenceRow].
  const TopClientCountryPreferenceRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref.watch(topClientCountryPreferenceProvider).isLoading;
    final profile = ref.watch(currentProfileProvider).value;
    final selectedId = profile?.selectedTopClientCountryId;
    final displayName = profile?.topClientCountryDisplayName ?? '';

    return ProfilePreferenceCard(
      icon: Mdi.flag_outline,
      label: context.l10n.profileTopClientCountryLabel,
      subtitle: context.l10n.profileTopClientCountrySubtitle,
      value: displayName.isEmpty ? null : displayName,
      isLoading: isUpdating,
      onTap: isUpdating ? null : () => _showCountrySheet(context, ref, selectedId),
    );
  }

  void _showCountrySheet(BuildContext context, WidgetRef ref, int? selectedId) {
    unawaited(
      showCountrySelectionSheet(
        context,
        title: context.l10n.profileSelectTopClientCountryTitle,
        selectedId: selectedId,
        onSelected: (id) => ref.read(topClientCountryPreferenceProvider.notifier).updateTopClientCountry(id),
      ),
    );
  }
}

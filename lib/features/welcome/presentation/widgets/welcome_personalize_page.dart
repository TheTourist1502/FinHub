import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/country_selection_sheet.dart';
import 'package:finhub/features/profile/presentation/widgets/language_selection_sheet.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_card.dart';
import 'package:finhub/features/profile/presentation/widgets/region_selection_sheet.dart';
import 'package:finhub/features/welcome/presentation/providers/welcome_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Value switches to the "N selected" ICU string past this count, instead of
/// joining every market-served name — mirrors `RegionPreferenceRow`'s
/// threshold in Profile.
const _kJoinedNamesLimit = 2;

/// Second page of the welcome carousel — regional-preference selection
/// (Advisor Base Country / Region Served / Language). The CTA button and
/// pagination dots are rendered by [WelcomeScreen] as a persistent footer
/// shared with the first page.
///
/// Every card stages its selection into [welcomeDraftProvider] — no fixture
/// write happens here. [WelcomeScreen]'s "Continue" button submits the whole
/// draft in one call via [welcomeSubmitProvider].
class WelcomePersonalizePage extends ConsumerWidget {
  /// Creates a [WelcomePersonalizePage].
  const WelcomePersonalizePage({required this.onBack, super.key});

  /// Called when the back arrow is tapped — returns to the first page.
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final draft = ref.watch(welcomeDraftProvider);
    final countriesAsync = ref.watch(countriesProvider);
    final regionsAsync = ref.watch(regionsProvider);
    final countries = countriesAsync.asData?.value ?? const [];
    final regions = regionsAsync.asData?.value ?? const [];
    final isSubmitting = ref.watch(welcomeSubmitProvider).isLoading;
    // Skeletons cover only the initial country/region fetch — e.g. a
    // returning advisor's already-saved countryId/regionIds can't resolve to
    // a display name until these lists arrive, so without this the card
    // would flash its "Select ..." placeholder first. Submission itself
    // shows no loader on the cards; the "Continue" button carries that
    // spinner instead.
    final isCountriesLoading = countriesAsync.isLoading;
    final isRegionsLoading = regionsAsync.isLoading;

    String? countryLabel(int? id) {
      if (id == null) return null;
      for (final c in countries) {
        if (c.id == id) return '${c.name} ( ${c.isoCode} )';
      }
      return null;
    }

    final regionNames = <int, String>{for (final r in regions) r.id: '${r.name} ( ${r.marketsServed} )'};
    final selectedRegionNames = [
      for (final id in draft.regionIds)
        if (regionNames[id] != null) regionNames[id]!,
    ];
    final regionLabel = selectedRegionNames.isEmpty
        ? null
        : (selectedRegionNames.length > _kJoinedNamesLimit
              ? l10n.selectNSelected(selectedRegionNames.length)
              : selectedRegionNames.join(', '));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Back arrow ────────────────────────────────────────────────
          IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            icon: Iconify(Mdi.arrow_left, color: colors.iconPrimary),
          ),
          const SizedBox(height: 12),

          // ── Title / subtitle ─────────────────────────────────────────
          // Full-width SizedBox — the parent Column uses crossAxisAlignment
          // .start (needed for the back arrow), so without it each Text
          // would shrink to its own content width and TextAlign.center
          // would have no wider box to center within.
          SizedBox(
            width: double.infinity,
            child: Text(
              l10n.welcomePersonalizeTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 23,
                height: 1.2,
                color: colors.textBrandNavyBlue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Text(
              l10n.welcomePersonalizeSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 13, height: 1.5, color: colors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),

          // ── Preference cards ─────────────────────────────────────────
          // Order matches the Figma "Preferences" group: Advisor Base
          // Country → Region/Market Served → Language. Top Client Country
          // stays on the Profile screen alone, matching the reference
          // branch's onboarding, which hides that card here too.
          ProfilePreferenceCard(
            icon: Mdi.map_marker_radius_outline,
            label: l10n.welcomeAdvisorCountryLabel,
            subtitle: l10n.welcomeAdvisorCountrySubtitle,
            value: countryLabel(draft.countryId),
            isRequired: true,
            isValueLoading: isCountriesLoading,
            onTap: isSubmitting
                ? null
                : () => unawaited(
                    showCountrySelectionSheet(
                      context,
                      title: l10n.profileSelectCountryTitle,
                      selectedId: draft.countryId,
                      onSelected: (id) => ref.read(welcomeDraftProvider.notifier).setCountry(id),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          ProfilePreferenceCard(
            icon: Mdi.earth,
            label: l10n.welcomeRegionLabel,
            subtitle: l10n.welcomeRegionSubtitle,
            value: regionLabel,
            isRequired: true,
            isValueLoading: isRegionsLoading,
            onTap: isSubmitting
                ? null
                : () => unawaited(
                    showRegionSelectionSheet(
                      context,
                      title: l10n.profileSelectRegionTitle,
                      selectedIds: draft.regionIds,
                      onSelected: (ids) => ref.read(welcomeDraftProvider.notifier).setRegions(ids),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          ProfilePreferenceCard(
            icon: Mdi.translate,
            label: l10n.welcomeLanguageLabel,
            subtitle: l10n.welcomeLanguageSubtitle,
            value: 'English',
            isRequired: true,
            onTap: isSubmitting
                ? null
                : () => unawaited(showLanguageSelectionSheet(context, title: l10n.profileSelectLangTitle)),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.welcomePersonalizeMandatoryNote,
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 11, color: colors.statusErrorDefault),
          ),
        ],
      ),
    );
  }
}

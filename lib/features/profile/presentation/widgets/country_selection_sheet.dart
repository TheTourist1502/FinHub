import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_selection_option.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_sheet_shimmer.dart';
import 'package:finhub/shared/widgets/inputs/app_select_sheet_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Padding of the option list, shared with the loading skeleton so rows don't
/// shift when the real countries arrive.
const _kListPadding = EdgeInsets.fromLTRB(kPreferenceSheetInset, kPreferenceSheetDividerGap, kPreferenceSheetInset, 48);

/// Opens the shared country-selection bottom sheet, backed by [countriesProvider].
///
/// Reused by both country-picking rows on the Profile screen — the residence
/// country and the top-client-country — so [title] and [selectedId] let each
/// caller reuse the same country list for a different field.
Future<void> showCountrySelectionSheet(
  BuildContext context, {
  required String title,
  required int? selectedId,
  required ValueChanged<int> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    builder: (_) => _CountrySelectionSheet(title: title, selectedId: selectedId, onSelected: onSelected),
  );
}

/// Bottom sheet content listing [countriesProvider], radio-style, with a
/// search field filtering by country name or ISO code.
class _CountrySelectionSheet extends ConsumerStatefulWidget {
  const _CountrySelectionSheet({required this.title, required this.selectedId, required this.onSelected});

  final String title;
  final int? selectedId;
  final ValueChanged<int> onSelected;

  @override
  ConsumerState<_CountrySelectionSheet> createState() => _CountrySelectionSheetState();
}

class _CountrySelectionSheetState extends ConsumerState<_CountrySelectionSheet> {
  final _searchController = TextEditingController();

  /// Current search text, lower-cased on write so filtering doesn't
  /// re-normalise it on every rebuild.
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countriesAsync = ref.watch(countriesProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PreferenceBottomSheetHeader(title: widget.title),
          SelectSheetSearchField(
            controller: _searchController,
            onQueryChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
            padding: const EdgeInsets.fromLTRB(kPreferenceSheetInset, 0, kPreferenceSheetInset, kPreferenceSheetDividerGap),
          ),
          const PreferenceSheetHeaderDivider(),
          Flexible(
            child: countriesAsync.when(
              data: (countries) {
                final matches = _query.isEmpty
                    ? countries
                    : [
                        for (final c in countries)
                          if (c.name.toLowerCase().contains(_query) || c.isoCode.toLowerCase().contains(_query)) c,
                      ];
                if (matches.isEmpty) return PreferenceSheetMessage(text: context.l10n.commonNoRecordFound);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * kPreferenceSheetListHeightFactor),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: _kListPadding,
                    itemCount: matches.length,
                    separatorBuilder: (_, i) =>
                        PreferenceSheetSeparator(showLine: matches[i].id != widget.selectedId && matches[i + 1].id != widget.selectedId),
                    itemBuilder: (_, i) {
                      final country = matches[i];
                      return PreferenceSelectionOption(
                        code: country.isoCode,
                        name: country.name,
                        isSelected: country.id == widget.selectedId,
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onSelected(country.id);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const PreferenceSheetShimmer(showCodeBadge: true, listPadding: _kListPadding),
              error: (_, _) => PreferenceSheetMessage(text: context.l10n.commonNoRecordFound),
            ),
          ),
        ],
      ),
    );
  }
}

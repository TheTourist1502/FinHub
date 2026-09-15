import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_selection_option.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_sheet_shimmer.dart';
import 'package:finhub/shared/widgets/inputs/app_select_sheet_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Padding of the option list, shared with the loading skeleton so rows don't
/// shift when the real regions arrive.
const _kListPadding = EdgeInsets.fromLTRB(kPreferenceSheetInset, kPreferenceSheetDividerGap, kPreferenceSheetInset, 16);

/// Opens the shared region/market-served multi-select bottom sheet, backed by
/// [regionsProvider].
///
/// Unlike [showCountrySelectionSheet], selections are staged locally and only
/// applied when "Save" is tapped, since multiple regions can be picked in one
/// visit.
Future<void> showRegionSelectionSheet(
  BuildContext context, {
  required String title,
  required List<int> selectedIds,
  required ValueChanged<List<int>> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    builder: (_) => _RegionSelectionSheet(title: title, selectedIds: selectedIds, onSelected: onSelected),
  );
}

/// Bottom sheet content listing [regionsProvider], checkbox-style, with a
/// search field filtering by region name or markets-served label.
class _RegionSelectionSheet extends ConsumerStatefulWidget {
  const _RegionSelectionSheet({required this.title, required this.selectedIds, required this.onSelected});

  final String title;
  final List<int> selectedIds;
  final ValueChanged<List<int>> onSelected;

  @override
  ConsumerState<_RegionSelectionSheet> createState() => _RegionSelectionSheetState();
}

class _RegionSelectionSheetState extends ConsumerState<_RegionSelectionSheet> {
  /// Locally staged selection — not applied to [widget.onSelected] until
  /// "Save" is tapped, so browsing the list doesn't fire partial updates.
  late Set<int> _staged;

  final _searchController = TextEditingController();

  /// Current search text, lower-cased on write so filtering doesn't
  /// re-normalise it on every rebuild.
  String _query = '';

  @override
  void initState() {
    super.initState();
    _staged = Set<int>.from(widget.selectedIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(int id) {
    setState(() {
      if (!_staged.add(id)) _staged.remove(id);
    });
  }

  void _save() {
    Navigator.of(context).pop();
    widget.onSelected(_staged.toList());
  }

  @override
  Widget build(BuildContext context) {
    final regionsAsync = ref.watch(regionsProvider);

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
            child: regionsAsync.when(
              data: (regions) {
                final matches = _query.isEmpty
                    ? regions
                    : [
                        for (final r in regions)
                          if (r.name.toLowerCase().contains(_query) || r.marketsServed.toLowerCase().contains(_query)) r,
                      ];
                if (matches.isEmpty) return PreferenceSheetMessage(text: context.l10n.commonNoRecordFound);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * kPreferenceSheetListHeightFactor),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: _kListPadding,
                    itemCount: matches.length,
                    separatorBuilder: (_, i) =>
                        PreferenceSheetSeparator(showLine: !_staged.contains(matches[i].id) && !_staged.contains(matches[i + 1].id)),
                    itemBuilder: (_, i) {
                      final region = matches[i];
                      return PreferenceMultiSelectionOption(
                        name: '${region.name} ( ${region.marketsServed} )',
                        isSelected: _staged.contains(region.id),
                        onTap: () => _toggle(region.id),
                      );
                    },
                  ),
                );
              },
              loading: () => const PreferenceSheetShimmer(showCodeBadge: false, listPadding: _kListPadding),
              error: (_, _) => PreferenceSheetMessage(text: context.l10n.commonNoRecordFound),
            ),
          ),
          const PreferenceSheetHeaderDivider(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_staged.isEmpty) ...[
                    Text(
                      context.l10n.profileRegionSelectionRequired,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(context.l10n.commonButtonCancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                          onPressed: _staged.isEmpty ? null : _save,
                          child: Text(context.l10n.commonButtonSave),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

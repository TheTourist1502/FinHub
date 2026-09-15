import 'package:finhub/features/profile/presentation/widgets/preference_selection_option.dart';
import 'package:flutter/material.dart';

/// Opens the language-selection bottom sheet.
///
/// `full-app` offers en/es/pt-BR here; this branch has Spanish and Hindi
/// localisation paused (only `app_en.arb` is active — see `l10n.yaml`), so
/// the sheet lists English alone, already selected, rather than offering
/// languages with no translations behind them. Tapping the row still opens
/// this sheet — matching the row's tappable affordance everywhere else on
/// the screen — but there is nothing to pick, so it simply closes.
Future<void> showLanguageSelectionSheet(BuildContext context, {required String title}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    builder: (_) => _LanguageSelectionSheet(title: title),
  );
}

/// Single-row sheet content: English, already selected.
class _LanguageSelectionSheet extends StatelessWidget {
  const _LanguageSelectionSheet({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PreferenceBottomSheetHeader(title: title, bottomGap: kPreferenceSheetDividerGap),
        const PreferenceSheetHeaderDivider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(kPreferenceSheetInset, kPreferenceSheetDividerGap, kPreferenceSheetInset, 48),
          child: PreferenceSelectionOption(
            code: 'EN',
            name: 'English',
            isSelected: true,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}

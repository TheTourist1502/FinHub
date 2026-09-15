import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/profile/presentation/widgets/language_selection_sheet.dart';
import 'package:finhub/features/profile/presentation/widgets/preference_card.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Profile preferences row for the app display language.
///
/// Spanish and Hindi localisation are paused on this branch (only
/// `app_en.arb` is active), so this row always shows "English" and its
/// sheet offers no other choice — see [showLanguageSelectionSheet]. There is
/// no persistence to trigger, so this row carries no loading state of its
/// own, unlike the country/region rows.
class LanguagePreferenceRow extends StatelessWidget {
  /// Creates a [LanguagePreferenceRow].
  ///
  /// [isRequired] draws the required-field asterisk. Defaults to `true` for
  /// the advisor profile, where the row sits beside other mandatory
  /// preferences under a shared legend. Pass `false` where no legend
  /// accompanies it — see `LeadershipProfileScreen`.
  const LanguagePreferenceRow({super.key, this.isRequired = true});

  /// Whether to mark the row as a required field.
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return ProfilePreferenceCard(
      icon: Mdi.translate,
      label: context.l10n.profileLanguageLabel,
      subtitle: context.l10n.profileLanguageSubtitle,
      value: 'English',
      isRequired: isRequired,
      onTap: () => unawaited(showLanguageSelectionSheet(context, title: context.l10n.profileSelectLangTitle)),
    );
  }
}

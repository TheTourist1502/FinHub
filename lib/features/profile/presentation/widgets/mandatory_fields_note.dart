import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Legend explaining the asterisk drawn beside required preference rows.
///
/// Only meaningful next to a row that actually renders one — a section with
/// no required field must leave it out rather than show a legend for a
/// marker that is not on screen.
class MandatoryFieldsNote extends StatelessWidget {
  /// Creates a [MandatoryFieldsNote].
  const MandatoryFieldsNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.profileMandatoryFieldsNote,
      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 11, color: context.appColors.statusErrorDefault),
    );
  }
}

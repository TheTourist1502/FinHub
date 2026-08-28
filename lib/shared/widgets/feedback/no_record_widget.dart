import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displayed in place of a list when no records match the current query or filter.
class NoRecordWidget extends StatelessWidget {
  /// Creates a [NoRecordWidget].
  const NoRecordWidget({super.key, this.widthFactor = 0.35, this.message});

  /// Fraction of the screen width the illustration occupies, from 0.0 to 1.0.
  ///
  /// Defaults to `0.5` (50% of the screen width). Pass a smaller value for
  /// compact placements such as cards or bottom sheets, or a larger one for
  /// full-screen empty states.
  final double widthFactor;

  /// Message shown under the illustration.
  ///
  /// Defaults to [AppLocalizations.commonNoRecordFound]. Pass a feature-specific
  /// message (e.g. "No tasks match your search") when the generic copy doesn't fit.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/no_record_found.svg',
              width: MediaQuery.sizeOf(context).width * widthFactor,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? context.l10n.commonNoRecordFound,
              style: AppTypography.text14.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

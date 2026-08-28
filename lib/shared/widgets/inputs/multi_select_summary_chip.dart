import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Header chip showing how many options are selected, with a clear action.
///
/// Rebuilds off [selection] alone so the sheet chrome around it stays put;
/// renders nothing while the selection is empty.
class MultiSelectSummaryChip<T> extends StatelessWidget {
  /// Displays the count in [selection] and calls [onClear] when dismissed.
  const MultiSelectSummaryChip({
    required this.selection,
    required this.onClear,
    super.key,
  });

  /// Live set of chosen values owned by the sheet.
  final ValueListenable<Set<T>> selection;

  /// Clears the whole selection.
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<Set<T>>(
      valueListenable: selection,
      builder: (context, selected, _) {
        if (selected.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spaceMd,
            AppDimensions.spaceSx,
            AppDimensions.spaceMd,
            AppDimensions.spaceSm,
          ),
          child: Row(
            children: [
              Chip(
                label: Text(
                  context.l10n.selectNSelected(selected.length),
                  style: AppTypography.chipLabel.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                onDeleted: onClear,
                side: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                ),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceSx),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        );
      },
    );
  }
}

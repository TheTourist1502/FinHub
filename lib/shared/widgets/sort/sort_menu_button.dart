import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// A single option available in the sort dropdown menu.
class SortField {
  /// Creates a [SortField].
  ///
  /// [popupLabel] overrides the label shown inside the popup menu; when
  /// omitted the popup falls back to [label].
  const SortField({required this.id, required this.label, this.popupLabel});

  /// Unique identifier used to compare the active field.
  final String id;

  /// Localised display label shown in the button row (prefixed with "Sort By").
  final String label;

  /// Optional shorter label shown inside the popup menu only.
  final String? popupLabel;
}

/// A button that shows the active sort field label with a directional arrow,
/// and on tap opens a floating overlay menu to change the sort option.
///
/// Behaviour:
/// - Tapping a **non-active** option activates it, defaulting to descending.
/// - Tapping the **active** option toggles ascending ↔ descending.
///
/// All state lives in the parent; this widget is purely presentational.
class SortMenuButton extends StatelessWidget {
  /// Creates a [SortMenuButton].
  const SortMenuButton({
    required this.fields,
    required this.activeFieldId,
    required this.isDescending,
    required this.onChanged,
    super.key,
  });

  /// All available sort options shown in the overlay menu.
  final List<SortField> fields;

  /// [SortField.id] of the currently active field.
  final String activeFieldId;

  /// Whether the current sort direction is descending (`true`) or ascending.
  final bool isDescending;

  /// Called with `fieldId` and named `descending` when the user picks an option.
  final void Function(String fieldId, {required bool descending}) onChanged;

  /// Font size of the button's own label, used to keep [rowLabelStyle]'s
  /// line height in sync with it.
  static const double _labelFontSize = 13;

  /// Line-height multiplier of the button's own label, used to keep
  /// [rowLabelStyle]'s line height in sync with it.
  static const double _labelLineHeight = 1.1;

  /// Shared style for the row label that sits beside a [SortMenuButton]
  /// (e.g. "24 ACCOUNTS"), so every screen that pairs a count/header label
  /// with this button renders it identically.
  ///
  /// The line height is computed to match the button's own label — 13sp at
  /// a 1.1 multiplier — so both sides of the row align even though this
  /// label uses a different font size.
  static TextStyle rowLabelStyle(BuildContext context) {
    const fontSize = 12.0;
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: context.appColors.textSecondary,
      letterSpacing: 0.4,
      height: _labelFontSize * _labelLineHeight / fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final active = fields.firstWhere(
      (f) => f.id == activeFieldId,
      orElse: () => fields.first,
    );

    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          /// Opens the sort field picker popup. Hidden when there's only one
          /// field, since there's nothing to pick between.
          if (fields.length > 1)
            SizedBox(
              width: 20,
              height: 20,
              child: InkWell(
                onTap: () => _showSortMenu(context),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Iconify(
                    Mdi.sort,
                    color: colors.textPrimary,
                    size: 14,
                  ),
                ),
              ),
            ),

          /// Toggles direction for the current active field.
          Flexible(
            child: InkWell(
              onTap: () => onChanged(activeFieldId, descending: !isDescending),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        '${l10n.commonSortBy} ${active.label}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.interactiveDefault,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      isDescending ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                      color: colors.interactiveDefault,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSortMenu(BuildContext context) async {
    final colors = context.appColors;
    final activeBg = Theme.of(context).colorScheme.primaryContainer;
    final l10n = context.l10n;
    final box = context.findRenderObject()! as RenderBox;
    final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero, ancestor: overlay);
    final position = RelativeRect.fromLTRB(
      origin.dx,
      origin.dy + box.size.height,
      overlay.size.width - origin.dx - box.size.width,
      overlay.size.height - origin.dy - box.size.height,
    );

    final selectedId = await showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colors.surfaceDefault,
      menuPadding: const EdgeInsets.all(8),
      items: [
        /// Non-interactive heading.
        PopupMenuItem<String>(
          enabled: false,
          height: 0,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Text(
                  l10n.commonSortBy,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1, color: colors.borderDefault),
              const SizedBox(height: 4),
            ],
          ),
        ),
        ...fields.map((field) {
          final isActive = field.id == activeFieldId;
          return PopupMenuItem<String>(
            value: field.id,
            height: 0,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? activeBg : null,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                field.popupLabel ?? field.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? colors.interactiveDefault : colors.textPrimary,
                ),
              ),
            ),
          );
        }),
      ],
    );

    if (selectedId == null) return;
    if (!context.mounted) return;

    final newDescending = selectedId != activeFieldId || !isDescending;
    onChanged(selectedId, descending: newDescending);
  }
}

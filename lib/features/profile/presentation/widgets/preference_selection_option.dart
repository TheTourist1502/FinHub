import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Gap below the drag handle and below the title row — the tight rhythm that
/// binds a preference sheet's header blocks together.
const kPreferenceSheetGap = 4.0;

/// Gap on either side of [PreferenceSheetHeaderDivider] — below the search
/// field and above the content — setting the header apart from the body.
const kPreferenceSheetDividerGap = 10.0;

/// Horizontal inset of every preference sheet's content, matched by the
/// search field passed beneath [PreferenceBottomSheetHeader].
const kPreferenceSheetInset = 16.0;

/// Fraction of the screen a preference sheet's option list may occupy.
///
/// The loading skeleton claims the same height, so the sheet opens at its
/// settled size instead of growing when the options arrive.
const kPreferenceSheetListHeightFactor = 0.5;

/// Tap target / ink ripple size of the header's close button.
const _kCloseButtonSize = 32.0;

/// Drawn size of the close glyph inside [_kCloseButtonSize].
const _kCloseGlyphSize = 14.0;

/// Drag handle + uppercase title + close button shared by the country,
/// region, language and avatar-picker bottom sheets.
class PreferenceBottomSheetHeader extends StatelessWidget {
  /// Creates a [PreferenceBottomSheetHeader].
  const PreferenceBottomSheetHeader({required this.title, super.key, this.bottomGap = kPreferenceSheetGap});

  final String title;

  /// Gap left below the title row. Defaults to the tight header rhythm, which
  /// suits a search field following it; sheets without one pass
  /// [kPreferenceSheetDividerGap] so the divider still gets its full clearance.
  final double bottomGap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        // ── Drag handle ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: kPreferenceSheetGap),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: colors.borderDefault, borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        // ── Header ──────────────────────────────────────────────────────
        Padding(
          // Right inset is the content inset minus the close button's own
          // overhang — see [_kCloseButtonSize] — so the glyph, not the ripple
          // circle, lines up with the search field and rows below.
          padding: EdgeInsets.fromLTRB(
            kPreferenceSheetInset,
            0,
            kPreferenceSheetInset - (_kCloseButtonSize - _kCloseGlyphSize) / 2,
            bottomGap,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                    letterSpacing: 0.25,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: kPreferenceSheetInset),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: _kCloseButtonSize, height: _kCloseButtonSize),
                icon: Iconify(Mdi.close, size: _kCloseGlyphSize, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Full-width 1px rule closing a preference sheet's header, below the search
/// field (or the title row, in sheets without one) and above the content.
class PreferenceSheetHeaderDivider extends StatelessWidget {
  /// Creates a [PreferenceSheetHeaderDivider].
  const PreferenceSheetHeaderDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant);
}

/// Total height of a [PreferenceSheetSeparator]: a 1px rule with 2px of
/// clearance above and below it.
const kPreferenceSheetSeparatorHeight = 5.0;

/// Hairline rule between two rows in a preference selection sheet.
///
/// Pass `showLine: false` for a separator touching a selected row: that row
/// already draws its own border, so a rule against it would read as a double
/// edge. The 5px of space is still reserved either way.
class PreferenceSheetSeparator extends StatelessWidget {
  /// Creates a [PreferenceSheetSeparator].
  const PreferenceSheetSeparator({super.key, this.showLine = true});

  /// Whether to paint the rule. `false` keeps the spacing but hides the line.
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    if (!showLine) return const SizedBox(height: kPreferenceSheetSeparatorHeight);
    return Divider(
      height: kPreferenceSheetSeparatorHeight,
      thickness: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

/// Centered message shown in place of a selection list (empty or error state).
///
/// Claims the same [kPreferenceSheetListHeightFactor] slice the loaded list
/// and the loading skeleton do, so the sheet stays one height across states.
class PreferenceSheetMessage extends StatelessWidget {
  /// Creates a [PreferenceSheetMessage].
  const PreferenceSheetMessage({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * kPreferenceSheetListHeightFactor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: kPreferenceSheetInset),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: context.appColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

/// Single radio-style option row shared by the language and country bottom sheets.
///
/// [code] is shown as a short badge (language code or ISO country code); [name]
/// is the full display name.
class PreferenceSelectionOption extends StatelessWidget {
  /// Creates a [PreferenceSelectionOption].
  const PreferenceSelectionOption({
    required this.code,
    required this.name,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String code;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.duration(context, AppMotion.quick),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple50 : Colors.transparent,
          border: Border.all(color: isSelected ? AppColors.purple200 : Colors.transparent),
          borderRadius: BorderRadius.circular(isSelected ? 8 : 4),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.duration(context, AppMotion.quick),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colors.interactiveDefault : colors.borderDefault,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: colors.interactiveDefault),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            AnimatedContainer(
              duration: AppMotion.duration(context, AppMotion.quick),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? colors.interactiveDefault : AppColors.purple50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  code,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: isSelected ? Colors.white : colors.interactiveDefault,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: isSelected ? Theme.of(context).colorScheme.onSurface : colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Checkbox-style option row shared by multi-select bottom sheets (e.g. the
/// region/market-served picker).
///
/// Sibling of [PreferenceSelectionOption], which is radio-style
/// (single-select) and also shows a short code badge; regions have no
/// short code, so this variant shows only the checkbox and [name].
class PreferenceMultiSelectionOption extends StatelessWidget {
  /// Creates a [PreferenceMultiSelectionOption].
  const PreferenceMultiSelectionOption({required this.name, required this.isSelected, required this.onTap, super.key});

  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.duration(context, AppMotion.quick),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple50 : Colors.transparent,
          border: Border.all(color: isSelected ? AppColors.purple200 : Colors.transparent),
          borderRadius: BorderRadius.circular(isSelected ? 8 : 4),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.duration(context, AppMotion.quick),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? colors.interactiveDefault : Colors.transparent,
                border: Border.all(color: isSelected ? colors.interactiveDefault : colors.borderDefault, width: 1.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isSelected ? const Center(child: Iconify(Mdi.check, size: 14, color: Colors.white)) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  height: 16 / 13,
                  color: isSelected ? Theme.of(context).colorScheme.onSurface : colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

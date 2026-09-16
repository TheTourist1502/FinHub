import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/utils/formatters/advisor_id_formatter.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/providers/leadership_advisor_selection_provider.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/widgets/advisor_selection_field.dart';
import 'package:finhub/shared/widgets/inputs/app_select_sheet_shell.dart';
import 'package:finhub/shared/widgets/layout/user_avatar_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fraction of the screen the advisor list may occupy before it scrolls.
const double _kSheetHeightFactor = 0.75;

/// Opens the financial-advisor picker sheet and resolves to the advisor the
/// user tapped, or `null` if they dismissed it.
///
/// [selectedId] is the `financialAdvisorId` to mark as current; pass `null`
/// when nothing is selected yet.
Future<AdvisorOption?> showAdvisorSelectionSheet(BuildContext context, {required String? selectedId}) {
  return showModalBottomSheet<AdvisorOption>(
    context: context,
    // Scroll-controlled so the sheet can grow past the default half-screen and
    // ride above the keyboard once the search field takes focus.
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AdvisorSelectionSheet(selectedId: selectedId),
  );
}

/// Sheet body: a search field over the in-memory advisor list, and one
/// [_AdvisorOptionTile] per match.
///
/// Reuses [filteredAdvisorListProvider] rather than filtering locally so the
/// roster is fetched once for the session and the query never triggers a
/// request. The query provider outlives this sheet, so the caller of
/// [showAdvisorSelectionSheet] is responsible for clearing it once the sheet
/// closes.
class _AdvisorSelectionSheet extends ConsumerStatefulWidget {
  const _AdvisorSelectionSheet({required this.selectedId});

  /// `financialAdvisorId` of the advisor currently in context, if any.
  final String? selectedId;

  @override
  ConsumerState<_AdvisorSelectionSheet> createState() => _AdvisorSelectionSheetState();
}

class _AdvisorSelectionSheetState extends ConsumerState<_AdvisorSelectionSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final advisorsAsync = ref.watch(filteredAdvisorListProvider);

    return Padding(
      // Lifts the sheet clear of the software keyboard while searching.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      // Material, not a decorated Container: the sheet route's own Material is
      // transparent, so row ripples would otherwise be painted beneath this
      // opaque surface and never seen.
      child: Material(
        color: colors.surfaceDefault,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.borderRadiousMd)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SelectSheetDragHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.spaceMd,
                  0,
                  AppDimensions.spaceMd,
                  AppDimensions.spaceSm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.selectAdvisorHeading,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      color: colors.iconSecondary,
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // The app's shared select-sheet search field, so this sheet's
              // search looks like every other one despite the list itself
              // being bespoke.
              SelectSheetSearchField(
                controller: _searchController,
                hintText: l10n.selectAdvisorSearchHint,
                onQueryChanged: (value) => ref.read(advisorSearchQueryProvider.notifier).update(value),
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.spaceMd,
                  0,
                  AppDimensions.spaceMd,
                  AppDimensions.spaceSm,
                ),
              ),
              const SelectSheetHairline(),
              // Flexible, not Expanded: sized by its content up to the cap
              // below, so a short list is a short sheet.
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * _kSheetHeightFactor),
                  child: advisorsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => _SheetMessage(
                      text: l10n.selectAdvisorLoadFailed,
                      actionLabel: l10n.selectAdvisorRetry,
                      onAction: () => ref.invalidate(advisorListProvider),
                    ),
                    data: (advisors) => advisors.isEmpty
                        // A search matching nothing needs no action; an empty
                        // *roster* leaves a leadership user with no way
                        // forward at all, so that one carries a retry.
                        ? (ref.watch(advisorSearchQueryProvider).trim().isNotEmpty
                              ? _SheetMessage(text: l10n.selectAdvisorEmpty)
                              : _SheetMessage(
                                  text: l10n.selectAdvisorNoneAvailable,
                                  actionLabel: l10n.selectAdvisorRetry,
                                  onAction: () => ref.invalidate(advisorListProvider),
                                ))
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceSm),
                            itemCount: advisors.length,
                            separatorBuilder: (_, _) => Divider(
                              height: 1,
                              indent: AppDimensions.spaceMd,
                              endIndent: AppDimensions.spaceMd,
                              color: colors.borderSubtle,
                            ),
                            itemBuilder: (_, index) {
                              final advisor = advisors[index];
                              return _AdvisorOptionTile(
                                advisor: advisor,
                                isSelected: advisor.financialAdvisorId == widget.selectedId,
                                onTap: () => Navigator.of(context).pop(advisor),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One advisor row: avatar, then `Name (XXmQAL)` over the advisor's email.
///
/// [fullName] can repeat across records, so the row carries a masked id tail
/// bracketed after the name as a disambiguator.
class _AdvisorOptionTile extends StatelessWidget {
  const _AdvisorOptionTile({required this.advisor, required this.isSelected, required this.onTap});

  /// The advisor this row offers.
  final AdvisorOption advisor;

  /// Whether this advisor is the one currently in context.
  final bool isSelected;

  /// Invoked when the row is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: isSelected ? cs.primary.withValues(alpha: 0.125) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd, vertical: AppDimensions.spaceSm + 4),
          child: Row(
            children: [
              UserAvatarBadge(
                initials: advisorInitials(advisor.fullName),
                avatarUrl: advisor.avatarUrl,
                size: 40,
                backgroundColor: colors.surfaceSunken,
                textColor: cs.primary,
                initialsBorderColor: colors.textBrandNavyBlue,
              ),
              const SizedBox(width: AppDimensions.spaceSm + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${advisor.fullName} '
                      '(${formatShortMaskedAdvisorId(advisor.financialAdvisorId, visible: 4).toUpperCase()})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? cs.primary : colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      advisor.companyEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: AppDimensions.spaceSm),
                Icon(Icons.check, size: 20, color: cs.primary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Centred message with an optional retry action.
class _SheetMessage extends StatelessWidget {
  const _SheetMessage({required this.text, this.actionLabel, this.onAction});

  /// Message body.
  final String text;

  /// Label of the action button; omit along with [onAction] for a bare
  /// message.
  final String? actionLabel;

  /// Invoked when the action is pressed.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: colors.textSecondary),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: AppDimensions.spaceSm + 4),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

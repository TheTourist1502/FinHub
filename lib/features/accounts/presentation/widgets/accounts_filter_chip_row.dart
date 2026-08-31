import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/features/accounts/domain/models/accounts_filter_option.dart';
import 'package:finhub/features/accounts/presentation/providers/accounts_provider.dart';
import 'package:finhub/features/accounts/presentation/widgets/accounts_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Horizontal row of account-type filter chips (All / Linked / Standalone).
///
/// Replaced by a shimmer during the first fetch.
class AccountsFilterChipRow extends ConsumerWidget {
  /// Creates an [AccountsFilterChipRow].
  const AccountsFilterChipRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialLoading = ref.watch(
      accountsNotifierProvider.select((s) => s.isLoading && !s.hasValue),
    );
    if (isInitialLoading) return const AccountsFilterChipsShimmer();

    // The scroll view shrink-wraps to the chips' width, so without the
    // [Align] the parent column centres the whole row on wide screens.
    return const Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AccountsFilterChip(option: AccountsFilterOption.all),
            SizedBox(width: 8),
            AccountsFilterChip(option: AccountsFilterOption.householdLinked),
            SizedBox(width: 8),
            AccountsFilterChip(option: AccountsFilterOption.standalone),
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped chip that selects one [AccountsFilterOption].
///
/// Watches the filter provider alone so a selection repaints only the chips.
class AccountsFilterChip extends ConsumerWidget {
  /// Creates an [AccountsFilterChip] for [option].
  const AccountsFilterChip({required this.option, super.key});

  /// The filter this chip selects when tapped.
  final AccountsFilterOption option;

  String _label(AppLocalizations l10n) => switch (option) {
    AccountsFilterOption.all => l10n.accountsFilterAll,
    AccountsFilterOption.householdLinked => l10n.accountsFilterHouseholdLinked,
    AccountsFilterOption.standalone => l10n.accountsFilterStandalone,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(accountsFilterProvider) == option;
    final colors = context.appColors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref.read(accountsFilterProvider.notifier).filter = option,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? colors.bgBrandNavyBlue : colors.surfaceDefault,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: isActive ? colors.bgBrandNavyBlue : colors.borderDefault),
          boxShadow: isActive
              ? const [BoxShadow(color: AppColors.cardShadow, blurRadius: 1, offset: Offset(0, 1))]
              : null,
        ),
        child: Text(
          _label(context.l10n),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? colors.textOnAccent : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/accounts/domain/models/account.dart';
import 'package:finhub/features/accounts/presentation/widgets/account_card.dart';
import 'package:finhub/shared/animations/pressable.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:finhub/shared/widgets/sort/sort_header_row.dart';
import 'package:finhub/shared/widgets/sort/sort_menu_button.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Accounts tab
// ---------------------------------------------------------------------------

/// Accounts tab for the household detail screen.
///
/// Shows a list of all household accounts, each rendered using the shared
/// [AccountCard] widget. Supports sorting by AUM or name via the
/// [SortMenuButton] overlay. Account data comes from the live
/// `/v1/households/{id}/accounts` API response.
class HouseholdsAccountsTab extends StatefulWidget {
  /// Creates a [HouseholdsAccountsTab].
  const HouseholdsAccountsTab({
    required this.accounts,
    required this.onRefresh,
    this.onViewDetails,
    super.key,
  });

  /// All accounts in this household.
  final List<Account> accounts;

  /// Called when the user pulls to refresh.
  final Future<void> Function() onRefresh;

  /// Forwarded to each [AccountCard] — see [AccountCard.onViewDetails].
  final void Function(Account account)? onViewDetails;

  @override
  State<HouseholdsAccountsTab> createState() => _HouseholdsAccountsTabState();
}

class _HouseholdsAccountsTabState extends State<HouseholdsAccountsTab> {
  String _sortField = 'aum';
  bool _sortDescending = true;

  static const _fieldName = 'name';

  List<Account> get _sorted => [...widget.accounts]
    ..sort((a, b) {
      if (_sortField == _fieldName) {
        return _sortDescending ? b.accountName.compareTo(a.accountName) : a.accountName.compareTo(b.accountName);
      }
      return _sortDescending ? b.currentValue.compareTo(a.currentValue) : a.currentValue.compareTo(b.currentValue);
    });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sorted = _sorted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── List header: count | Sort menu ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SortHeaderRow(
                  label: l10n.householdDetailAllAccountsHeader(sorted.length).toUpperCase(),
                  sortMenuButton: sorted.length > 1
                      ? SortMenuButton(
                          fields: [
                            SortField(id: 'aum', label: l10n.dashboardAumLabel),
                            SortField(id: _fieldName, label: l10n.commonName),
                          ],
                          activeFieldId: _sortField,
                          isDescending: _sortDescending,
                          onChanged: (id, {required descending}) => setState(() {
                            _sortField = id;
                            _sortDescending = descending;
                          }),
                        )
                      : null,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Account list ─────────────────────────────────────────────────
            if (sorted.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: NoRecordWidget(message: l10n.householdDetailNoAccountsFound),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 32),
                sliver: SliverList.builder(
                  itemCount: sorted.length,
                  // Rows deal in one at a time as the reader scrolls to them,
                  // the same entrance the accounts list and the sibling
                  // transactions tab use.
                  itemBuilder: (_, i) => SettleIn(
                    index: i,
                    revealOnScroll: true,
                    child: Pressable(
                      child: AccountCard(
                        account: sorted[i],
                        isLast: i == sorted.length - 1,
                        onViewDetails: widget.onViewDetails,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

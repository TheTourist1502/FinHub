import 'dart:async';

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/accounts/domain/models/accounts_filter_option.dart';
import 'package:finhub/features/accounts/presentation/providers/accounts_provider.dart';
import 'package:finhub/features/households/presentation/providers/households_provider.dart';
import 'package:finhub/shared/widgets/inputs/app_pill_tab_bar.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Persistent chrome above both tabs of the Households branch.
///
/// Built by the pathless `ShellRoute` that wraps `/households` and
/// `/accounts`, so the pill switcher and the search box are mounted **once**
/// and stay put while [child] — the routed tab content — is what transitions.
/// Before this, each tab owned its own copy of both and switching tabs slid
/// the entire screen, chrome included.
///
/// Owning the search box for both tabs is why this widget reaches into the
/// accounts providers: there is one field, and its text belongs to whichever
/// tab is currently routed.
class HouseholdsShellScreen extends ConsumerStatefulWidget {
  /// Creates a [HouseholdsShellScreen] around the routed tab [child].
  const HouseholdsShellScreen({required this.location, required this.child, super.key});

  /// The URI currently routed into [child].
  ///
  /// Handed down from the shell route rather than looked up from context: the
  /// route is the single source of truth for which tab is active, and the
  /// callbacks below need it outside `build`.
  final Uri location;

  /// The active tab's content, supplied by the shell route's navigator.
  final Widget child;

  @override
  ConsumerState<HouseholdsShellScreen> createState() => _HouseholdsShellScreenState();
}

class _HouseholdsShellScreenState extends ConsumerState<HouseholdsShellScreen> {
  static const _kSearchDebounce = Duration(milliseconds: 600);

  /// Minimum horizontal fling speed (px/s) that counts as a tab swipe, so a
  /// slow diagonal drag while scrolling the list doesn't change tabs.
  static const _kTabSwipeVelocity = 200.0;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  /// Whether the Accounts tab is the one currently routed into the child slot.
  bool get _isAccountsTab => widget.location.path == AppRoutes.accounts;

  /// `?focusSearch=true` — the dashboard's "Client Search" quick action.
  bool get _wantsSearchFocus => widget.location.queryParameters['focusSearch'] == 'true';

  @override
  void initState() {
    super.initState();
    // Neither query provider is auto-disposed, so a query survives a push to a
    // detail screen. Seed the field from it, or the list comes back filtered
    // by a search the user can no longer see. Seeded before the listener is
    // attached so it doesn't schedule a write of what it just read.
    _searchController.text = _isAccountsTab
        ? ref.read(accountsSearchQueryProvider)
        : ref.read(householdsSearchQueryProvider);
    _searchController.addListener(_onSearchChanged);
    if (_wantsSearchFocus) _focusSearchAfterFrame();
  }

  @override
  void didUpdateWidget(covariant HouseholdsShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The shell outlives a tab switch now, so a deep link asking for focus can
    // arrive while it is already mounted — initState alone would miss it.
    if (_wantsSearchFocus && oldWidget.location.queryParameters['focusSearch'] != 'true') {
      _focusSearchAfterFrame();
    }
  }

  /// Focuses the search box once the current build has been laid out.
  void _focusSearchAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Writes [query] to whichever tab's search provider is on screen.
  void _applyQuery(String query, {required bool isAccountsTab}) {
    if (isAccountsTab) {
      ref.read(accountsSearchQueryProvider.notifier).query = query;
    } else {
      ref.read(householdsSearchQueryProvider.notifier).query = query;
    }
  }

  /// Debounces typing before writing to the active tab's search provider.
  ///
  /// The delay is only worth paying when each write costs a request. Once the
  /// whole list is in memory the filtering is local, so the wait would just
  /// make typing feel laggy.
  ///
  /// The tab is captured now rather than read inside the timer: a switch
  /// cancels the timer, but capturing keeps a late write off the wrong list.
  void _onSearchChanged() {
    final isAccountsTab = _isAccountsTab;
    final state = isAccountsTab
        ? ref.read(accountsNotifierProvider).value?.shouldLazyLoadData
        : ref.read(householdsNotifierProvider).value?.shouldLazyLoadData;
    _debounce?.cancel();
    _debounce = Timer((state ?? true) ? _kSearchDebounce : Duration.zero, () {
      _applyQuery(_searchController.text, isAccountsTab: isAccountsTab);
    });
  }

  /// Applies the empty query immediately once the search field has cleared
  /// itself, bypassing [_kSearchDebounce] since a clear is a decisive action
  /// rather than in-progress typing.
  void _onClearSearch() {
    _debounce?.cancel();
    _applyQuery('', isAccountsTab: _isAccountsTab);
  }

  /// Routes to the tab at [index], resetting the search and filter state the
  /// two tabs no longer own individually.
  ///
  /// A no-op for the tab already on screen, so the pill and the swipe can both
  /// call it unconditionally.
  void _goToTab(int index) {
    final target = index == 0 ? AppRoutes.households : AppRoutes.accounts;
    if (widget.location.path == target) return;

    _searchController.clear();
    _debounce?.cancel();
    ref.read(householdsSearchQueryProvider.notifier).query = '';
    ref.read(accountsSearchQueryProvider.notifier).query = '';
    ref.read(accountsFilterProvider.notifier).filter = AccountsFilterOption.all;
    context.go(target);
  }

  /// Switches tabs on a horizontal fling — left for Accounts, right for
  /// Households. [_goToTab] absorbs a fling towards the tab already shown.
  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity <= -_kTabSwipeVelocity) _goToTab(1);
    if (velocity >= _kTabSwipeVelocity) _goToTab(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAccountsTab = _isAccountsTab;

    // True only for the active tab's very first fetch (or an explicit
    // pull-to-refresh, which resets to a bare loading state) — a debounced
    // search-query change also re-triggers the notifier's build(), but
    // Riverpod carries the previous page across that transition
    // (state.hasValue stays true), so it is excluded here to avoid swapping
    // the search field for a shimmer while the user is actively typing.
    final isInitialLoading = isAccountsTab
        ? ref.watch(accountsNotifierProvider.select((s) => s.isLoading && !s.hasValue))
        : ref.watch(householdsNotifierProvider.select((s) => s.isLoading && !s.hasValue));

    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: ColoredBox(
        color: context.appColors.bgPrimary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pill tab switcher
              AppPillTabBar(
                selectedIndex: isAccountsTab ? 1 : 0,
                tabs: [l10n.householdsTitle, l10n.householdsAccountsTabLabel],
                onTabSelected: _goToTab,
              ),
              const SizedBox(height: 16),

              // Search bar — one field serving both tabs
              if (isInitialLoading)
                const AppSearchFieldShimmer()
              else
                AppSearchField(
                  hintText: isAccountsTab ? l10n.accountsSearchHint : l10n.householdsSearchHint,
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onClear: _onClearSearch,
                ),
              const SizedBox(height: 12),

              // Routed tab content — the only part that transitions
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}

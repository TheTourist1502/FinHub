import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/real_time/domain/models/real_time_account.dart';
import 'package:finhub/features/real_time/presentation/providers/real_time_provider.dart';
import 'package:finhub/features/real_time/presentation/widgets/real_time_shimmer.dart';
import 'package:finhub/shared/widgets/feedback/app_error_code.dart';
import 'package:finhub/shared/widgets/feedback/app_error_widget.dart';
import 'package:finhub/shared/widgets/inputs/app_single_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Account-selection screen for the Real-Time tab.
///
/// Lets the advisor pick a financial account from a dropdown (backed by
/// [realTimeAccountsNotifierProvider]), then navigate to the real-time
/// detailed view for that account via [AppRoutes.realTimeDetailedView].
class RealTimeScreen extends ConsumerStatefulWidget {
  /// Creates a [RealTimeScreen].
  const RealTimeScreen({super.key});

  @override
  ConsumerState<RealTimeScreen> createState() => _RealTimeScreenState();
}

class _RealTimeScreenState extends ConsumerState<RealTimeScreen> {
  String? _selectedAccountId;

  Future<void> _onContinue() async {
    final id = _selectedAccountId;
    if (id == null) return;
    await context.push<void>(AppRoutes.realTimeDetailedView.replaceFirst(':accountId', id));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accountsAsync = ref.watch(realTimeAccountsNotifierProvider);
    final notifier = ref.read(realTimeAccountsNotifierProvider.notifier);

    return ColoredBox(
      color: colors.bgPrimary,
      child: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: notifier.refresh,
          // Crossfades the skeleton out as the data arrives instead of
          // cutting to it. The states are distinct widget types, so the
          // switcher detects the change without explicit keys.
          child: AnimatedSwitcher(
            duration: AppMotion.duration(context, AppMotion.base),
            child: accountsAsync.when(
              loading: () => const RealTimeShimmer(),
              // Retry runs the same refresh() as the pull gesture, which resets
              // to a bare loading state — so the shimmer shows while it works.
              error: (e, _) => _RealTimeError(error: e, onRetry: notifier.refresh),
              data: (listState) => _RealTimeContent(
                accounts: listState.accounts,
                selectedAccountId: _selectedAccountId,
                onAccountChanged: (id) => setState(() => _selectedAccountId = id),
                onContinue: _onContinue,
                shouldLazyLoadData: listState.shouldLazyLoadData,
                hasMore: listState.hasMore,
                loadingMore: listState.isLoadingMore,
                onLoadMore: notifier.loadMore,
                onSearchChanged: notifier.search,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

/// Full-screen error state for a failed account-list fetch.
///
/// Stretched to the full viewport inside an always-scrollable list so the
/// enclosing [RefreshIndicator] can still be pulled, giving the user a second
/// way to retry alongside the button.
class _RealTimeError extends StatelessWidget {
  const _RealTimeError({required this.error, required this.onRetry});

  /// The failure to translate into an [AppErrorCode].
  final Object error;

  /// Re-runs the account-list fetch.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: constraints.maxHeight,
            child: AppErrorWidget(
              errorCode: AppErrorCode.fromAppError(error is AppError ? error as AppError : const UnknownError()),
              onRetry: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _RealTimeContent extends StatefulWidget {
  const _RealTimeContent({
    required this.accounts,
    required this.selectedAccountId,
    required this.onAccountChanged,
    required this.onContinue,
    required this.shouldLazyLoadData,
    required this.hasMore,
    required this.loadingMore,
    required this.onLoadMore,
    required this.onSearchChanged,
  });

  final List<RealTimeAccount> accounts;
  final String? selectedAccountId;
  final ValueChanged<String?> onAccountChanged;
  final VoidCallback onContinue;

  /// Whether the account list is paged server-side.
  ///
  /// `false` when the first response returned every account at once — the
  /// picker then filters its options in memory and no pagination or
  /// search callback is wired up at all.
  final bool shouldLazyLoadData;

  /// Whether a subsequent page of accounts is available.
  final bool hasMore;

  /// Whether a pagination or search request is currently in flight.
  final bool loadingMore;

  /// Fetches the next page for the picker's currently active search term.
  final VoidCallback onLoadMore;

  /// Re-fetches the first page filtered by the picker's search text.
  final ValueChanged<String> onSearchChanged;

  @override
  State<_RealTimeContent> createState() => _RealTimeContentState();
}

class _RealTimeContentState extends State<_RealTimeContent> {
  /// Cached options list — only rebuilt when [widget.accounts] changes identity.
  late List<SelectOption<String>> _options;

  @override
  void initState() {
    super.initState();
    _options = _buildOptions(widget.accounts);
  }

  @override
  void didUpdateWidget(_RealTimeContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.accounts, widget.accounts)) {
      _options = _buildOptions(widget.accounts);
    }
  }

  List<SelectOption<String>> _buildOptions(List<RealTimeAccount> accounts) => accounts
      .map(
        (a) => SelectOption<String>(
          label: '${a.accountNumber} - ${a.accountName}',
          value: a.accountId,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final options = _options;

    return SingleChildScrollView(
      // Always scrollable so the enclosing RefreshIndicator can be pulled even
      // when the content is shorter than the viewport.
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Heading section ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  l10n.realTimeSelectAccountTitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.realTimeSelectAccountSubtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    height: 1.625,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Account dropdown + actions ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account selector
                AppSingleSelect<String>(
                  label: l10n.realTimeSelectAccountLabel,
                  hint: l10n.realTimeSelectAccountHint,
                  options: options,
                  value: widget.selectedAccountId,
                  onChanged: widget.onAccountChanged,
                  // In client mode both callbacks stay null, which is what
                  // switches AppSingleSelect back to its built-in local
                  // label filter and hides the pagination spinner.
                  hasMore: widget.shouldLazyLoadData && widget.hasMore,
                  loadingMore: widget.loadingMore,
                  onLoadMore: widget.shouldLazyLoadData ? widget.onLoadMore : null,
                  onSearchChanged: widget.shouldLazyLoadData ? widget.onSearchChanged : null,
                ),
                const SizedBox(height: 32),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: widget.selectedAccountId != null ? widget.onContinue : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.interactiveDefault,
                      disabledBackgroundColor: colors.interactiveDefault.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text(
                      l10n.commonButtonContinue,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

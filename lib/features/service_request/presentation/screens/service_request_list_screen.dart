import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/service_request/domain/models/service_request_item.dart';
import 'package:finhub/features/service_request/presentation/providers/service_request_provider.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_card.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_detail_bottom_sheet.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_filter_chips.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_search_row.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_shimmer.dart';
import 'package:finhub/shared/animations/pressable.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:finhub/shared/widgets/feedback/no_record_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Service Requests tab — search, All/Open/Closed filter, a list grouped into
/// Open and Closed sections, and the entry point into the New Service Request
/// form.
///
/// The screen is fed by two independent endpoints (open and closed). It
/// waits on both before showing anything, then hands each filter chip its own
/// source, so one endpoint failing costs only its own tab — the other stays
/// usable and the failed one offers a retry that re-runs just that call.
///
/// Deliberately holds no `ref.watch` of its own: everything fetch-dependent
/// lives below [_ServiceRequestRefreshableBody], so the page chrome and the
/// floating CTA are built once and skipped on every subsequent provider change.
///
/// The app bar and bottom navigation are provided by the home shell screen.
class ServiceRequestListScreen extends StatelessWidget {
  /// Creates a [ServiceRequestListScreen].
  const ServiceRequestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appColors.bgPrimary,
      child: const SafeArea(
        top: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 88),
              child: _ServiceRequestRefreshableBody(),
            ),
            Positioned(left: 24, right: 24, bottom: 16, child: _NewServiceRequestButton()),
          ],
        ),
      ),
    );
  }
}

/// Swaps the whole page between its skeleton and its loaded content, both
/// under one pull-to-refresh.
///
/// [RefreshIndicator] sits *above* the swap on purpose. Both endpoints report
/// `isLoading` during a refresh as well as a first load, so a refresh replaces
/// the content with the skeleton — with the indicator any lower it would be
/// torn down mid-gesture and take its spinner with it.
class _ServiceRequestRefreshableBody extends ConsumerWidget {
  const _ServiceRequestRefreshableBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Both endpoints gate the chrome as well as the list: until they settle
    // there is no reliable chip set to draw, since an error withdraws "All".
    final isLoading = ref.watch(serviceRequestsLoadingProvider);

    return RefreshIndicator(
      onRefresh: () => _refreshAll(ref),
      // Crossfades the skeleton out as the data arrives instead of cutting to
      // it. The two states are distinct widget types, so the switcher detects
      // the change without explicit keys.
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.base),
        child: isLoading ? const ServiceRequestListShimmer() : const _ServiceRequestLoadedView(),
      ),
    );
  }
}

/// Loaded page: search row, filter chips, and the result region below them.
class _ServiceRequestLoadedView extends StatelessWidget {
  const _ServiceRequestLoadedView();

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      ServiceRequestSearchRow(),
      SizedBox(height: kServiceRequestSectionGap),
      ServiceRequestFilterChips(),
      SizedBox(height: kServiceRequestSectionGap),
      Expanded(child: _ServiceRequestResultView()),
    ],
  );
}

/// Re-runs both status endpoints for a pull-to-refresh.
///
/// A rejection is contained here rather than allowed to escape into
/// [RefreshIndicator], where an uncaught error reaches the global handler in
/// `main.dart` and is reported as a crash. Nothing is lost by swallowing it:
/// each provider still carries its own failure in its `AsyncValue`, which the
/// tab renders as an [ErrorView] with a retry.
Future<void> _refreshAll(WidgetRef ref) async {
  try {
    await Future.wait<void>([
      ref.refresh(serviceRequestsProvider.future),
      ref.refresh(closedServiceRequestsProvider.future),
    ]);
  } on Object catch (e, s) {
    AppLogger.e('ServiceRequestListScreen: pull-to-refresh failed', e, s);
  }
}

/// Floating pill that opens the New Service Request form.
class _NewServiceRequestButton extends StatelessWidget {
  const _NewServiceRequestButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Pressable(
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.newServiceRequest),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: colors.bgBrandNavyBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.bgBrandNavyBlue.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Iconify(Mdi.plus, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.serviceRequestNewButton,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Picks between the selected tab's failure state and its list.
///
/// Loading is already handled by [_ServiceRequestRefreshableBody], so this only ever sees
/// a settled `AsyncValue`.
class _ServiceRequestResultView extends ConsumerWidget {
  const _ServiceRequestResultView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredServiceRequestsProvider);
    final error = filtered.error;

    if (error != null) return _ServiceRequestErrorView(error: error);
    return _ServiceRequestList(requests: filtered.requireValue);
  }
}

/// Retryable failure for the tab in force.
class _ServiceRequestErrorView extends ConsumerWidget {
  const _ServiceRequestErrorView({required this.error});

  /// Whatever the tab's endpoint threw; anything untyped is surfaced as an
  /// [UnknownError] so the view always has a message to render.
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(effectiveServiceRequestFilterProvider);
    final failure = error;

    return _ScrollableFiller(
      child: ErrorView(
        error: failure is AppError ? failure : const UnknownError(),
        // Retry only the endpoint behind the tab being shown; the other tab's
        // data is still good and must not be thrown away.
        onRetry: () => ref.invalidate(
          filter == ServiceRequestFilter.closed ? closedServiceRequestsProvider : serviceRequestsProvider,
        ),
      ),
    );
  }
}

/// Empty state, worded for whether a search is narrowing the list.
class _ServiceRequestEmptyView extends ConsumerWidget {
  const _ServiceRequestEmptyView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final searchQuery = ref.watch(serviceRequestSearchQueryProvider);

    return _ScrollableFiller(
      child: NoRecordWidget(
        widthFactor: 0.45,
        message: searchQuery.trim().isNotEmpty ? l10n.serviceRequestEmptySearch : l10n.serviceRequestEmpty,
      ),
    );
  }
}

/// Loaded content: count heading above the Open and Closed sections.
class _ServiceRequestList extends StatelessWidget {
  const _ServiceRequestList({required this.requests});

  /// Already search-filtered requests for the selected tab.
  final List<ServiceRequestItem> requests;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) return const _ServiceRequestEmptyView();

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverPadding(padding: EdgeInsets.only(top: 4)),
        _ServiceRequestCountHeading(count: requests.length),
        for (final group in _groupByCategory(requests)) _ServiceRequestGroupSliver(group: group),
        const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }
}

/// Count heading for the tab in force, e.g. "12 ACTIVE REQUESTS".
///
/// Watches the filter itself rather than taking it as a parameter, so a chip
/// change repaints only this heading and leaves the built sliver list alone.
class _ServiceRequestCountHeading extends ConsumerWidget {
  const _ServiceRequestCountHeading({required this.count});

  /// Number of requests currently rendered, already search-filtered.
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final filter = ref.watch(effectiveServiceRequestFilterProvider);

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          _headingLabel(filter, count, l10n).toUpperCase(),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.7,
          ),
        ),
      ),
    );
  }
}

/// One category section: its label, its cards, and the gap beneath.
///
/// Bundled into a single [SliverMainAxisGroup] so a section is one entry in
/// the scroll view's sliver list rather than three loose ones.
class _ServiceRequestGroupSliver extends ConsumerWidget {
  const _ServiceRequestGroupSliver({required this.group});

  /// The bucket to render — its category picks the section label.
  final _ServiceRequestCategoryGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Only the "All" tab mixes active and closed requests, so only there does
    // the category label say something the count heading has not already said.
    final showLabel = ref.watch(effectiveServiceRequestFilterProvider) == ServiceRequestFilter.all;

    return SliverMainAxisGroup(
      slivers: [
        if (showLabel)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ServiceRequestSectionLabel(label: _sectionLabel(group.category, l10n)),
            ),
          ),
        _StandaloneCardsSliver(requests: group.requests),
        const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }
}

/// One card per request.
///
/// Spaces siblings with a trailing gap on all but the last card, so the
/// section ends flush with the padding [_ServiceRequestGroupSliver] adds after
/// it rather than doubling up on it.
class _StandaloneCardsSliver extends StatelessWidget {
  const _StandaloneCardsSliver({required this.requests});

  /// Requests in this section, in the order they are rendered.
  final List<ServiceRequestItem> requests;

  @override
  Widget build(BuildContext context) => SliverList.builder(
    itemCount: requests.length,
    // Rows deal in one at a time as the reader scrolls to them, the same
    // entrance the accounts and households lists use.
    itemBuilder: (context, index) => SettleIn(
      index: index,
      revealOnScroll: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: index == requests.length - 1 ? 0 : 8),
        child: Pressable(
          child: ServiceRequestStandaloneCard(
            request: requests[index],
            onView: () => showServiceRequestDetailBottomSheet(context, requests[index]),
          ),
        ),
      ),
    ),
  );
}

/// Count heading for [filter].
String _headingLabel(ServiceRequestFilter filter, int count, AppLocalizations l10n) => switch (filter) {
  ServiceRequestFilter.all => l10n.serviceRequestHeadingAll(count),
  ServiceRequestFilter.active => l10n.serviceRequestHeadingActive(count),
  ServiceRequestFilter.closed => l10n.serviceRequestHeadingClosed(count),
};

/// Localised section header for [category].
String _sectionLabel(ServiceRequestCategory category, AppLocalizations l10n) => switch (category) {
  ServiceRequestCategory.active => l10n.serviceRequestSectionActive,
  ServiceRequestCategory.closed => l10n.serviceRequestSectionClosed,
};

/// Buckets [requests] into Open and Closed, in that fixed section order.
///
/// A category with no requests contributes no section, so a single-status tab
/// still renders exactly one group.
List<_ServiceRequestCategoryGroup> _groupByCategory(List<ServiceRequestItem> requests) {
  final map = <ServiceRequestCategory, List<ServiceRequestItem>>{};
  for (final request in requests) {
    map.putIfAbsent(request.category, () => []).add(request);
  }

  return [
    for (final category in ServiceRequestCategory.values)
      if (map[category] != null) _ServiceRequestCategoryGroup(category, map[category]!),
  ];
}

/// One category bucket of requests, as produced by [_groupByCategory].
///
/// Exists so the grouping pass can hand the sliver list a category alongside
/// its rows; a bare `Map` entry would lose the fixed section ordering that
/// [_groupByCategory] establishes.
class _ServiceRequestCategoryGroup {
  const _ServiceRequestCategoryGroup(this.category, this.requests);

  /// Bucket these requests fell into — drives the section label.
  final ServiceRequestCategory category;

  /// Requests in this bucket, in the order the API returned them.
  final List<ServiceRequestItem> requests;
}

/// Stretches [child] to the viewport height inside a scrollable, so the
/// pull-to-refresh gesture still has something to grab on a short page.
class _ScrollableFiller extends StatelessWidget {
  const _ScrollableFiller({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [SizedBox(height: constraints.maxHeight, child: child)],
      ),
    );
  }
}
